#Resource-1: Azure Application Gateway Public IP
resource "azurerm_public_ip" "web_ag_publicip" {
  name                = "${local.resource_name_prefix}-web-ag-publicip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku = "Standard"  
}

# Azure Application Gateway - Locals Block 
#since these variables are re-used - a locals block makes this more maintainable
locals { 
  # Generic 
#   frontend_port_name             = "${azurerm_virtual_network.vnet.name}-feport"
  frontend_ip_configuration_name = "${azurerm_virtual_network.vnet.name}-feip"
  redirect_configuration_name    = "${azurerm_virtual_network.vnet.name}-redirect"
  #url_path_map                   =  "${azurerm_virtual_network.vnet.name}-upm-app1-app2"  

  # App1
  backend_address_pool_name_app1      = "${azurerm_virtual_network.vnet.name}-beap-app1"
  http_setting_name_app1              = "${azurerm_virtual_network.vnet.name}-be-htst-app1"
  probe_name_app1                     = "${azurerm_virtual_network.vnet.name}-be-probe-app1"
#   listener_name_app1                  = "${azurerm_virtual_network.vnet.name}-httplstn-app1"
#   request_routing_rule_name_app1      = "${azurerm_virtual_network.vnet.name}-rqrt-app1" 
  
  #http listener port 80. frontend port to redirectto port 443 for http to https redirection
  listener_name_http = "${azurerm_virtual_network.vnet.name}-lstn-http"
  request_routing_rule_name_http= "${azurerm_virtual_network.vnet.name}-rqrt-http"
  frontend_port_name_http = "${azurerm_virtual_network.vnet.name}-feport-http"

    #https listener port 443
  listener_name_https = "${azurerm_virtual_network.vnet.name}-lstn-https"
  request_routing_rule_name_https = "${azurerm_virtual_network.vnet.name}-rqrt-https"
  frontend_port_name_https = "${azurerm_virtual_network.vnet.name}-feport-https"
  ssl_certificate_name = "my-cert-1"
#   # App2
#   backend_address_pool_name_app2      = "${azurerm_virtual_network.vnet.name}-beap-app2"
#   http_setting_name_app2              = "${azurerm_virtual_network.vnet.name}-be-htst-app2"
#   probe_name_app2                     = "${azurerm_virtual_network.vnet.name}-be-probe-app2"
#   listener_name_app2                  = "${azurerm_virtual_network.vnet.name}-httplstn-app2" 
#   request_routing_rule_name_app2      = "${azurerm_virtual_network.vnet.name}-rqrt-app2" 
}



# Resource-2: Azure Application Gateway - Standard
resource "azurerm_application_gateway" "web_ag" {
  name                = "${local.resource_name_prefix}-web-ag"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
# START: --------------------------------------- #
# SKU: Standard_v2 (New Version )
  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    #capacity = 2
  }
  autoscale_configuration {
    min_capacity = 0
    max_capacity = 10
  }  
# END: --------------------------------------- #

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.agsubnet.id
  }

  #front end http port 90
  frontend_port {
    name = local.frontend_port_name_http
    port = 80
  }

  #front end https port 443
  frontend_port {
    name = local.frontend_port_name_https
    port = 443
    }
# # Front End Configs
#   frontend_port {
#     name = local.frontend_port_name
#     port = 80
#   }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.web_ag_publicip.id    
  }

# Listerner: HTTP Port 80 with app1.terraformguru.com 
#   http_listener {
#     name                          = local.listener_name_app1 #name of listener
#     frontend_ip_configuration_name = local.frontend_ip_configuration_name
#     frontend_port_name             = local.frontend_port_name
#     protocol                       = "Http"
#     host_names = ["app1.terraformguru.com"]
#   }


# # Listerner: HTTP Port 80 with app2.terraformguru.com 
#    http_listener {
#     name                          = local.listener_name_app2 #name of listener
#     frontend_ip_configuration_name = local.frontend_ip_configuration_name
#     frontend_port_name             = local.frontend_port_name
#     protocol                       = "Http"
#     host_names = ["app2.terraformguru.com"]
#   }
 

