variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "my_terraform_rg"
}

variable "location" {
  description = "Location for the resources"
  type        = string
  default     = "Germany West Central"
}

variable "ssh_key_path" {
  description = "SSH key pair for the VM"
  type        = string
  default     = "C:\\Users\\KUB00093\\.ssh\\id_rsa.pub" # Path to your public key

}

variable "subscription_id" {
  type    = string
  default = ""
}

variable "azurerm_storage_account_name" {
  description = "Name of the Azure Storage Account for the static website"
  type        = string
  default     = "mystaticwebsite12345" # Must be globally unique
  
}