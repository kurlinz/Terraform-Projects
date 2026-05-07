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
variable "sg-rule-name" {
  type = string
}

variable "security-group-id" {
  description = "id of security group"
}
variable "destination-port-range" {
  type = number
}
variable "sg-access-protocol" {
  type = string
}
variable "sg-priority-number" {
  type = number
  default = 1001
}
variable "sg-direction" {
  type = string
  description = "inbound or outbound access"
}
variable "sg-access" {
  type = string
  description = "Allow or Deny access"
}