# App1 Backend Configs
  backend_address_pool {
    name = local.backend_address_pool_name_app1
  }
  backend_http_settings {
    name                  = local.http_setting_name_app1
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = local.probe_name_app1
  }
  probe {
    name                = local.probe_name_app1
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Http"
    port                = 80
    path                = "/app1/status.html"
    match { # Optional
      body              = "App1"
      status_code       = ["200"]
    }
  }   
  
  #http listerner port 80
  http_listener {
    name = local.listener_name_http
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name = local.frontend_port_name_http
    protocol = "Http"
  }
  #http routing rule (http to https redirect) assocaite listener, http setting and backend pool here
  request_routing_rule {
    name = local.request_routing_rule_name_http
    rule_type = "Basic"
    http_listener_name = local.listener_name_http
    redirect_configuration_name = local.redirect_configuration_name #could use backend address pool name and backend http settings name instead
    priority = 140
  }

  #redirect config for https to htpps redirect (need to create b4 routing rule)
  redirect_configuration {
    name = local.redirect_configuration_name
    redirect_type = "Permanent"
    target_listener_name = local.listener_name_https #target listener wil redirect now. could use other target var for exxternal
    include_path = true #include path in redirect
    include_query_string = true #include query string in redirect
  }

  ##ssl cert block, using data here so upload http.pfx from local desktop, later will use key vault
  ssl_certificate {
    name = local.ssl_certificate_name
    password = "kalyan" #password used when creating the pfx file
    data = filebase64("${path.module}/ssl-self-signed/httpd.pfx")
  }
  #https listener - port 443
  http_listener {
    name = local.listener_name_https
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name = local.frontend_port_name_https
    protocol = "Https"
    ssl_certificate_name = local.ssl_certificate_name
    #can configure custom errror pages here
    custom_error_configuration {
      custom_error_page_url = "${azurerm_storage_account.storage_account.primary_web_endpoint}502.html" #look at storage account ouputs for primary web endpoint. dont need to add / bc already appended
      status_code = "HttpStatus502"
    }
    custom_error_configuration {
      custom_error_page_url = "${azurerm_storage_account.storage_account.primary_web_endpoint}403.html" #look at storage account ouputs for primary web endpoint. dont need to add / bc already appended
      status_code = "HttpStatus403"
    }
  }
  #https routing rule - port 443
  request_routing_rule {
    name = local.request_routing_rule_name_https
    rule_type = "Basic"
    http_listener_name = local.listener_name_https
    backend_address_pool_name = local.backend_address_pool_name_app1
    backend_http_settings_name = local.http_setting_name_app1
    priority = 120
  }

# # App2 Backend Configs
#   backend_address_pool {
#     name = local.backend_address_pool_name_app2
#   }
#   backend_http_settings {
#     name                  = local.http_setting_name_app2
#     cookie_based_affinity = "Disabled"
#     port                  = 80
#     protocol              = "Http"
#     request_timeout       = 60  
#     probe_name            = local.probe_name_app2    
#   }  
#   probe {
#     name                = local.probe_name_app2
#     host                = "127.0.0.1"
#     interval            = 30
#     timeout             = 30
#     unhealthy_threshold = 3
#     protocol            = "Http"
#     port                = 80
#     path                = "/app2/status.html"
#     match { # Optional
#       body              = "App2"
#       status_code       = ["200"]
#     }
#   }  


# Routing Rule - app1.terraformguru.com
#   request_routing_rule {
#     name                       = local.request_routing_rule_name_app1
#     rule_type                  = "Basic"
#     http_listener_name         = local.listener_name_app1
#     backend_address_pool_name = local.backend_address_pool_name_app1 #realtes backend pool to rule
#     backend_http_settings_name = local.http_setting_name_app1 #relates http settings to rule
#     priority = 120
#   }

# # Routing Rule - app2.terraformguru.com
#   request_routing_rule {
#     name                       = local.request_routing_rule_name_app2
#     rule_type                  = "Basic"
#     http_listener_name         = local.listener_name_app2
#     backend_address_pool_name = local.backend_address_pool_name_app2
#     backend_http_settings_name = local.http_setting_name_app2
#     priority = 140
#   }  
}
