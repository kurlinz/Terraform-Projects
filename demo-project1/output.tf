output "pub-ip" {
  description = "The public IP address of the admin VM"
  value       = azurerm_public_ip.demo-pip.ip_address
}

output "vm_user" {
  description = "Vm username"
  value       = azurerm_linux_virtual_machine.demo-vm.admin_username
}