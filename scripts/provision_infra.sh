#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./scripts/provision_infra.sh <environment>"
  echo "Environments: development, production"
  exit 1
fi

echo "Initializing Terraform..."
terraform -chdir=infra init

echo "Planning infrastructure for $ENV..."
terraform -chdir=infra plan -var-file=environments/$ENV.tfvars

echo "Applying infrastructure for $ENV..."
terraform -chdir=infra apply -var-file=environments/$ENV.tfvars -auto-approve
