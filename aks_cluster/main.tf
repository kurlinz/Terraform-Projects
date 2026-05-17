module "rg" {
  source   = "../modules/resource-group"
  name     = var.rg
  location = var.location
  tags     = var.tags
}
module "vnet" {
  source               = "../modules/Vnet"
  Vnet_name            = var.vnet_name
  location             = module.rg.location
  resource_group_name  = module.rg.name
  vnet_address_space   = var.vnet_address_space
  subnet_name          = var.subnet_name
  subnet_address_space = var.subnet_address_space
}
module "ssh-key" {
  source = "../modules/ssh-key"
  resource_group_id = module.rg.id
  resource_group_location = module.rg.location
}
module "aks" {
  source              = "../modules/aks"
  resource_group_name = module.rg.name
  location            = module.rg.location
  cluster_name        = var.aks-name
  admin_username      = var.username
  node-pool-name      = var.node_pool_name
  node_count          = var.node_count
  node-pool-vm-size   = var.vm_size
  ssh_key             = module.ssh-key.key_data
  vnet_subnet_id      = module.vnet.subnet_id
  auto-scaling        = var.auto-scaling
}