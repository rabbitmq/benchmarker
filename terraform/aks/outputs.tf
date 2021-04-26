output "resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.default.name
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.default.kube_config_raw
}
