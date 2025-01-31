locals {
    stacklet_assumed_role = "arn:aws:sts::${var.stacklet_aws_account_id}:assumed-role/${var.stacklet_aws_role_name}"

    source_tables = [for key in var.source_tables : {
        "key"        : key,
        "project_id" : split(".", key)[0],
        "dataset_id" : split(".", key)[1],
        "table_id"   : split(".", key)[2],
    }]
}


# A project for all the resources to live in, and the APIs it needs activated.
resource "google_project" "billing_export" {
    name            = "Stacklet billing export"
    project_id      = "${var.prefix}-billing-export"
    org_id          = var.project_org_id
    folder_id       = var.project_folder_id
    billing_account = var.project_billing_account_id
}
resource "google_project_service" "iamcredentials" {
    project = google_project.billing_export.project_id
    service = "iamcredentials.googleapis.com"
}
resource "google_project_service" "bigquery" {
    project = google_project.billing_export.project_id
    service = "bigquery.googleapis.com"
}


# Allow AWS roles from the Stacklet account to assume identities in GCP.
resource "google_iam_workload_identity_pool" "stacklet_access" {
    project                   = google_project.billing_export.project_id
    workload_identity_pool_id = "${var.prefix}-stacklet-access"
    display_name              = "Stacklet billing export"
}
resource "google_iam_workload_identity_pool_provider" "stacklet_account" {
    project                            = google_project.billing_export.project_id
    workload_identity_pool_id          = google_iam_workload_identity_pool.stacklet_access.workload_identity_pool_id
    workload_identity_pool_provider_id = "${var.prefix}-stacklet-account"
    display_name                       = "Stacklet FOCUS export"
    disabled                           = false

    # The default attribute mapping for AWS sets `aws_role` attribute which matches the
    # `local.stacklet_assumed_role` as used in the service account IAM policy.
    aws {
        account_id = var.stacklet_aws_account_id
    }
}


# Service account, which can be impersonated by `local.stacklet_assumed_role`.
resource "google_service_account" "billing_access" {
    project      = google_project.billing_export.project_id
    account_id   = "${var.prefix}-billing-access"
    display_name = "Stacklet WIF billing access"
}
data "google_iam_policy" "stacklet_role_access" {
    binding {
        role = "roles/iam.serviceAccountTokenCreator"
        members = ["principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.stacklet_access.name}/attribute.aws_role/${local.stacklet_assumed_role}"]
    }
}
resource "google_service_account_iam_policy" "billing_access" {
  service_account_id = google_service_account.billing_access.name
  policy_data        = data.google_iam_policy.stacklet_role_access.policy_data
}


# Access for the service account to the resources needed to query billing data.
resource "google_project_iam_member" "sa_bq_jobs" {
  project = google_project.billing_export.id
  role    = "roles/bigquery.jobUser"
  member  = google_service_account.billing_access.member
}
resource "google_bigquery_table_iam_member" "sa_bq_tables" {
    for_each = { for table in local.source_tables : table.key => table }

    project    = each.value.project_id
    dataset_id = each.value.dataset_id
    table_id   = each.value.table_id
    role       = "roles/bigquery.dataViewer"
    member     = google_service_account.billing_access.member
}
