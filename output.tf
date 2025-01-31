output "project_id" {
    value = google_project.billing_export.project_id
}

output "wif_audience" {
    value = "//iam.googleapis.com/projects/${google_project.billing_export.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.stacklet_access.workload_identity_pool_id}/providers/${google_iam_workload_identity_pool_provider.stacklet_account.workload_identity_pool_provider_id}"
}

output "wif_impersonation_url" {
    value = "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/${google_service_account.billing_access.email}:generateAccessToken"
}