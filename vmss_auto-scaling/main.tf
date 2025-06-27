#locals block to define variables
locals {
  resource_group_name = "terraformrg"
  location            = "Germany West Central"
  nsg_rules = {

    "allow_http" = {
      priority               = 100
      destination_port_range = "80"
      description            = "Allow HTTP"
    },
    "allow_ssh" = {
      priority               = 200
      destination_port_range = "22"
      description            = "Allow SSH"
    },
    "allow_https" = {
      priority               = 110
      destination_port_range = "443"
      description            = "Allow HTTPS"
    }
  }
}
# Resource block to create resource group
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
}
