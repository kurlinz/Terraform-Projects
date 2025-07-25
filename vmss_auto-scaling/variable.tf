variable "Vnet_name" {
  description = "Name of the Vnet"
  type        = string
  default     = "myVnet"
}

variable "VM_name" {
  description = "The name of the Virtual Machine"
  type        = set(string)
  default     = ["myVM", "myVM2", ]
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
variable "subscription_id" {
  type    = string
}