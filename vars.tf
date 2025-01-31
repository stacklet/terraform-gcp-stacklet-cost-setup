variable "prefix" {
    type        = string
    default     = "stacklet"
    description = "ID prefix applied to all resources"
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

variable "source_tables" {
    type        = list(string)
    description = "Billing export tables in <project_id>.<dataset_id>.<table_id> format."
    validation {
        condition     = alltrue([for t in var.source_tables : length(split(".", t)) == 3])
        error_message = "All source tables must be <project_id>.<dataset_id>.<table_id>"
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
