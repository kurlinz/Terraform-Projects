# Create a Vmss
resource "azurerm_linux_virtual_machine_scale_set" "my-vmss" {
  name                = "example-vmss"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_F2"
  instances           = 2
  admin_username      = "adminuser"

  custom_data = base64encode(file("user-data.sh"))

  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.ssh_key_path) 
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "example"
    primary = true

    ip_configuration {
      name                                   = "internal"
      primary                                = true
      subnet_id                              = azurerm_subnet.subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.bpepool.id] # Note: This is now an array
    }
  }
}