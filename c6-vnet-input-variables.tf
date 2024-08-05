# virtual network, subnets, and subnet network security groups

##virtual network
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-default"
}

variable "vnet_address_space" {
  description = "Address space of the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# Web Subnet 
variable "web_subnet_name" {
  description = "Virtual network web subnet name"
  type        = string
  default     = "web-subnet"
}

variable "web_subnet_address" {
  description = "Address space of the web subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# App subnet

variable "app_subnet_name" {
  description = "Virtual network app subnet name"
  type        = string
  default     = "app-subnet"
}

variable "app_subnet_address" {
  description = "Address space of the app subnet in vnet"
  type        = list(string)
  default     = ["10.0.11.0/24"]
}

# DB subnet
variable "db_subnet_name" {
  description = "Virtual network db subnet name"
  type        = string
  default     = "db-subnet"
}

variable "db_subnet_address" {
  description = "Address space of the db subnet in vnet"
  type        = list(string)
  default     = ["10.0.21.0/24"]
}

#Bastion subnet
variable "bastion_subnet_name" {
  description = "Virtual network bastion subnet name"
  type        = string
  default     = "bastion-subnet"
}

variable "bastion_subnet_address" {
  description = "Address space of the bastion subnet in vnet"
  type        = list(string)
  default     = ["10.0.100.0/24"]
}

# Application Gateway Subnet Name
variable "ag_subnet_name" {
  description = "Virtual Network Application Gateway Subnet Name"
  type = string
  default = "agsubnet"
}
# Application Gateway Subnet Address Space
variable "ag_subnet_address" {
  description = "Virtual Network Application Gateway Subnet Address Spaces"
  type = list(string)
  default = ["10.0.51.0/24"]
}