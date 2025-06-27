output "resource_group_id" {
  value = data.azurerm_resource_group.example.id
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.example.id
}