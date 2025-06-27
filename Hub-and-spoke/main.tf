# This file contains the provider configuration for Terraform.
# It specifies the required provider and its version.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
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

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

data "local_file" "ssh_public_key" {
  filename = "C:/Users/KUB00093/.ssh/id_rsa.pub"  # Using forward slashes for Terraform on Windows
}

locals {
  // Any other local variables you might have
}