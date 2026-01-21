variable "resource_group_location" {
  type        = string
  default     = "Germany West Central"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "kubeops-aks"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "node_count" {
  type        = number
  description = "The initial quantity of nodes for the node pool."
  default     = 2
}

variable "msi_id" {
  type        = string
  description = "The Managed Service Identity ID. Set this value if you're running this example using Managed Identity as the authentication method."
  default     = null
}

