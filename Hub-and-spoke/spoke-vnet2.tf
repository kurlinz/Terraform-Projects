locals {
  spoke2-resource-group = "spoke2-vnet-rg-${random_string.suffix.result}"
  prefix-spoke2         = "spoke2"
}

resource "azurerm_resource_group" "spoke2-vnet-rg" {
  name     = local.spoke2-resource-group
  location = var.location
}

resource "azurerm_virtual_network" "spoke2-vnet" {
  name                = "${local.prefix-spoke2}-vnet"
  location            = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name
  address_space       = ["30.0.0.0/16"]

  tags = {
    environment = local.prefix-spoke2
  }
}

resource "azurerm_subnet" "spoke2-default" {
  name                 = "spoke2Subnet"
  resource_group_name  = azurerm_resource_group.spoke2-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke2-vnet.name
  address_prefixes     = ["30.0.0.0/24"]
}

resource "azurerm_virtual_network_peering" "spoke2-hub-peer" {
  name                      = "${local.prefix-spoke2}-hub-peer"
  resource_group_name       = azurerm_resource_group.spoke2-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.spoke2-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id
}

resource "azurerm_network_interface" "spoke2-nic" {
  name                = "${local.prefix-spoke2}-nic"
  location            = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name

  ip_configuration {
    name                          = local.prefix-spoke2
    subnet_id                     = azurerm_subnet.spoke2-default.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = local.prefix-spoke2
  }
}

resource "azurerm_network_security_group" "spoke2-nsg" {
  name                = "${local.prefix-spoke2}-nsg"
  location            = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke2-vnet-rg.name

  security_rule {
    name                       = "Allow-Internal-Traffic"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = {
    environment = local.prefix-spoke2
  }
}

resource "azurerm_network_interface_security_group_association" "spoke2-nsg-association" {
  network_interface_id      = azurerm_network_interface.spoke2-nic.id
  network_security_group_id = azurerm_network_security_group.spoke2-nsg.id
}

resource "azurerm_virtual_machine" "spoke2-vm" {
  name                  = "${local.prefix-spoke2}-vm"
  location              = azurerm_resource_group.spoke2-vnet-rg.location
  resource_group_name   = azurerm_resource_group.spoke2-vnet-rg.name
  network_interface_ids = [azurerm_network_interface.spoke2-nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix-spoke2}-vm"
    admin_username = var.username
  }

  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = data.local_file.ssh_public_key.content
    }
  }

  tags = {
    environment = local.prefix-spoke2
  }
}

resource "azurerm_virtual_network_peering" "hub-spoke2-peer" {
  name                      = "hub-spoke2-peer"
  resource_group_name       = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke2-vnet.id
}

resource "azurerm_subnet_route_table_association" "spoke2_routes" {
  subnet_id      = azurerm_subnet.spoke2-default.id
  route_table_id = azurerm_route_table.spoke_routes.id
}

