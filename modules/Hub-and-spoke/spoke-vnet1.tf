resource "azurerm_virtual_network" "spoke1-vnet" {
  name                = var.spoke1-vnet-name
  location            = var.location
  resource_group_name = var.resource-group-name
  address_space       = var.spoke1-vnet-address-space

  tags = {
    environment = local.prefix-spoke1
  }
}

resource "azurerm_subnet" "spoke1-default" {
  name                 = "${var.spoke1-vnet-name}-subnet"
  resource_group_name  = var.resource-group-name
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name
  address_prefixes     = var.spoke1-subnet-address-space
}

resource "azurerm_virtual_network_peering" "spoke1-hub-peer" {
  name                      = "${azurerm_virtual_network.hub-vnet.name}-hub-peer"
  resource_group_name       = var.resource-group-name
  virtual_network_name      = azurerm_virtual_network.spoke1-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id
}

# Create Network Security Group with restricted rules
resource "azurerm_network_security_group" "spoke1-nsg" {
  name                = "${local.prefix-spoke1}-nsg"
  location            = var.location
  resource_group_name = var.resource-group-name

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
    environment = local.prefix-spoke1
  }
}

resource "azurerm_virtual_network_peering" "hub-spoke1-peer" {
  name                      = "${azurerm_virtual_network.spoke1-vnet.name}-${azurerm_virtual_network.hub-vnet.name}-peer"
  resource_group_name       = azurerm_virtual_network.spoke1-vnet.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1-vnet.id
}

resource "azurerm_subnet_route_table_association" "spoke1_routes" {
  subnet_id      = azurerm_subnet.spoke1-default.id
  route_table_id = azurerm_route_table.spoke_routes.id
}

