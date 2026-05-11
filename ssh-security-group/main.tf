# Network Security Group to allow SSH (TCP 22) into the subnet
resource "azurerm_network_security_group" "ssh_nsg" {
  name                = var.sg_name
  location            = var.location
  resource_group_name = var.rg-name
  security_rule {
    name                       = var.sg-rule-name
    priority                   = var.sg-priority-number
    direction                  = var.sg-direction
    access                     = var.sg-access
    protocol                   = var.sg-access-protocol
    source_port_range          = "*"
    destination_port_range     = var.destination-port-range
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associate the Network Security Group to the subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_assoc" {
  subnet_id                 = var.subnet_id
  network_security_group_id = var.security-group-id
}
