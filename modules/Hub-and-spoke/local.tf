resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
locals {
  prefix-hub         = "hub"
  shared-key         = "4-v3ry-53cr37-1p53c-5h4r3d-k3y"
}
locals {
  prefix-spoke1         = "spoke1"
  prefix-spoke2         = "spoke2"
}