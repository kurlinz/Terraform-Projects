output "VM_name" {
  description = "The names of the Virtual Machines created"
  value       = [for vm in azurerm_linux_virtual_machine.vm : vm.name]
}
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}
output "name_of_Vnet" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name

}
output "Vm_Ip_address" {
  description = "The private IP addresses of the Virtual Machines"
  value       = [for nic in azurerm_network_interface.nic : nic.private_ip_address]
}
output "Location_of_the_resources" {
  description = "The location where the resources are created"
  value       = azurerm_resource_group.rg.location

}
output "VN_address_space" {
  description = "The address space of the Virtual Network"
  value       = azurerm_virtual_network.vnet.address_space
}

output "pub-ip" {
  description = "The public IP address of the admin VM"
  value       = azurerm_public_ip.admin-pip
}