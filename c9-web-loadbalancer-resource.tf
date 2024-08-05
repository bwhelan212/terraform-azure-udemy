# # resource 1: create public ip for azure lb
# resource "azurerm_public_ip" "web_lb_publicip" {
#   name                = "${local.resource_name_prefix}-web-lbpublicip"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   tags                = local.common_tags
# }

# # resource 2: create azure lb
# resource "azurerm_lb" "web_lb" {
#   name                = "${local.resource_name_prefix}-web-lb"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   sku                 = "Standard"
#   frontend_ip_configuration {
#     name                 = "web-lb-publicip-1"
#     public_ip_address_id = azurerm_public_ip.web_lb_publicip.id
#   }
# }

# #resource 3: create lb backend pool
# resource "azurerm_lb_backend_address_pool" "web_lb_backend_pool" {
#   name            = "web-backend"
#   loadbalancer_id = azurerm_lb.web_lb.id
# }

# #resource 4: create lb probe
# resource "azurerm_lb_probe" "web_lb_probe" {
#   name            = "tcp-probe"
#   loadbalancer_id = azurerm_lb.web_lb.id
#   protocol        = "Tcp"
#   port            = 80
# }

# #resource 5: create lb rule
# resource "azurerm_lb_rule" "web_lb_rule_app1" {
#   name                           = "web-app1-rule"
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
#   backend_address_pool_ids       = [azurerm_lb_backend_address_pool.web_lb_backend_pool.id]
#   loadbalancer_id                = azurerm_lb.web_lb.id
#   probe_id                       = azurerm_lb_probe.web_lb_probe.id
# }

# #resource 6: associate network interface and standard load balancer
# #comment out bc vmss uses backend address pool instead
# # resource "azurerm_network_interface_backend_address_pool_association" "web_vmnic_lb_association" {
# #   for_each                = var.web_linuxvm_instance_count
# #   network_interface_id    = azurerm_network_interface.web_linuxvm_nic[each.key].id
# #   ip_configuration_name   = azurerm_network_interface.web_linuxvm_nic[each.key].ip_configuration[0].name
# #   backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_pool.id
# # }