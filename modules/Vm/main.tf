resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.VM_name
  resource_group_name             = var.rg-name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.vm_username
  network_interface_ids           = var.network_interface_id
  disable_password_authentication = var.disable-password-auth# Changed to true to disable password auth

  admin_ssh_key {
    username   = var.vm_username
    public_key = file(var.ssh_key_path)
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  computer_name = var.VM_name

  #resource block for tags
  tags = {
    environment = var.environment
  }
}
