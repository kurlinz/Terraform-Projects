module "rg" {
  source   = "../modules/resource-group"
  name     = var.rg
  location = var.location
  tags = {
    environment = var.tag["environment"]
    project     = var.tag["project"]
  }
}

module "storage_account" {
  source               = "../modules/storage"
  storage_account_name = var.storage_acct_name
  location             = module.rg.location
  resource_group_name  = module.rg.name
  container-name       = var.container_name
}
module "gh_usri" {
  source     = "../modules/user-assigned-identity"
  name       = var.gh_usri_name
  location   = module.rg.location
  rg_name    = module.rg.name
  tags       = var.tag
}
module "federated_credentials" {
  source                             = "../modules/federated-identity-credential"
  federated_identity_credential_name = "gh-fic"
  user_assigned_identity_id          = module.gh_usri.user_assigned_identity_id
  rg_name                            = module.rg.name
  subject                            = "repo:${var.gh_usr_org}/${var.gh_repo_name}:ref:refs/heads/${var.gh_branch_name}"
  audience_name                      = local.default_audience_name
  issuer_url                         = local.github_issuer_url
}
module "Container_role_assignment" {
  source       = "../modules/role-assignment"
  scope_id     = module.storage_account.storage_account_id
  role_name    = "Storage Blob Data Contributor"
  principal_id = module.gh_usri.user_assigned_identity_principal_id
  depends_on   = [module.storage_account, module.gh_usri]
}
module "sub_role_assignment" {
  source       = "../modules/role-assignment"
  scope_id     = module.gh_usri.user_assigned_identity_id
  role_name    = "contributor"
  principal_id = module.gh_usri.user_assigned_identity_principal_id
  depends_on   = [module.gh_usri]
}
