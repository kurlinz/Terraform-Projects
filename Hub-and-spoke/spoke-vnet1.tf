locals {
  spoke1-resource-group = "spoke1-vnet-rg-${random_string.suffix.result}"
  prefix-spoke1         = "spoke1"
}

resource "azurerm_resource_group" "spoke1-vnet-rg" {
  name     = local.spoke1-resource-group
  location = var.location
}

resource "azurerm_virtual_network" "spoke1-vnet" {
  name                = "spoke1-vnet"
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name
  address_space       = ["20.0.0.0/16"]

  tags = {
    environment = local.prefix-spoke1
  }
}

resource "azurerm_subnet" "spoke1-default" {
  name                 = "spoke1Subnet"
  resource_group_name  = azurerm_resource_group.spoke1-vnet-rg.name
  virtual_network_name = azurerm_virtual_network.spoke1-vnet.name
  address_prefixes     = ["20.0.0.0/24"]
}

resource "azurerm_virtual_network_peering" "spoke1-hub-peer" {
  name                      = "spoke1-hub-peer"
  resource_group_name       = azurerm_resource_group.spoke1-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.spoke1-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub-vnet.id
}

resource "azurerm_network_interface" "spoke1-nic" {
  name                = "${local.prefix-spoke1}-nic"
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name

  ip_configuration {
    name                          = local.prefix-spoke1
    subnet_id                     = azurerm_subnet.spoke1-default.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create Network Security Group with restricted rules
resource "azurerm_network_security_group" "spoke1-nsg" {
  name                = "${local.prefix-spoke1}-nsg"
  location            = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name = azurerm_resource_group.spoke1-vnet-rg.name

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
    environment = local.prefix-spoke1
  }
}

resource "azurerm_network_interface_security_group_association" "spoke1-nic-nsg" {
  network_interface_id      = azurerm_network_interface.spoke1-nic.id
  network_security_group_id = azurerm_network_security_group.spoke1-nsg.id
}

resource "azurerm_virtual_machine" "spoke1-vm" {
  name                  = "${local.prefix-spoke1}-vm"
  location              = azurerm_resource_group.spoke1-vnet-rg.location
  resource_group_name   = azurerm_resource_group.spoke1-vnet-rg.name
  network_interface_ids = [azurerm_network_interface.spoke1-nic.id]
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
    computer_name  = "${local.prefix-spoke1}-vm"
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
    environment = local.prefix-spoke1
  }
}

resource "azurerm_virtual_network_peering" "hub-spoke1-peer" {
  name                      = "hub-spoke1-peer"
  resource_group_name       = azurerm_resource_group.hub-vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.hub-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1-vnet.id
}

resource "azurerm_subnet_route_table_association" "spoke1_routes" {
  subnet_id      = azurerm_subnet.spoke1-default.id
  route_table_id = azurerm_route_table.spoke_routes.id
}

