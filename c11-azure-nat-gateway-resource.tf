# # can manage outbound traffic with nat gateway
# # resource 1: create the public ip for azure nat gateway
# resource "azurerm_public_ip" "natgw_publicip" {
#     name = "${local.resource_name_prefix}-natgw-pip"
#     location = azurerm_resource_group.rg.location
#     resource_group_name = azurerm_resource_group.rg.name
#     allocation_method = "Static"
#     sku = "Standard"
# }

# # resource 2: create azure nat gateway
# resource "azurerm_nat_gateway" "natgw" {
#   name = "${local.resource_name_prefix}-natgw"
#   location = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku_name = "Standard"
  
# }

# # resource 3: associate azure nat gateway and public ip
# resource "azurerm_nat_gateway_public_ip_association" "natgw_pip_associate" {
#   nat_gateway_id = azurerm_nat_gateway.natgw.id
#   public_ip_address_id = azurerm_public_ip.natgw_publicip.id
# }

# # resource 4: associate appsubnet and azure and gateway
# resource "azurerm_subnet_nat_gateway_association" "natgw_appsubnet_associate" {
#   subnet_id = azurerm_subnet.appsubnet.id
#   nat_gateway_id = azurerm_nat_gateway.natgw.id
#  }
