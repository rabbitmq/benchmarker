# benchmarker
A tool for benchmarking RabbitMQ on Kubernetes with various hardware and messaging configurations.

## Supported Kubernetes platforms
The tooling currently supports GKE, AKS, EKS, and Calatrava (Project Pacific) via terraform modules.

## Getting started

### Configuration
To configure the Kubernetes cluster and hardware to deploy RabbitMQ, edit the terraform configuration in
`PROVIDER-cluster-config.tfvars`, where `PROVIDER` is one of `gke`, `aks`, `eks`, or `calatrava`.

To configure RabbitMQ properties, edit the values YAML in `RabbitMQ-values.yml`.

To configure the benchmark topology, edit `topology.json`.
To configure the benchmark RabbitMQ policies, edit `policy.json`.
The topology and policy files are used to configure [RabbitTestTool](https://github.com/rabbitmq/rabbittesttool). For more detailed descriptions and configuration options, see the [RTT documentation](https://github.com/rabbitmq/RabbitTestTool/tree/main/benchmark).

### Running

To provision an environment and run the benchmark, run the script
```shell
benchmark --provider (gke|aks|eks|calatrava)
```
This script will deploy a Kubernetes cluster on the selected provider, deploy the cluster operator, a RabbitMQ cluster, Prometheus, Grafana, and InfluxDB on that Kubernetes cluster, then run the benchmark, exporting the results to the databases.

To use an existing Kubernetes cluster to run the benchmark, run the script
```shell
benchmark --skip-terraform
```
This will deploy the cluster operator, a RabbitMQ cluster, Prometheus, Grafana, and InfluxDB on the targeted Kubernetes cluster, then run the configured benchmark, exporting the results to the databases.

To access the Grafana dashboards, run the command
```bash
kubectl -n prom port-forward svc/prom-grafana 3000:80
```
then open a browser window to `http://localhost:3000` and login with the credentials `admin:admin`.

### Cleanup

To tear down the infrastructure provisioned by the operator, run
```shell
benchmark destroy --provider (gke|aks|eks|calatrava)
```
**Note**: this operation is destructive and will result in the loss of the benchmark data.

## Results

| *Messages/second* | *Message Size (KB)* | *Replication Factor* | *Queue type*  | *Cores (per Node)* | *Memory (GB)* |
| ----------------: | ------------------: | -------------------: | ------------- |-----------------: | ------------: |
| NNNNNN            | NN                  | 3                    | quorum/stream | N                  | NN            |

### Adding new results
 To add new benchmarking results, please open a PR with your addition.
