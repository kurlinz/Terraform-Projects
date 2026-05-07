# Output block to display storage account name
output "name_of_storage_account" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.sa.name 
}
output "storage_account_id" {
  value = azurerm_storage_account.sa.id
}
