# benchmarker
A tool for benchmarking RabbitMQ on Kubernetes with various hardware and messaging configurations.

## Supported Kubernetes platforms
The tooling currently supports GKE, AKS, and EKS via terraform modules.

## Getting started
To configure the Kubernetes cluster and hardware to deploy RabbitMQ, edit the terraform configuration in
`PROVIDER-cluster-config.tfvars`, where `PROVIDER` is one of `gke`, `aks`, or `eks`.

To configure RabbitMQ properties, edit the values YAML in `RabbitMQ-values.yml`.

To configure the benchmark topology, edit `topology.json`.
To configure the benchmark RabbitMQ policies, edit `policy.json`.
The topology and policy files are used to configure [RabbitTestTool](https://github.com/rabbitmq/rabbittesttool). For more detailed descriptions and configuration options, see the [RTT documentation](https://github.com/rabbitmq/RabbitTestTool/tree/main/benchmark).

To run the benchmark, run the script
```shell
benchmark --provider (gke|aks|eks)
```
This script will deploy a Kubernetes clsuter on the selected provider, deploy the cluster operator and a RabbitMQ cluster on that Kubernetes cluster, and run the benchmark, exporting the results to the databases.

To tear down the infrastructure provisioned by the operator, run
```shell
benchmark destroy --provider (gke|aks|eks)
```
**Note**: this operation is destructive and will result in the loss of the benchmark data.
