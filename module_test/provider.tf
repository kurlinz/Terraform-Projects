# Terrafprm provider block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.21.1"
    }
     random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
    azapi = {
      source = "Azure/azapi"
      version = "2.4.0"
    }
     modtm = {
      source = "Azure/modtm"
      version = "0.3.5"
    }
  }
}
# Azure provider block
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}
provider "random" {
  # Configuration options
}
provider "azapi" {
  # Configuration options
}
provider "modtm" {
  # Configuration options
}