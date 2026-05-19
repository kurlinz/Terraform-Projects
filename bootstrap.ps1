$ErrorActionPreference = "Stop"

# CONFIG
$resourceGroup = "rg-tfstate"
$location = "germanywestcentral"
$containerName = "tfstate"
$identityName = "id-github-actions"

$ghOrg = "kurlinz"
$ghRepo = "Terraform-Projects"
$ghBranch = "master"

$audience = "api://AzureADTokenExchange"
$issuer = "https://token.actions.githubusercontent.com"
$subject = "repo:$ghOrg/$ghRepo:ref:refs/heads/$ghBranch"

# LOGIN CHECK
az account show | Out-Null

$subscriptionId = az account show --query id -o tsv
$tenantId = az account show --query tenantId -o tsv
az account set --subscription $subscriptionId

Write-Host "Using subscription $subscriptionId"

# RESOURCE GROUP (idempotent)
az group create `
  --name $resourceGroup `
  --location $location | Out-Null

# STORAGE ACCOUNT (safe unique name)
$rand = -join ((97..122) | Get-Random -Count 6 | ForEach-Object {[char]$_})
$storageAccount = "sttf$rand"

$existing = az storage account list --resource-group $resourceGroup --query "[0].name" -o tsv

if ($existing) {
  $storageAccount = $existing
} else {
  az storage account create `
    --name $storageAccount `
    --resource-group $resourceGroup `
    --location $location `
    --sku Standard_LRS `
    --kind StorageV2 `
    --https-only true `
    --allow-blob-public-access false | Out-Null
}

$storageId = az storage account show `
  --name $storageAccount `
  --resource-group $resourceGroup `
  --query id -o tsv

# CONTAINER (idempotent)
az storage container create `
  --name $containerName `
  --account-name $storageAccount `
  --auth-mode login | Out-Null

# MANAGED IDENTITY
$exists = az identity show --name $identityName --resource-group $resourceGroup 2>$null

if (-not $exists) {
  az identity create `
    --name $identityName `
    --resource-group $resourceGroup `
    --location $location | Out-Null
}

$clientId = az identity show --name $identityName --resource-group $resourceGroup --query clientId -o tsv
$principalId = az identity show --name $identityName --resource-group $resourceGroup --query principalId -o tsv

# FEDERATED CREDENTIAL (idempotent check)
$fc = az identity federated-credential list `
  --identity-name $identityName `
  --resource-group $resourceGroup `
  --query "[?name=='gh-fic'] | [0].name" -o tsv

if (-not $fc) {
  az identity federated-credential create `
    --name "gh-fic" `
    --identity-name $identityName `
    --resource-group $resourceGroup `
    --issuer $issuer `
    --subject $subject `
    --audiences $audience | Out-Null
}

# RBAC
$rgScope = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup"

az role assignment create `
  --assignee-object-id $principalId `
  --assignee-principal-type ServicePrincipal `
  --role "b24988ac-6180-42a0-ab88-20f7382dd24c" `
  --scope $rgScope

az role assignment create `
  --assignee-object-id $principalId `
  --assignee-principal-type ServicePrincipal `
  --role "08d4c71a-cc63-4ce4-a9c8-5dd251b4d619" `
  --scope $storageId

# OUTPUT
Write-Host "`n--- GitHub Actions ---"
Write-Host "ARM_CLIENT_ID=$clientId"
Write-Host "ARM_SUBSCRIPTION_ID=$subscriptionId"
Write-Host "ARM_TENANT_ID=$tenantId"
Write-Host "STORAGE_ACCOUNT=$storageAccount"
Write-Host "CONTAINER=$containerName"