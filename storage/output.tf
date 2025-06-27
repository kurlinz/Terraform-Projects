# Output block to display storage account name
output "name_of_storage_account" {
  description = "The name of the storage account"
  value       = [for storage in azurerm_storage_account.sa : storage.name]
  
}
