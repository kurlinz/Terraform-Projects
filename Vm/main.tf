resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.VM_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_DS1_v2"
  admin_username                  = var.vm_username
  network_interface_ids           = var.
  disable_password_authentication = false # Changed to true to disable password auth

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

  computer_name = "myvm"

  #resource block for tags
  tags = {
    environment = var.environment
  }
}
