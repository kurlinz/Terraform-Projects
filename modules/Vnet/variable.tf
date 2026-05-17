variable "Vnet_name" {
  description = "Name of the Vnet"
  type        = string
}
variable "location" {
  description = "Location for the Vnet"
  type        = string
}
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}
variable "vnet_address_space" {
  description = "Address space for the Vnet"
  type        = list(string)
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_address_space" {
  description = "Address space for the subnet"
  type        = list(string)
}