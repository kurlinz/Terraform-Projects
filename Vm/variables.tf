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



variable "ssh_key_path" {
  description = "SSH key pair for the VM"
  type        = string
  default     = "C:\\Users\\KUB00093\\.ssh\\id_rsa.pub" # Path to your public key

}

variable "subscription_id" {
  type = string
}
