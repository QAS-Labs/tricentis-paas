#!/bin/bash

# Install PSQL
helm install psql \
    --set auth.postgresPassword=postgres \
    --set auth.database=qTest \
    bitnami/postgresql 

# Optional step to pull image from private repo
kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=$HOME/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson