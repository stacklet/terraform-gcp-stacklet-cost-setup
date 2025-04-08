variable "resource_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the project and applicable resources."
}

variable "resource_prefix" {
  type        = string
  default     = ""
  description = "If set, prepended to all non-project resource identifiers."
}

variable "project_id" {
  type        = string
  description = "ID of project to hold all resources."
}

variable "create_project" {
  type        = bool
  default     = true
  description = <<EOT
To create resources in a pre-existing project, set this to false.

The pre-existing project must have the 'iamcredentials' and 'bigquery' services enabled.
EOT
}

variable "project_org_id" {
  type        = string
  default     = null
  description = "Where to create the project (optional, exclusive of project_folder_id)."

  validation {
    condition     = (var.project_org_id == null) || (var.create_project)
    error_message = "project_org_id is only meaningful when this module is responsible for the project."
  }
}

variable "project_folder_id" {
  type        = string
  default     = null
  description = "Where to create the project (optional, exclusive of project_org_id)."

  validation {
    condition     = var.project_org_id == null || var.project_folder_id == null
    error_message = "project_org_id and project_folder_id are exclusive."
  }

  validation {
    condition     = var.project_folder_id == null || var.create_project
    error_message = "project_folder_id is only meaningful when this module is responsible for the project."
  }
}

variable "project_billing_account_id" {
  type        = string
  default     = null
  description = "Billing account responsible for any costs incurred."

  validation {
    condition     = var.project_billing_account_id == null || var.create_project
    error_message = "project_billing_account_id is only meaningful when this module is responsible for the project."
  }
}

variable "billing_tables" {
  type        = list(string)
  description = "Billing export tables in '<project_id>.<dataset_id>.<table_id>' format."
  validation {
    condition     = alltrue([for t in var.billing_tables : length(split(".", t)) == 3])
    error_message = "All tables must be '<project_id>.<dataset_id>.<table_id>'."
  }
}

variable "stacklet_aws_account_id" {
  type        = string
  description = "AWS account which will use WIF to query billing data (chosen by Stacklet)."
}

variable "stacklet_aws_role_name" {
  type        = string
  description = "AWS IAM role which will use WIF to query billing data (chosen by Stacklet)."
}

variable "roundtrip_digest" {
  type        = string
  default     = null
  description = "Token used by the Stacklet Platform to detect mismatch between customerConfig and accessConfig."
}