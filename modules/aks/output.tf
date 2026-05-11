output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}
output "client-certificate" {
  value = azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_certificate
}
output "client-key" {
  value = azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_key
}
output "cluster-ca-certificate" {
  value = azurerm_kubernetes_cluster.k8s.kube_admin_config.0.cluster_ca_certificate
}
output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
}