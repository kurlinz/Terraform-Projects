output "static_website_endpoint" {
  value = azurerm_storage_account.static_website.primary_web_endpoint
}

output "storage_account_name" {
  value = azurerm_storage_account.static_website.name
}