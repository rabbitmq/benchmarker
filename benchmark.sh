#!/usr/bin/env bash

set -euo pipefail

# echo "Deployment requires gcloud credentials"
# gcloud auth application-default login
# echo "gcloud authenticated"

# Deploy cluster on GKE
pushd terraform/gke
    echo "Terraforming a GKE cluster"
    terraform init
    terraform apply
    export KUBECONFIG="$PWD/kubeconfig-rabbitmq-benchmark"
    echo "Cluster created, credentials are located in 'terraform/gke/kubeconfig-rabbitmq-benchmark'"
popd

# Deploy cluster operator
echo "Deploying latest RabbitMQ cluster operator"
kubectl apply -f "https://github.com/rabbitmq/cluster-operator/releases/latest/download/cluster-operator.yml"
echo "Cluster operator deployed"

# Deploy a production ready cluster
echo "Deploying RabbitMQ cluster"
kubectl apply -f rabbitmq.yml
echo "RabbitMQ cluster deployed"

# Now to actually run the benchmark
# The idea is to use RabbitTestTool, which requires some policy and topology files
# Additionally, we should collect the test results in an InfluxDB and PostgreSQL specified by the user

# echo "Running Rabbit Test Tool"
# echo "Test results exported to InfluxDB and PostgreSQL"
# kubectl run java --expose=true --port=8080 --labels="app=rabbit-test-tool,run=rabbit-test-tool" \
# --image/pivotalrabbitmq/rabbittesttool \
# -- -jar rabbittesttool-1.1-SNAPSHOT-jar-with-dependencies.jar \
# --mode benchmark \
# --topology /path/to/topology-file \
# --technology rabbitmq \
# --version 3.7.15 \
# --broker-hosts localhost:5672 \
# --broker-mgmt-port 15672 \
# --broker-port 5672 \
# --broker-user GET_FROM_SECRET \
# --broker-password GET_FROM_SECRET \
# --metrics-influx-uri http://INFLUX_URI:8086 \
# --metrics-influx-user amqp \
# --metrics-influx-password amqp \
# --metrics-influx-database amqp \
# --metrics-influx-interval 10 \
# --postgres-jdbc-url jdbc:postgresql://POSTGRES_URI:5432/amqpbenchmarks \
# --postgres-user POSTGRES_USER \
# --postgres-pwd POSTGRES_PASSWORD

# figure out how to detect when benchmark is finished
# echo "Benchmark completed"

# Tear down the GKE cluster
pushd terraform/gke
    echo "Destroying GKE cluster"
    terraform destroy
    echo "GKE cluster destroyed"
popd

# echo "Revoking gcloud credentials"
# gcloud auth application-default revoke
# echo "gcloud authentication revoked"
