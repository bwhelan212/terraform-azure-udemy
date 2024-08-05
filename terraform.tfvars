business_division       = "hr"
environment             = "dev"
resource_group_name     = "rg"
resource_group_location = "eastus"
vnet_name               = "vnet"
vnet_address_space      = ["10.1.0.0/16"]

#web subent
web_subnet_name    = "web-subnet"
web_subnet_address = ["10.1.1.0/24"]


#app subnet
app_subnet_name    = "app-subnet"
app_subnet_address = ["10.1.11.0/24"]

#db subnet
db_subnet_name    = "db-subnet"
db_subnet_address = ["10.1.21.0/24"]

#bastion subnet
bastion_subnet_name    = "bastion-subnet"
bastion_subnet_address = ["10.1.100.0/27"]

#bastion service subnet
# bastion_service_subnet_name      = "AzureBastionSubnet"
# bastion_service_address_prefixes = ["10.1.101.0/27"]

# web_linuxvm_instance_count = {
#   "vm1" = "1022",
#   "vm2" = "1023"
# }

web_vmss_nsg_inbound_ports = [ 22,80,443 ]
# app_vmss_nsg_inbound_ports = [ 22,80,443 ]
ag_subnet_name = "agsubnet"
ag_subnet_address = ["10.1.51.0/24"]

storage_account_name = "staticwebsite"
storage_account_tier = "Standard"
storage_account_replication_type = "LRS"
storage_account_kind = "StorageV2"
static_website_index_document = "index.html"
static_website_error_404_document = "error.html"