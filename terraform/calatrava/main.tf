variable "nimbus_user" {}

variable "nimbus_nsname" {
   default = "rmqBenchmark"
}

variable "node_count" {
  default = 3
}

variable "workers_class" {
   default = "guaranteed-8xlarge"
}

terraform {
  required_providers {
    pacific = {
      source  = "eng.vmware.com/calatrava/pacific"
    }
  }
}

# Keep the nimbus server/config/ip values, they are fine for you to use
resource "pacific_nimbus_namespace" "ns" {
   user = var.nimbus_user
   name = var.nimbus_nsname

   # Pick one of sc2-01-vc16, sc2-01-vc17, wdc-08-vc04, wdc-08-vc05, wdc-08-vc07, wdc-08-vc08, sof2-01-vc06
   # Check slack channel #calatrava-notice for known issues
   nimbus = "wdc-08-vc04"
   nimbus_config_file = "/mts/git/nimbus-configs/config/staging/wcp.json"
}

// save kubeconfig
resource "local_file" "sv_kubeconfig" {
   sensitive_content = pacific_nimbus_namespace.ns.kubeconfig
   filename = "${path.module}/sv.kubeconfig"
   file_permission = "0644"
}

resource "pacific_guestcluster" "gc" {
   cluster_name = "gc"
   namespace = pacific_nimbus_namespace.ns.namespace
   input_kubeconfig = pacific_nimbus_namespace.ns.kubeconfig
   version = "v1.18"
   network_servicedomain = "cluster.local"
   topology_controlplane_class = "best-effort-medium"
   topology_workers_class = var.workers_class
   topology_workers_count = var.node_count
   topology_controlplane_storageclass = pacific_nimbus_namespace.ns.default_storageclass
   topology_workers_storageclass = pacific_nimbus_namespace.ns.default_storageclass
   storage_defaultclass = pacific_nimbus_namespace.ns.default_storageclass
}

// save kubeconfig
resource "local_file" "kubeconfig" {
   sensitive_content = pacific_guestcluster.gc.kubeconfig
   filename = "${path.module}/kubeconfig-rabbitmq-benchmark"
   file_permission = "0644"
}