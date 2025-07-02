#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./scripts/destroy_infra.sh <environment>"
  echo "Environments: development, production"
  exit 1
fi

echo "Initializing Terraform..."
terraform -chdir=infra init

echo "Destroying infrastructure for $ENV..."
terraform -chdir=infra destroy -var-file=environments/$ENV.tfvars -auto-approve