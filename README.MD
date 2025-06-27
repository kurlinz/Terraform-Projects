# Creating a Service Principal
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/20000000-0000-0000-0000-000000000000"

# These values map to the Terraform variables like so:
appId is the client_id defined above.
password is the client_secret defined above.
tenant is the tenant_id defined above. 


