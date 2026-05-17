# Create a virtual network in the hub region
resource "azurerm_virtual_network" "hub-vnet" {
  name                = "${local.prefix-hub}-vnet"
  location            = var.location
  resource_group_name = var.resource-group-name
  address_space       = var.hub-vnet-address-space
  tags                = var.tag
}

# Create a subnet for the hub virtual network
resource "azurerm_subnet" "hub-default" {
  name                 = "${azurerm_virtual_network.hub-vnet.name}-subnet"
  resource_group_name  = azurerm_virtual_network.hub-vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = var.hub-subnet-address-prefix
}

#Create a subnet for firewall
resource "azurerm_subnet" "hub-firewall" {
  name                 = "${azurerm_virtual_network.hub-vnet.name}-firewall-subnet"
  resource_group_name  = azurerm_virtual_network.hub-vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub-vnet.name
  address_prefixes     = var.firewall-subnet-address-prefix
}
