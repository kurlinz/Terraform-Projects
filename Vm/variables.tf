variable "Vnet_name" {
  description = "Name of the Vnet"
  type        = string
  default     = "myVnet"
}
variable "vnet_address_space" {
  description = "Address space for the Vnet"
  type        = list(string)
  default     = ["10.0.0.0/16"] 
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "${var.Vnet_name}-subnet"
}

variable "subnet_add_prefix" {
  type = list(string)
  default = [ "10.10.1.0/24" ]
}

variable "sg_name" {
  description = " Name of the Network Security Group name"
  type = string
  default = "ssh-nsg"
}
variable "VM_name" {
  description = "The name of the Virtual Machine"
  type        = set(string)
  default     = ["master1", "master2", "master3", "worker1", "worker2", "worker3"]
}

variable "vm_username" {
  description = "Username for the Virtual Machine"
  type        = string
  default     = "adminuser"
}
variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_DS1_v2"
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

