resource "azurerm_resource_group" "demo-rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Virtual Network
resource "azurerm_virtual_network" "demo-vnet" {
  name                = var.Vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.demo-rg.name
  address_space       = ["10.0.0.0/16"]
}

#Create a Subnet
resource "azurerm_subnet" "demo-subnet" {
  name                 = "demoSubnet"
  resource_group_name  = azurerm_resource_group.demo-rg.name
  virtual_network_name = azurerm_virtual_network.demo-vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}
# create security group for ssh
resource "azurerm_network_security_group" "demo-ssh-nsg" {
  name                = "demo-ssh-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo-rg.name

  security_rule {
    name                       = "Allow-SSH-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow SSH from anywhere"
  }
}
# create public ip
resource "azurerm_public_ip" "demo-pip" {
  name                = "demoPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo-rg.name
  allocation_method   = "Static"
}

# create Nic
resource "azurerm_network_interface" "demo-nic" {
  name                = "demoNIC"
  location            = var.location
  resource_group_name = azurerm_resource_group.demo-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo-pip.id
  }
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "demo-nsg-assoc" {
  network_interface_id      = azurerm_network_interface.demo-nic.id
  network_security_group_id = azurerm_network_security_group.demo-ssh-nsg.id
}

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "demo-vm" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = azurerm_resource_group.demo-rg.name
  size                = var.vm_size

  admin_username = var.admin_username

  disable_password_authentication = true

  custom_data = base64encode(file("config.sh"))

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_key_path)
  }

  network_interface_ids = [
    azurerm_network_interface.demo-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
