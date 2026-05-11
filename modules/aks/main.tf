resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
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
  location            = var.location
  name                = var.cluster_name
  resource_group_name = var.resource_group_name
  role_based_access_control_enabled = var.rbac
  dns_prefix = "${random_pet.azurerm_kubernetes_cluster_dns_prefix.id}-${var.cluster_name}"
  oidc_issuer_enabled = var.oidc_enabled
  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name           = var.node-pool-name
    vm_size        = var.node-pool-vm-size
    node_count     = var.node_count
    min_count           = var.min-count
    max_count = var.max-count
    vnet_subnet_id = azurerm_subnet.aks_nodes.id
  }

  network_profile {
    network_plugin = "azure"
  }

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = file(var.ssh_key_path)
    }
  }
}
