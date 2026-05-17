output "VM_name" {
  description = "The names of the Virtual Machines created"
  value       = azurerm_linux_virtual_machine.vm.*.name
}
output "Vm_Ip_address" {
  description = "The private IP addresses of the Virtual Machines"
  value       = azurerm_linux_virtual_machine.vm.*.private_ip_address
}
output "rg-name" {
  value = azurerm_linux_virtual_machine.vm.*.resource_group_name
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