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

There is a significant amount of performance information captured in a series of blog posts by Jack Vanlightly from 2020.
- [Cluster Sizing](https://blog.rabbitmq.com/posts/2020/06/cluster-sizing-and-other-considerations/)
- [Quorum Queues](https://blog.rabbitmq.com/posts/2020/06/cluster-sizing-case-study-quorum-queues-part-1/)
- [Mirrored Queues](https://blog.rabbitmq.com/posts/2020/06/cluster-sizing-case-study-mirrored-queues-part-1/)

| *Messages/second* | *Message Size (KB)* | *Queue Type* | *Replication Factor* | *Cluster Size* | *Cores (per Node)* | *Memory (GB per Node)* | *Disk Type* |
| ----------------: | ------------------: | -----------: | -------------------: | -------------: | -----------------: | ---------------------: | ----------: |
| 36,000            | 1                   | quorum       | 3                    | 3              | 16                 | 32                     | SSD         |
| 37,000            | 1                   | quorum       | 3                    | 3              | 36                 | 72                     | SSD         |
| 42,000            | 1                   | quorum       | 3                    | 5              | 8                  | 16                     | SSD         |
| 54,000            | 1                   | quorum       | 3                    | 5              | 16                 | 32                     | SSD         |
| 54,000            | 1                   | quorum       | 3                    | 7              | 8                  | 16                     | SSD         |
| 67,000            | 1                   | quorum       | 3                    | 7              | 16                 | 16                     | SSD         |
| 66,000            | 1                   | quorum       | 3                    | 9              | 8                  | 16                     | SSD         |

### Adding new results
 To add new benchmarking results, please open a PR with your addition.
