# module "VM" {
#   source = "../Vm"
#   resource_group_name = "modeule-test-rg"
#   location = "Germany West Central"
#   VM_name = ["module-test-vm1", "module-test-vm2"]
# }

# module "avm-res-network-virtualnetwork" {
#   source = "Azure/avm-res-network-virtualnetwork/azurerm"
#   name = "myVnet"
#   address_space       = ["10.0.0.0/16"]
#   location            = "Germany West Central"
#   resource_group_name = "myResourceGroup"
# }
