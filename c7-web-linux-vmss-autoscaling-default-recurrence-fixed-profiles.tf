# # main difference between profiles is the capacity, rules are the same
# # resource for austocale settings (works with other resources besides vmss like app service)
# # azure error: in azure for the vmss resource hr-dev-web-vmss under scaling, the autoscale up was initated and failed -> issue with student account? (also in activity log)
# resource "azurerm_monitor_autoscale_setting" "web_vmss_autoscale" {
#   name                = "${local.resource_name_prefix}-web-vmss-autoscale-profiles"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   target_resource_id  = azurerm_linux_virtual_machine_scale_set.web_vmss.id

#   #notification block
#   # notification {
#   #   email {
#   #     send_to_subscription_administrator = true
#   #     send_to_subscription_co_administrator = true
#   #     custom_emails = ["adminteam@ourorg.com"]
#   #   }
#   # }

#   #default profile block
#   profile {
#     name = "profile-1-default-block"

#     #capacity block
#     capacity {
#       default = 1
#       minimum = 1
#       maximum = 6
#     }

#     ### cpu metric rules
#     # scale out
#     rule {
#       scale_action {
#         direction = "Increase" #bc scale out
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }
#       metric_trigger {
#         metric_name        = "Percentage CPU" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "microsoft.compute/virtualmachinescalesets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 75
#       }
#     }

#     #scale in rule
#     rule {
#       scale_action {
#         direction = "Decrease" #bc scale out
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Percentage CPU" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "microsoft.compute/virtualmachinescalesets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 25
#       }
#     }

#     ### Available memory bytes metric rules
#     #scale out
#     rule {
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Available Memory Bytes" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 1073741824 #increase 1 VM when memory in bytes less than 1 GB
#       }
#     }

#     #scale in
#     rule {
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Available Memory Bytes" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 2147483648 #decrease 1 VM when memory in bytes greater than 2 GB
#       }
#     }

#     ### LB SYN Count metric Rules (just to test scale in and scale out)   
#     # Scale-out
#     rule {
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "SYNCount" #must match exactly w/azure
#         metric_resource_id = azurerm_lb.web_lb.id
#         metric_namespace   = "Microsoft.Network/loadBalancers"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 10 #10 requests to a LB
#       }
#     }
#     # Scale-in
#     rule {
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "SYNCount" #must match exactly w/azure
#         metric_resource_id = azurerm_lb.web_lb.id
#         metric_namespace   = "Microsoft.Network/loadBalancers"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 10 #10 requests to a LB
#       }
#     }
#   } # end of profile 1

#   ### recurrence block profile for week days
#   # profile 2

#   profile {
#     name = "profile-2-weekdays"
#     capacity {
#       default = 2
#       minimum = 2
#       maximum = 20
#     }

#     recurrence {
#       timezone = "Pacific Standard Time"
#       days     = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
#       hours    = [0] #12 AM
#       minutes  = [0] # 00:00 -> 12 am
#     }

#     ###CPU metrics rules 
#     #scale out
#     rule {
#       scale_action {
#         direction = "Increase" #bc scale out
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }
#       metric_trigger {
#         metric_name        = "Percentage CPU" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "microsoft.compute/virtualmachinescalesets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 75
#       }
#     }

#     #scale in rule
#     rule {
#       scale_action {
#         direction = "Decrease" #bc scale out
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Percentage CPU" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "microsoft.compute/virtualmachinescalesets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 25
#       }
#     }

#     ### Available memory bytes metric rules
#     #scale out
#     rule {
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Available Memory Bytes" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 1073741824 #increase 1 VM when memory in bytes less than 1 GB
#       }
#     }

#     #scale in
#     rule {
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Available Memory Bytes" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 2147483648 #decrease 1 VM when memory in bytes greater than 2 GB
#       }
#     }

#     ### LB SYN Count metric Rules (just to test scale in and scale out)   
#     # Scale-out
#     rule {
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "SYNCount" #must match exactly w/azure
#         metric_resource_id = azurerm_lb.web_lb.id
#         metric_namespace   = "Microsoft.Network/loadBalancers"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 10 #10 requests to a LB
#       }
#     }
#     # Scale-in
#     rule {
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "SYNCount" #must match exactly w/azure
#         metric_resource_id = azurerm_lb.web_lb.id
#         metric_namespace   = "Microsoft.Network/loadBalancers"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 10 #10 requests to a LB
#       }
#     }
#   } # end of profile 2

