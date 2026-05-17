variable "rg-name" {
  type = string
}
variable "location" {
  type = string
}
variable "VM_name" {
  description = "The name of the Virtual Machine"
  type        = string
}

variable "vm_username" {
  description = "Username for the Virtual Machine"
  type        = string
}
variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_DS1_v2"
}
variable "network_interface_id" {
  type = list(string)
}
variable "disable-password-auth" {
  type = bool
  default = false
}
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
variable "ssh_key_path" {
  description = "SSH key pair for the VM"
  type        = string
  default     = "C:\\Users\\KUB00093\\.ssh\\id_rsa.pub" # Path to your public key
}
variable "" {
  
}
