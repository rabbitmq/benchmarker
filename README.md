# benchmarker
A tool for benchmarking RabbitMQ on Kubernetes with various hardware and messaging configurations.

## Supported Kubernetes platforms
The tooling currently supports GKE using the [Terraform Kubernetes Engine Module](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine/google/latest).

## Getting started
To configure the Kubernetes cluster and hardware to deploy RabbitMQ, edit the terraform configuration in
`PROVIDER-cluster-config.tfvars`, where `PROVIDER` is one of `gke`, `aks`, or `eks`.

To configure RabbitMQ properties, edit the deployment YAML in `rabbitmq.yml`.
To configure the benchmark topology, edit `topology.json`.
To configure the benchmark RabbitMQ policies, edit `policy.json`.

Benchmarking requires an InfluxDB for collecting metrics. Credentials for this database must be stored in a Kubernetes secret named `influx-user` in the following format:
```YAML
name: <USERNAME>
password: <PASSWORD>
```
Additionally, the influxDB URL must be configured in `config.json`.

To run the benchmark, run the script `benchmark --provider (gke|aks|eks)`. This script will deploy a Kubernetes clsuter on the selected provider, deploy the cluster operator and a RabbitMQ cluster on that Kubernetes cluster, run the benchmark, ~exporting the results to the databases~, and finally tear down the infrastructure.
