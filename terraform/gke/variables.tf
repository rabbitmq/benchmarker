variable "project_id" {
  description = "The project ID to host the cluster in"
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "rabbitmq-benchmark"
}

variable "env_name" {
  description = "The environment for the GKE cluster"
  default     = "5-n2-standard-32-100G-ssd"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-west1"
}

variable "zones" {
    description = "The Availability Zones to deploy the cluster across. Must be within the region"
    default = ["europe-west1-a", "europe-west1-b", "europe-west1-c"]
}

variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "gke-network"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "gke-subnet"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-services"
}

variable "nodes" {
    description = "Number of Kubernetes nodes"
    default = 5
}

variable "machine_type" {
    description = "Machine type for Kubernetes nodes"
    default = "n2-standard-32"
}

variable "disk_size_gb" {
    description = "Disk size in GB"
    default = 100
}

variable "disk_type" {
    description = "Disk type"
    default = "pd_ssd"
}
