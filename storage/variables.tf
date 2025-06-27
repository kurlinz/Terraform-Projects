variable "storage_account_name" {
  description = "The name of the storage account."
  type        = set(string)
  default = ["mystorage109999991","mystorage109999992"]
}
variable "resource_group_name" {
  description = "The name of the resource group where the storage account will be created."
  type        = string
  default     = "module-test-rg"
}
variable "location" {
  description = "The Azure region where the storage account will be created."
  type        = string
  default     = "Germany West Central"
  
}
variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
}