# variable "app_vmss_nsg_inbound_ports" {
#   description = "App VMSS NSG inbound ports"
#   type        = list(string)  # can also use set or map, diff implementations tho
#   default     = [22, 80, 443] # key = 0,1,2
# }