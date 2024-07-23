#Outputs for virtual netowrk

#virtual network name
output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

#vnet id
output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

#outputs for each subnet
#web subnet name
output "web_subnet_name" {
  description = "Name of the webtier subnet"
  value       = azurerm_subnet.websubnet.name
}

#web subnet id
output "web_subnet_id" {
  description = "ID of the webtier subnet"
  value       = azurerm_subnet.websubnet.id
}

#nsg outputs
#web subnet nsg name
output "web_subnet_nsg_name" {
  description = "Name of the webtier subnet NSG"
  value       = azurerm_network_security_group.web_subnet_nsg.name
}

#web subnet nsg id
output "web_subnet_nsg_id" {
  description = "ID of the webtier subnet NSG"
  value       = azurerm_network_security_group.web_subnet_nsg.id
}
# #app subnet name
# output "app_subnet_name" {
#     description = "Name of the apptier subnet"
#     value = azurerm_subnet.appsubnet.name
# }

# #app subnet id
# output "app_subnet_id" {
#     description = "ID of the apptier subnet"
#     value = azurerm_subnet.appsubnet.id
# }

# #db subnet name
# output "db_subnet_name" {
#     description = "Name of the dbtier subnet"
#     value = azurerm_subnet.dbsubnet.name
# }

# #db subnet id
# output "db_subnet_id" {
#     description = "ID of the dbtier subnet"
#     value = azurerm_subnet.dbsubnet.id
# }

# #bastion subnet name
# output "bastion_subnet_name" {
#     description = "Name of the bastion subnet"
#     value = azurerm_subnet.bastionsubnet.name
# }

# #bastion subnet id
# output "bastion_subnet_id" {
#     description = "ID of the bastion subnet"
#     value = azurerm_subnet.bastionsubnet.id
# }


