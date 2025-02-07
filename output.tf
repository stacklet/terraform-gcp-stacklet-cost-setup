locals {
    project_id            = google_project.billing_export.project_id
    table_locations       = { for key in var.billing_tables :  key => data.google_bigquery_dataset.table_datasets[key].location }
    wif_audience          = "//iam.googleapis.com/projects/${google_project.billing_export.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.stacklet_access.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.stacklet_account.workload_identity_pool_provider_id}"
    wif_impersonation_url = "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${google_service_account.billing_access.email}:generateAccessToken"
}

output "project_id" {
    value = local.project_id
}

output "table_locations" {
    value = local.table_locations
}

output "wif_audience" {
    value = local.wif_audience
}

output "wif_impersonation_url" {
    value = local.wif_impersonation_url
}

output "combined_payload" {
    value = base64encode(jsonencode({
        project_id            = local.project_id,
        table_locations       = local.table_locations,
        wif_audience          = local.wif_audience,
        wif_impersonation_url = local.wif_impersonation_url,
    }))
}