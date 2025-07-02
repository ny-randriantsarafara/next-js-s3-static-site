#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./scripts/deploy_app.sh <environment>"
  echo "Environments: development, production"
  exit 1
fi

echo "Building Next.js application..."
npm run app:build

echo "Getting S3 bucket name for $ENV environment..."
S3_BUCKET_NAME=$(terraform -chdir=infra output -raw s3_bucket_name)

if [ -z "$S3_BUCKET_NAME" ]; then
  echo "Error: Could not retrieve S3 bucket name for $ENV environment."
  exit 1
fi

echo "Deploying application to s3://$S3_BUCKET_NAME..."
aws s3 sync app/out/ s3://$S3_BUCKET_NAME --delete
