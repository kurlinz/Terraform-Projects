variable "location" {
  description = "Location of the network"
  type        = string
}

variable "username" {
  description = "Username for Virtual Machines"
  type        = string
}

variable "password" {
  description = "Password for Virtual Machines"
  sensitive   = true
}

variable "vmsize" {
  description = "Size of the VMs"
  type        = string
}
variable "subscription_id" {
  type = string
}