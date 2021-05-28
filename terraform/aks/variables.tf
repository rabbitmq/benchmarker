variable "appId" {
  description = "Azure Kubernetes Service Cluster service principal"
}

variable "password" {
  description = "Azure Kubernetes Service Cluster password"
}

variable "vm_size" {
  default = "Standard_D32_v4"
}

variable "node_count" {
  default = 3
}

variable "disk_size_gb" {
  default = 100
}
