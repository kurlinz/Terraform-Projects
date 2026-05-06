variable "sg_name" {
  description = " Name of the Network Security Group name"
  type = string
  default = "ssh-nsg"
}
variable "location" {
  description = "Location for the resources"
  type        = string
  default     = "Germany West Central"
}

variable "subnet_id" {
  description = "id of subnet"
}

variable "security-group-id" {
  description = "id of security group"
}