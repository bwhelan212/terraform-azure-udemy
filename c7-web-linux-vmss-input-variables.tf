variable "web_vmss_nsg_inbound_ports" {
  description = "Web VMSS NSG inbound ports"
  type        = list(string)  # can also use set or map, diff implementations tho
  default     = [22, 80, 443] # key = 0,1,2
}