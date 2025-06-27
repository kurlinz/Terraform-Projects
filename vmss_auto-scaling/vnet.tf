# Create a Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.Vnet_name
  location            = local.location
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

# Craete a Network Security Group with dynamic expression
resource "azurerm_network_security_group" "nsg" {
  name                = var.environment == "dev" ? "nsg-dev" : "nsg-stage"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Dynamic block to create security rules
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}

# Associate the NSG with the subnet 
resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Create a Public IP Address
resource "azurerm_public_ip" "lb-ip" {
  name                = "test"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = azurerm_resource_group.rg.name
  sku                 = "Standard"
}
# Create a Load Balancer
resource "azurerm_lb" "loadBalancer" {
  name                = "test"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb-ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bpepool" {
  loadbalancer_id = azurerm_lb.loadBalancer.id
  name            = "BackEndAddressPool"
}

# Create a Load Balancer Rule
resource "azurerm_lb_rule" "lb_rule" {
  name                           = "HTTP"
  loadbalancer_id                = azurerm_lb.loadBalancer.id
  frontend_ip_configuration_name = azurerm_lb.loadBalancer.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bpepool.id] # Note: This is now an array
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

# Create a Health Probe
resource "azurerm_lb_probe" "lb_probe" {
  name            = "HTTP"
  loadbalancer_id = azurerm_lb.loadBalancer.id
  protocol        = "Tcp"
  port            = 80
  request_path    = "/"
}

# Public IP for NAT
resource "azurerm_public_ip" "nat_ip" {
  name                = "nat-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

#Create a NAT Gateway
resource "azurerm_nat_gateway" "nat_gateway" {
  name                = "nat-gateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard"
  zones               = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gw_ip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}
# Associate the NAT Gateway with the Subnet
resource "azurerm_subnet_nat_gateway_association" "nat_gw_assoc" {
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

# Create lb_nat_rule to allow ssh access to backend pool
resource "azurerm_lb_nat_rule" "lb_nat_rule" {
  name                           = "SSH"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.loadBalancer.id
  frontend_ip_configuration_name = azurerm_lb.loadBalancer.frontend_ip_configuration[0].name
  protocol                       = "Tcp"
  backend_port                   = 22
  frontend_port_end              = 50119
  frontend_port_start            = 50000
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bpepool.id
}