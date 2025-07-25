# Resource block to create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.Vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.10.0.0/16"]
}

# Create a Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.10.1.0/24"]
}

# Resource block to create linux Virtual Machine
resource "azurerm_network_interface" "nic" {
  # Using each.value to create unique NIC names based on VM names
  name = "myNIC-${each.value}"
  # Using for_each to create multiple NICs based on VM names
  for_each            = var.VM_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = each.value
  for_each                        = var.VM_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]
  disable_password_authentication = true # Changed to true to disable password auth

  admin_ssh_key {
    username   = "adminuser"
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
