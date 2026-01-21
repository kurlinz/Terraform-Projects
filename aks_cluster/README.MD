# Deploying an Azure Kubernetes Service (AKS) cluster using Terraform
https://learn.microsoft.com/de-de/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli

## Use the following command to retrieve the Kubernetes configuration from the Terraform state and save it to a kubectlreadable file.
echo "$(terraform output kube_config)" > ./azurek8s

Make sure the previous command did not add an ASCII EOT character by using the "" command.
cat ./azurek8s

## The most important points:

If you see " at the beginning << EOTand end EOT, remove those characters from the file. Otherwise, you may receive the following error message:error: error loading config file "./azurek8s": yaml: line 2: mapping values are not allowed in this context

## Use the following command to set an environment variable so that kubectlthe correct configuration can be adopted.
export KUBECONFIG=./azurek8s

## Verify the integrity of the cluster using the command " kubectl get nodes".
kubectl get nodes

# Deploying the application
https://learn.microsoft.com/de-de/azure/aks/learn/quick-kubernetes-deploy-terraform?pivots=development-environment-azure-cli#deploy-the-application