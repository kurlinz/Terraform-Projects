# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a storage account for the static website
resource "azurerm_storage_account" "static_website" {
  name                     = var.azurerm_storage_account_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
#   https_traffic_only_enabled = true
#   custom_domain {
#     name = "www.kurlinz.com"
#   }
}
# Configure static website for the storage account
resource "azurerm_storage_account_static_website" "static_website" {
  storage_account_id = azurerm_storage_account.static_website.id
  index_document     = "index.html"
  error_404_document = "404.html"
}