# Terrafprm provider block
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>4.21.1"
    }
  }
}
# Azure provider block
provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
}