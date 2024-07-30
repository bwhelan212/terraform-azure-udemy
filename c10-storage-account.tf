# resource 1: create azure storage account
resource "azurerm_storage_account" "storage_account" {
  name = "${var.storage_account_name}${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind = var.storage_account_kind

  static_website {
    index_document = var.static_website_index_document
    error_404_document = var.static_website_error_404_document
  }
}

# resource 2: httpd files container
resource "azurerm_storage_container" "httpd_files_container" {
    name = "httpd-files-container"
    storage_account_name = azurerm_storage_account.storage_account.name
    container_access_type = "private"
}
# locals block with list of files to be uploaded
locals {
    httpd_conf_files = ["app1.conf"]
}

# resource 3: httpd conf files upload to httpd-files-container 
resource "azurerm_storage_blob" "httpd_files_container_blob" {
    name = "httpd-files-container-blob"
    storage_account_name = azurerm_storage_account.storage_account.name
    storage_container_name = azurerm_storage_container.httpd_files_container.name
    type = "Block"
    source = "${path.module}/app-scripts/app1.conf"
}