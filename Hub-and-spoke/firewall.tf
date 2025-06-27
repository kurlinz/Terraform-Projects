# This Terraform configuration creates an Azure Firewall with a public IP address and a subnet.
resource "azurerm_public_ip" "firewallpip" {
  name                = "pip-fw"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "firewall" {
  name                = "testfirewall"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.hub-firewall.id
    public_ip_address_id = azurerm_public_ip.firewallpip.id
  }
}

# Network rules for inter-spoke communication
resource "azurerm_firewall_network_rule_collection" "spoke-to-spoke" {
  name                = "spoke-to-spoke-rules"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  priority            = 200
  action              = "Allow"

  rule {
    name                  = "allow-spoke1-to-spoke2"
    source_addresses      = ["20.0.0.0/16"] # spoke1 address space
    destination_addresses = ["30.0.0.0/16"] # spoke2 address space
    destination_ports     = ["*"]
    protocols             = ["Any"]
  }

  rule {
    name                  = "allow-spoke2-to-spoke1"
    source_addresses      = ["30.0.0.0/16"] # spoke2 address space
    destination_addresses = ["20.0.0.0/16"] # spoke1 address space
    destination_ports     = ["*"]
    protocols             = ["Any"]
  }
}

# DNAT rule for SSH access to spoke1-vm
resource "azurerm_firewall_nat_rule_collection" "spoke1-ssh" {
  name                = "spoke1-ssh-dnat"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name
  priority            = 100
  action              = "Dnat"

  rule {
    name                  = "allow-ssh-spoke1-vm"
    source_addresses      = ["*"] # Consider restricting to specific IP ranges
    destination_ports     = ["22"]
    destination_addresses = [azurerm_public_ip.firewallpip.ip_address]
    translated_port       = "22"
    translated_address    = azurerm_network_interface.spoke1-nic.private_ip_address
    protocols             = ["TCP"]
  }
}

# Route table for spoke networks to force traffic through firewall
resource "azurerm_route_table" "spoke_routes" {
  name                = "spoke-routes"
  location            = azurerm_resource_group.hub-vnet-rg.location
  resource_group_name = azurerm_resource_group.hub-vnet-rg.name

  route {
    name                   = "route-through-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
  }
}