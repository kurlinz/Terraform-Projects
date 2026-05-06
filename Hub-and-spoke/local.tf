resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

data "local_file" "ssh_public_key" {
  filename = "C:/Users/KUB00093/.ssh/id_rsa.pub"  # Using forward slashes for Terraform on Windows
}
locals {
  prefix-hub         = "hub"
  hub-resource-group = "hub-vnet-rg-${random_string.suffix.result}"
  shared-key         = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}