# terraform-gcp-stacklet-cost-setup

This repository provides automation for granting Stacklet access to pre-existing billing data exports in BigQuery, via Workload Identity Federation.

# Overview

The terraform in this repository allows a single Stacklet-controlled AWS IAM role to execute BigQuery jobs against any number of billing data exports in GCP. Suitable configuration variables will be supplied by Stacklet, and the resulting outputs must be communicated back to Stacklet.

<!-- BEGIN_TF_DOCS -->
## Requirements

It must be applied by an identity with sufficient privileges to:
* grant `roles/bigquery.dataViewer` on each configured billing export table
* (if `create_project` is set) create a project and associate a billing account id

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.23.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.12.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_bigquery_table_iam_member.sa_bq_tables](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table_iam) | resource |
| [google_iam_workload_identity_pool.stacklet_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.stacklet_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_project.billing_export](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project) | resource |
| [google_project_iam_member.sa_bq_jobs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam) | resource |
| [google_project_service.bigquery](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service) | resource |
| [google_project_service.iamcredentials](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service) | resource |
| [google_service_account.billing_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account) | resource |
| [google_service_account_iam_policy.billing_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam) | resource |
| [time_sleep.stacklet_access_creation_delay](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [google_bigquery_dataset.table_datasets](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/bigquery_dataset) | data source |
| [google_iam_policy.stacklet_role_access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |
| [google_project.existing_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_tables"></a> [billing\_tables](#input\_billing\_tables) | Billing export tables in '<project\_id>.<dataset\_id>.<table\_id>' format. | `list(string)` | n/a | yes |
| <a name="input_create_project"></a> [create\_project](#input\_create\_project) | To create resources in a pre-existing project, set this to false.<br/><br/>The pre-existing project must have the 'iamcredentials' and 'bigquery' services enabled. | `bool` | `true` | no |
| <a name="input_project_billing_account_id"></a> [project\_billing\_account\_id](#input\_project\_billing\_account\_id) | Billing account responsible for any costs incurred. | `string` | `null` | no |
| <a name="input_project_folder_id"></a> [project\_folder\_id](#input\_project\_folder\_id) | Where to create the project (optional, exclusive of project\_org\_id). | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | ID of project to hold all resources. | `string` | n/a | yes |
| <a name="input_project_org_id"></a> [project\_org\_id](#input\_project\_org\_id) | Where to create the project (optional, exclusive of project\_folder\_id). | `string` | `null` | no |
| <a name="input_resource_labels"></a> [resource\_labels](#input\_resource\_labels) | Labels to apply to the project and applicable resources. | `map(string)` | `{}` | no |
| <a name="input_resource_prefix"></a> [resource\_prefix](#input\_resource\_prefix) | If set, prepended to all non-project resource identifiers. | `string` | `""` | no |
| <a name="input_roundtrip_digest"></a> [roundtrip\_digest](#input\_roundtrip\_digest) | Token used by the Stacklet Platform to detect mismatch between customerConfig and accessConfig. | `string` | `null` | no |
| <a name="input_stacklet_aws_account_id"></a> [stacklet\_aws\_account\_id](#input\_stacklet\_aws\_account\_id) | AWS account which will use WIF to query billing data (chosen by Stacklet). | `string` | n/a | yes |
| <a name="input_stacklet_aws_role_name"></a> [stacklet\_aws\_role\_name](#input\_stacklet\_aws\_role\_name) | AWS IAM role which will use WIF to query billing data (chosen by Stacklet). | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_blob"></a> [access\_blob](#output\_access\_blob) | n/a |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | n/a |
| <a name="output_table_locations"></a> [table\_locations](#output\_table\_locations) | n/a |
| <a name="output_wif_audience"></a> [wif\_audience](#output\_wif\_audience) | n/a |
| <a name="output_wif_impersonation_url"></a> [wif\_impersonation\_url](#output\_wif\_impersonation\_url) | n/a |
<!-- END_TF_DOCS -->