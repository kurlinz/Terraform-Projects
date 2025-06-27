locals {
  prefix-hub         = "hub"
  hub-resource-group = "hub-vnet-rg-${random_string.suffix.result}"
  shared-key         = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}

# Random string for unique resource group name
resource "azurerm_resource_group" "hub-vnet-rg" {
  name     = local.hub-resource-group
  location = var.location
}

# Create a virtual network in the hub region
resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${local.prefix-hub}-vnet"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "hub-spoke"
  }
}

# Create a subnet for the hub virtual network
resource "azurerm_subnet" "hub-default" {
  name                 = "HubDefaultSubnet"
  resource_group_name  = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.0.0/24"]

}

#Create a subnet for firewall
resource "azurerm_subnet" "hub-firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
