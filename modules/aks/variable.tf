variable "location" {
  type        = string
  description = "Location of the resource group."
}
variable "resource_group_name" {
  type        = string
}
variable "vnet_subnet_id" {
  type        = string
  description = "The ID of the subnet to which the AKS cluster will be connected."
}
variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
}
variable "cluster_name" {
  type = string
}
variable "node-pool-name" {
  type = string
}
variable "node-pool-vm-size" {
  type = string
  default = "Standard_D2_v2"
}
variable "rbac" {
  type = bool
  default = true
}
variable "auto-scaling" {
  type = bool
  default = false
}
variable "oidc_enabled" {
  type = bool
  default = true
}
variable "admin_username" {
  type = string
}
variable "ssh_key" {
  description = "SSH key pair for the VM"
  type        = string
}