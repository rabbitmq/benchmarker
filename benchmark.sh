#!/usr/bin/env bash

set -euo pipefail

# echo "Deployment requires gcloud credentials"
# gcloud auth application-default login
# echo "gcloud authenticated"

# Deploy cluster on GKE
pushd terraform/gke
    echo "Terraforming a GKE cluster."
    terraform init
    terraform apply -var-file="../../cluster-config.tf"
    export KUBECONFIG="$PWD/kubeconfig-rabbitmq-benchmark"
    echo "Cluster created, credentials are located in 'terraform/gke/kubeconfig-rabbitmq-benchmark'."
popd

# Deploy cluster operator
echo "Deploying latest RabbitMQ cluster operator."
kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"
echo "Cluster operator deployed."

# Deploy a production ready cluster
echo "Deploying RabbitMQ cluster."
kubectl apply -f rabbitmq.yml
echo -n "Waiting for RabbitMQ cluster to be ready."
while [ "$(kubectl get rmq benchmark -o jsonpath='{.status.conditions[?(@.type=="AllReplicasReady")].status}')" != "True" ]; do
    echo -n "."
    sleep 5
done
echo " RabbitMQ cluster deployed."

# Now to actually run the benchmark
# The idea is to use RabbitTestTool, which requires some policy and topology files
# Additionally, we should collect the test results in an InfluxDB specified by the user

echo "Running Rabbit Test Tool. Test results exported to InfluxDB."
kubectl create configmap test-config --from-file=config.json
kubectl create configmap policy-config --from-file=policy.json
kubectl create configmap topology-config --from-file=topology.json
kubectl apply -f benchmarker.yml

# figure out how to detect when benchmark is finished
# echo "Benchmark completed"

# Tear down the GKE cluster
pushd terraform/gke
    echo "Destroying GKE cluster."
    terraform destroy
    echo "GKE cluster destroyed."
popd

# echo "Revoking gcloud credentials"
# gcloud auth application-default revoke
# echo "gcloud authentication revoked"
