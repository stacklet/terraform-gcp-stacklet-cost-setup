variable "resource_labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the project and applicable resources"
}

variable "project_id" {
  type        = string
  description = "ID of project to hold all resources"
}

variable "project_org_id" {
  type        = string
  default     = null
  description = "Where to create the project (optional, exclusive of project_folder_id)"
}

variable "project_folder_id" {
  type        = string
  default     = null
  description = "Where to create the project (optional, exclusive of project_org_id)"
}

variable "project_billing_account_id" {
  type        = string
  default     = null
  description = "Billing account responsible for any costs incurred"
}

variable "billing_tables" {
  type        = list(string)
  description = "Billing export tables in <project_id>.<dataset_id>.<table_id> format."
  validation {
    condition     = alltrue([for t in var.billing_tables : length(split(".", t)) == 3])
    error_message = "All tables must be <project_id>.<dataset_id>.<table_id>"
  }
}

variable "stacklet_aws_account_id" {
  type        = string
  description = "AWS account which will use WIF to query billing data (chosen by Stacklet)"
}

variable "stacklet_aws_role_name" {
  type        = string
  description = "AWS IAM role which will use WIF to query billing data (chosen by Stacklet)"
}
