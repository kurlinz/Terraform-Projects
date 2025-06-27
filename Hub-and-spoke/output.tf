#Username for the VM
output "username" {
  value       = var.username
  description = "Username for the Virtual Machines"
}

# Spoke1-vm IP address
output "spoke1-vm-ip" {
  value       = azurerm_network_interface.spoke1-nic.private_ip_address
  description = "Private IP address of the Spoke1 VM"
}

# Spoke2-vm IP address
output "spoke2-vm-ip" {
  value       = azurerm_network_interface.spoke2-nic.private_ip_address
  description = "Private IP address of the Spoke2 VM"
}
