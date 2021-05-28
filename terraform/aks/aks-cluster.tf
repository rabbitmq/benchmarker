resource "azurerm_kubernetes_cluster" "benchmark" {
  name                = "${random_pet.prefix.id}-aks"
  location            = azurerm_resource_group.benchmark.location
  resource_group_name = azurerm_resource_group.benchmark.name
  dns_prefix          = "${random_pet.prefix.id}-k8s"

  default_node_pool {
    name            = "data-pool"
    node_count      = 3
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 100
  }

  resource "azurerm_kubernetes_cluster_node_pool" "rabbit-pool" {
    name = "rabbit-pool"
    kubernetes_cluster_id = azurerm_kubernetes_cluster.benchmark.id
    vm_size = var.vm_size
    node_count = var.node_count
    os_disk_size_gb = var.disk_size_gb
    node_labels = { rabbit-pool = true }
    node_taints = [ "rabbit-pool=true:NoSchedule" ]

    tags = {
      Environment = "rabbit-pool"
    }
  }

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control {
    enabled = true
  }

  tags = {
    environment = "Benchmark"
  }
}