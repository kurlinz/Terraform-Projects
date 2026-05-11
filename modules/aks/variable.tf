variable "location" {
  type        = string
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
}
variable "cluster_name" {
  type = string
}
variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
}
variable "node-pool-name" {
  type = string
}
variable "node-pool-vm-size" {
  type = string
}
variable "rbac" {
  type = bool
  default = true
}
variable "auto-scaling" {
  type = bool
  default = true
}
variable "min-count" {
  type = number
}
variable "max-count" {
  type = number
}
variable "oidc_enabled" {
  type = bool
  default = true
}
variable "admin_username" {
  type = string
}
variable "ssh_key_path" {
  description = "SSH key pair for the VM"
  type        = string
  default     = "C:\\Users\\KUB00093\\.ssh\\id_rsa.pub" # Path to your public key
  
}