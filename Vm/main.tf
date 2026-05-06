
# Resource block to create linux Virtual Machine
resource "azurerm_network_interface" "nic" {
  # Using each.value to create unique NIC names based on VM names
  name = "myNIC-${each.value}"
  # Using for_each to create multiple NICs based on VM names
  for_each            = var.VM_name
  location            = azurerm_resource_group.rg.location
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
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_DS1_v2"
  admin_username                  = var.vm_username
  network_interface_ids           = [azurerm_network_interface.nic[each.key].id]
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

# create public IP for admin vm
resource "azurerm_public_ip" "admin-pip" {
  name                = "admin_pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}


# Nic for admin vm with public IP
resource "azurerm_network_interface" "nic_admin" {
  name                = "admin-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.admin-pip.id
  }
}

# create admin vm with public IP

resource "azurerm_linux_virtual_machine" "admin_vm" {
  name                            = "admin"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  network_interface_ids           = [azurerm_network_interface.nic_admin.id]
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

  computer_name = "admin"
}