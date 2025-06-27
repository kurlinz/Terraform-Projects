# Block to create resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-test"
  location = "Germany West Central"
}

# Create network security group
resource "azurerm_network_security_group" "nsg" {
  name                = var.environment == "dev" ? "nsg-dev" : "nsg-stage"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

# Dynamic block to create security rules
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
}
}