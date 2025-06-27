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
}
#backend block to store tfstate file in Azure storage account
terraform {
  backend "azurerm" {
    resource_group_name   = "tfstate-day04"
    storage_account_name  = "day0412218"
    container_name        = "tfstate"
    key                   = "dev.terraform.tfstate"
    subscription_id       = var.subscription_id
  }
}
# Resource block to create resource group
resource "azurerm_resource_group" "rg" {
  name     = "terraformrg"
  location = "Germany West Central"
}

# Resource block to create storage account
resource "azurerm_storage_account" "sa" {
  name                     = "mystorage109999991"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}