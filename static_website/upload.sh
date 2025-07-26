#!/bin/bash

# Azure CLI script to upload files to a static website hosted on Azure Storage
# Ensure you have the Azure CLI installed and logged in to your Azure account   
# Replace <storage_account_name> with your actual storage account name

# login to Azure
# az login

# upload files to the static website container
az storage blob upload-batch \
  --account-name mystaticwebsite12345 \
  --destination '$web' \
  --source c:/Users/KUB00093/Desktop/Projects/portfolio