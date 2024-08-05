# # lb public ip
# output "web_lb_public_ip" {
#   description = "Public IP address of the Azure Load Balancer"
#   value       = azurerm_public_ip.web_lb_publicip.ip_address
# }
# #lb id
# output "web_lb_id" {
#   description = "ID of the Azure Load Balancer"
#   value       = azurerm_lb.web_lb.id
# }

# output "web_lb_frontend_ip_configuration" {
#   description = "Frontend IP configuration of the Azure Load Balancer"
#   value       = azurerm_lb.web_lb.frontend_ip_configuration[0].name
# }