#   ### recurrence block profile for weekends
#   #profile 3
#   profile {
#     name = "profile-3-weekends"
#     capacity {
#       default = 3
#       minimum = 3
#       maximum = 6
#     }

#     recurrence {
#       timezone = "Pacific Standard Time"
#       days     = ["Saturday", "Sunday"]
#       hours    = [0] #12 AM
#       minutes  = [0] # 00:00 -> 12 am
#     }

#     #CPU metrics
#     rule {
#       scale_action {
#         direction = "Increase" #bc scale out
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }
#       metric_trigger {
#         metric_name        = "Percentage CPU" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "microsoft.compute/virtualmachinescalesets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 75
#       }
#     }

#     #scale in rule
#     rule {
#       scale_action {
#         direction = "Decrease" #bc scale out
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Percentage CPU" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "microsoft.compute/virtualmachinescalesets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 25
#       }
#     }

#     ### Available memory bytes metric rules
#     #scale out
#     rule {
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Available Memory Bytes" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 1073741824 #increase 1 VM when memory in bytes less than 1 GB
#       }
#     }

#     #scale in
#     rule {
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Available Memory Bytes" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 2147483648 #decrease 1 VM when memory in bytes greater than 2 GB
#       }
#     }

#     ### LB SYN Count metric Rules (just to test scale in and scale out)   
#     # Scale-out
#     rule {
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "SYNCount" #must match exactly w/azure
#         metric_resource_id = azurerm_lb.web_lb.id
#         metric_namespace   = "Microsoft.Network/loadBalancers"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 10 #10 requests to a LB
#       }
#     }
#     # Scale-in
#     rule {
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "SYNCount" #must match exactly w/azure
#         metric_resource_id = azurerm_lb.web_lb.id
#         metric_namespace   = "Microsoft.Network/loadBalancers"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 10 #10 requests to a LB
#       }
#     }
#   } # end of profile 3

#   ### fixed profile for specific day
#   #profile 4
#   profile {
#     name = "profile-4-fixed-profile"
#     capacity {
#       default = 2
#       minimum = 2
#       maximum = 20
#     }

#     fixed_date {
#       timezone = "Pacific Standard Time"
#       start = "2024-07-25T00:00:00Z"
#       end   = "2024-07-25T23:59:59Z"
#     }

#     ###CPU metrics rules 
#     #scale out
#     rule {
#       scale_action {
#         direction = "Increase" #bc scale out
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }
#       metric_trigger {
#         metric_name        = "Percentage CPU" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "microsoft.compute/virtualmachinescalesets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 75
#       }
#     }

#     #scale in rule
#     rule {
#       scale_action {
#         direction = "Decrease" #bc scale out
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Percentage CPU" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "microsoft.compute/virtualmachinescalesets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 25
#       }
#     }

#     ### Available memory bytes metric rules
#     #scale out
#     rule {
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Available Memory Bytes" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 1073741824 #increase 1 VM when memory in bytes less than 1 GB
#       }
#     }

#     #scale in
#     rule {
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "Available Memory Bytes" #must match exactly w/azure
#         metric_resource_id = azurerm_linux_virtual_machine_scale_set.web_vmss.id
#         metric_namespace   = "Microsoft.Compute/virtualMachineScaleSets"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 2147483648 #decrease 1 VM when memory in bytes greater than 2 GB
#       }
#     }

#     ### LB SYN Count metric Rules (just to test scale in and scale out)   
#     # Scale-out
#     rule {
#       scale_action {
#         direction = "Increase"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "SYNCount" #must match exactly w/azure
#         metric_resource_id = azurerm_lb.web_lb.id
#         metric_namespace   = "Microsoft.Network/loadBalancers"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "GreaterThan"
#         threshold          = 10 #10 requests to a LB
#       }
#     }
#     # Scale-in
#     rule {
#       scale_action {
#         direction = "Decrease"
#         type      = "ChangeCount"
#         value     = 1
#         cooldown  = "PT5M"
#       }

#       metric_trigger {
#         metric_name        = "SYNCount" #must match exactly w/azure
#         metric_resource_id = azurerm_lb.web_lb.id
#         metric_namespace   = "Microsoft.Network/loadBalancers"
#         time_grain         = "PT1M"
#         statistic          = "Average"
#         time_window        = "PT5M"
#         time_aggregation   = "Average"
#         operator           = "LessThan"
#         threshold          = 10 #10 requests to a LB
#       }
#     }
#   } # end of profile 4
# }