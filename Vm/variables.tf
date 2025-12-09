variable "Vnet_name" {
  description = "Name of the Vnet"
  type        = string
  default     = "myVnet"
}

variable "VM_name" {
  description = "The name of the Virtual Machine"
  type        = set(string)
  default     = ["master1", "master2", "master3", "worker1", "worker2", "worker3"]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

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
  type = string
}