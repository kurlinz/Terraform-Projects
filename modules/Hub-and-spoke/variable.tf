variable "location" {
  description = "Location of the network"
  type        = string
}
variable "resource-group-name" {
  type = string
}
variable "subscription_id" {
  type = string
}
variable "hub-vnet-address-space" {
  type = list(string)
  description = "value is the address space for the hub virtual network"
}

variable "tag" {
  type = map(string)
  description = "value is the environment tag for all resources"
}
variable "hub-subnet-address-prefix" {
  type = list(string)
}
variable "firewall-subnet-address-prefix" {
  type = list(string)
}
variable "spoke1-vnet-name" {
  type = string
}
variable "spoke1-vnet-address-space" {
  type = list(string)
  description = "value is the address space for the spoke1 virtual network"
}
variable "spoke1-subnet-address-space" {
  type = list(string)
  description = "value is the address space for the spoke1 virtual network"
}
variable "spoke2-vnet-address-space" {
  type = list(string)
  description = "value is the address space for the spoke2 virtual network"
}
variable "spoke2-subnet-address-space" {
  type = list(string)
  description = "value is the address space for the spoke2 virtual network"
}