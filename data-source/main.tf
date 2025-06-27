# Resource-group data-source
data "azurerm_resource_group" "example" {
  name = "data-rg"
}

data "azurerm_virtual_network" "example" {
  name                = "data-vnet"
  resource_group_name = data.azurerm_resource_group.example.name
}

data "azurerm_subnet" "example" {
  name                 = "default2"
  virtual_network_name = data.azurerm_virtual_network.example.name
  resource_group_name  = data.azurerm_resource_group.example.name
}
# Resource block to create linux Virtual Machine
resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.example.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "myvm"
  resource_group_name             = data.azurerm_resource_group.example.name
  network_interface_ids           = [azurerm_network_interface.nic.id]
  location                        = var.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  disable_password_authentication = false # Changed to true to disable password auth
    admin_password                  = "P@ssw0rd1234!" # Use a strong password

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:\\Users\\KUB00093\\.ssh\\id_rsa.pub") # Path to your public key
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
}