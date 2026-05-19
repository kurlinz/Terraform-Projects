#!/bin/bash

# ── Derived / ensure subscription is set ─────────────────────────────────────
export SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az account set --subscription "${SUBSCRIPTION_ID}"
echo "Using subscription: ${SUBSCRIPTION_ID}"

# ── Variables ────────────────────────────────────────────────────────────────
RESOURCE_GROUP="rg-tfstate"
LOCATION="germanywestcentral"
STORAGE_ACCOUNT_NAME="sttfstate$RANDOM"   # must be globally unique
CONTAINER_NAME="tfstate"
USRI_NAME="id-github-actions"
TAG_ENVIRONMENT="dev"
TAG_PROJECT="platform"

GH_ORG="kurlinz"
GH_REPO="Terraform-Projects"
GH_BRANCH="master"

FIC_NAME="gh-fic"
AUDIENCE="api://AzureADTokenExchange"
ISSUER_URL="https://token.actions.githubusercontent.com"
SUBJECT="repo:${GH_ORG}/${GH_REPO}:ref:refs/heads/${GH_BRANCH}"

# ── Resource Group ────────────────────────────────────────────────────────────
echo "Creating resource group..."
az group create \
  --name "${RESOURCE_GROUP}" \
  --location "${LOCATION}" \
  --tags environment="${TAG_ENVIRONMENT}" project="${TAG_PROJECT}"

# ── Storage Account ───────────────────────────────────────────────────────────
echo "Creating storage account..."
az storage account create \
  --name "${STORAGE_ACCOUNT_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --location "${LOCATION}" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --https-only true \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false

export STORAGE_ACCOUNT_ID=$(az storage account show \
  --name "${STORAGE_ACCOUNT_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --query id -o tsv)

# ── Blob Container ────────────────────────────────────────────────────────────
echo "Creating blob container..."
az storage container create \
  --name "${CONTAINER_NAME}" \
  --account-name "${STORAGE_ACCOUNT_NAME}" \
  --auth-mode login

# ── User Assigned Managed Identity ───────────────────────────────────────────
echo "Creating user-assigned managed identity..."
az identity create \
  --name "${USRI_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --location "${LOCATION}" \
  --tags environment="${TAG_ENVIRONMENT}" project="${TAG_PROJECT}"

export USRI_ID=$(az identity show \
  --name "${USRI_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --query id -o tsv)

export USRI_PRINCIPAL_ID=$(az identity show \
  --name "${USRI_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --query principalId -o tsv)

export USRI_CLIENT_ID=$(az identity show \
  --name "${USRI_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --query clientId -o tsv)

# ── Federated Identity Credential ─────────────────────────────────────────────
echo "Creating federated identity credential..."
az identity federated-credential create \
  --name "${FIC_NAME}" \
  --identity-name "${USRI_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --issuer "${ISSUER_URL}" \
  --subject "${SUBJECT}" \
  --audiences "${AUDIENCE}"

# Role assignments need the SP to be visible in AAD — retry loop for propagation
echo "Waiting for identity to propagate..."
sleep 20

echo "${SUBSCRIPTION_ID}"
echo "${STORAGE_ACCOUNT_ID}"
echo "${USRI_PRINCIPAL_ID}"
# ── Role: Contributor (subscription scope) ────────────────────────────────────
echo "Assigning Contributor role at subscription scope..."
az role assignment create \
  --assignee-object-id "${USRI_PRINCIPAL_ID}" \
  --assignee-principal-type ServicePrincipal \
  --role "b24988ac-6180-42a0-ab88-20f7382dd24c" \
  --scope "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}"

# ── Role:Azure Container Storage Operator (storage account scope) ───────────────
echo "Assigning Azure Container Storage Operator role..."
az role assignment create \
  --assignee-object-id "${USRI_PRINCIPAL_ID}" \
  --assignee-principal-type ServicePrincipal \
  --role "08d4c71a-cc63-4ce4-a9c8-5dd251b4d619" \
  --scope "${STORAGE_ACCOUNT_ID}"

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "──────────────────────────────────────────────────"
echo " Bootstrap complete. Use these in your GH Actions:"
echo "──────────────────────────────────────────────────"
echo "  ARM_CLIENT_ID       = ${USRI_CLIENT_ID}"
echo "  ARM_SUBSCRIPTION_ID = ${SUBSCRIPTION_ID}"
echo "  ARM_TENANT_ID       = $(az account show --query tenantId -o tsv)"
echo "  STORAGE_ACCOUNT     = ${STORAGE_ACCOUNT_NAME}"
echo "  CONTAINER_NAME      = ${CONTAINER_NAME}"
echo "──────────────────────────────────────────────────"