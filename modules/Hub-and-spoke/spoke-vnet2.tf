resource "azurerm_virtual_network" "spoke2-vnet" {
  name                = "${local.prefix-spoke2}-vnet"
  location            = var.location
  resource_group_name = var.resource-group-name
  address_space       = var.spoke2-vnet-address-space
  tags = var.tag
}

resource "azurerm_subnet" "spoke2-default" {
  name                 = "${azurerm_virtual_network.spoke2-vnet.name}-subnet"
  resource_group_name  = azurerm_virtual_network.spoke2-vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke2-vnet.name
  address_prefixes     = var.spoke2-subnet-address-space
}

resource "azurerm_virtual_network_peering" "spoke2-hub-peer" {
  name                      = "${azurerm_virtual_network.spoke2-vnet.name}-hub-peer"
  resource_group_name       = azurerm_virtual_network.spoke2-vnet.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke2-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id
}

resource "azurerm_network_security_group" "spoke2-nsg" {
  name                = "${local.prefix-spoke2}-nsg"
  location            = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name

  security_rule {
    name                       = "Allow-Internal-Traffic"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = {
    environment = local.prefix-spoke2
  }
}

resource "azurerm_virtual_network_peering" "hub-spoke2-peer" {
  name                      = "hub-${azurerm_virtual_network.spoke2-vnet.name}-peer"
  resource_group_name       = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2-vnet.id
}

resource "azurerm_subnet_route_table_association" "spoke2_routes" {
  subnet_id      = azurerm_subnet.spoke2-default.id
  route_table_id = azurerm_route_table.spoke_routes.id
}

