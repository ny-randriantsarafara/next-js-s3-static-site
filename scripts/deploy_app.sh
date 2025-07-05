#!/bin/bash

set -euo pipefail

INFRA_DIR="infra"

echo "Building Next.js application..."
npm run app:build

echo "Initializing Terraform..."
terraform -chdir="$INFRA_DIR" init -input=false

echo "Getting S3 bucket name..."
S3_BUCKET_NAME=$(terraform -chdir="$INFRA_DIR" output -raw s3_bucket_name)

echo "Deploying application to s3://${S3_BUCKET_NAME}..."
aws s3 sync app/out/ "s3://${S3_BUCKET_NAME}" --delete

echo "Changes deployed successfully !"
