#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./scripts/destroy_infra.sh <environment>"
  echo "Environments: development, production"
  exit 1
fi

echo "Initializing Terraform..."
terraform -chdir=infra init

TFVARS_FILE=${2:-environments/$ENV.tfvars}

echo "Destroying infrastructure for $ENV using $TFVARS_FILE..."
terraform -chdir=infra destroy -var-file=$TFVARS_FILE -auto-approve