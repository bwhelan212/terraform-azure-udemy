# #inbound nat rule for lb
# resource "azurerm_lb_nat_rule" "web_lb_nat_rule" {
#   depends_on                     = [azurerm_linux_virtual_machine.web_linuxvm] #handles depednecy bugs during destroy
#   for_each                       = var.web_linuxvm_instance_count
#   name                           = "${each.key}-ssh-${each.value}-vm-22"
#   resource_group_name            = azurerm_resource_group.rg.name
#   loadbalancer_id                = azurerm_lb.web_lb.id
#   frontend_ip_configuration_name = azurerm_lb.web_lb.frontend_ip_configuration[0].name
#   frontend_port                  = each.value
#   backend_port                   = 22
#   protocol                       = "Tcp"
# }

# #associate lb nat rule with vm nic 
# resource "azurerm_network_interface_nat_rule_association" "web_nic_nat_rule_associate" {
#   for_each              = var.web_linuxvm_instance_count
#   network_interface_id  = azurerm_network_interface.web_linuxvm_nic[each.key].id
#   ip_configuration_name = azurerm_network_interface.web_linuxvm_nic[each.key].ip_configuration[0].name
#   nat_rule_id           = azurerm_lb_nat_rule.web_lb_nat_rule[each.key].id
# }