# Generate random resource group name

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = var.resource_group_name
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_virtual_network" "aks" {
  name                = "aks-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/8"]
}

resource "azurerm_subnet" "aks_nodes" {
  name                 = "aks-nodes"
  address_prefixes     = ["10.240.0.0/16"]
  virtual_network_name = azurerm_virtual_network.aks.name
  resource_group_name  = azurerm_resource_group.rg.name
}

# resource "azurerm_subnet" "subnet-alb" {
#   name                 = "subnet-alb"
#   address_prefixes     = ["10.241.0.0/24"]
#   virtual_network_name = azurerm_virtual_network.aks.name
#   resource_group_name  = azurerm_resource_group.rg.name

#   delegation {
#     name = "agc-delegation"
#     service_delegation {
#       name = "Microsoft.ServiceNetworking/trafficControllers"
#     }
#   }
# }
#   A subnet with delegation to Microsoft.ServiceNetworking/trafficControllers
#   is created on the app_gw_for_containers.ps1 script.

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name           = "agentpool"
    vm_size        = "Standard_D2_v2"
    node_count     = var.node_count
    vnet_subnet_id = azurerm_subnet.aks_nodes.id
  }

  network_profile {
    network_plugin = "azure"
  }
}