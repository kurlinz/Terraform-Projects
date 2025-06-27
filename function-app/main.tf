# This Terraform configuration creates a Linux Function App in Azure with a storage account and an app service plan.
resource "azurerm_resource_group" "example" {
  name     = "functions-rg"
  location = "Germany West Central"
}

resource "azurerm_storage_account" "example" {
  name                     = "kurlinzlinuxfunction12"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "example" {
  name                = "example-app-service-plan"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_function_app" "example" {
  name                = "kurlinz-function-app"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  service_plan_id            = azurerm_service_plan.example.id

  site_config {
   application_stack {
    node_version = 18
   }    
  }
}
