# input variables for strorage account

variable "storage_account_name" {
    description = "Name of storage account"
    type        = string
}

variable "storage_account_tier" {
    description = "Tier of storage account"
    type        = string
}

variable "storage_account_replication_type" {
    description = "Replication type of storage account"
    type        = string
}

variable "storage_account_kind" {
    description = "Kind of storage account"
    type        = string
}

variable "static_website_index_document" {
    description = "static website index document"
    type = string
}

variable "static_website_error_404_document" {
    description = "static website error 404 document"
    type = string
}