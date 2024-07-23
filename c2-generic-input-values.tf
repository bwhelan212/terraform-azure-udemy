# input variables
variable "business_division" {
  description = "Business Division of the large corporation the infrastructure belongs to"
  type        = string
  default     = "sap"
}

# environment
variable "environment" {
  description = "Environment the infrastructure is deployed in"
  type        = string
  default     = "dev"
}

# azure resource group name
variable "resource_group_name" {
  description = "Name of Resource group"
  type        = string
  default     = "rg-default"
}

variable "resource_group_location" {
  description = "Location of Resource group"
  type        = string
  default     = "eastus"
}