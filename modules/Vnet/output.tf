output "vnet-name" {
  value = azurerm_virtual_network.vnet.name
}

output "subnet-name" {
  value = azurerm_subnet.subnet.name
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
output "subnet_id" {
  value = azurerm_subnet.subnet.id
}
output "vnet-address-space" {
  value = azurerm_virtual_network.vnet.address_space
}
output "subnet-address-space" {
  value = azurerm_subnet.subnet.address_prefixes
}