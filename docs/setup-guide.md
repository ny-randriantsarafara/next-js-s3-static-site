# Detailed Setup Guide

This guide provides quick steps to get the project running locally and deployed to AWS.

## Prerequisites

Ensure you have the following installed:

*   **Node.js & npm:** [Download & Install](https://nodejs.org/en/download/)
*   **AWS CLI:** [Install & Configure](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    *   Make sure your AWS CLI is configured with credentials that have permissions to create S3 buckets and manage their content.
*   **Terraform:** [Install Terraform](https://www.terraform.io/downloads.html)

## 1. Local Development Setup

To get the Next.js application running on your local machine:

1.  **Install all dependencies and initialize infrastructure:**
    Open your terminal in the project's root directory and run:
    ```bash
    npm install
    ```
    This command automatically installs Node.js dependencies for both the root and the `app/` directory, and initializes Terraform in the `infra/` directory.

2.  **Start the development server:**
    ```bash
    npm start
    ```
    Your application will be available at `http://localhost:3000`.

## 2. Deploy to AWS (Development Environment)

This section guides you through deploying your static site to an AWS S3 bucket.

1.  **Review Environment Variables:**
    Check the `infra/environments/dev.tfvars` file. This file defines variables like your S3 bucket name for the development environment. You might need to change `your-nextjs-static-site-dev-bucket` to a globally unique name.

2.  **Deploy Infrastructure:**
    From the project root, run the Terraform apply command for the development environment:
    ```bash
    npm run infra:apply:dev
    ```
    This will provision an S3 bucket configured for static website hosting in your AWS account. Confirm the apply by typing `yes` when prompted.

3.  **Deploy Application:**
    Once the infrastructure is provisioned, deploy your Next.js application to the S3 bucket:
    ```bash
    npm run deploy:app:dev
    ```
    This script will:
    *   Build your Next.js application.
    *   Dynamically retrieve the S3 bucket name from Terraform outputs.
    *   Synchronize the output to the S3 bucket. The `--delete` flag ensures that files removed from your local `app/out/` directory are also removed from the S3 bucket.

## Accessing Your Deployed Site

After the `npm run deploy:app:dev` command completes, your static site will be accessible via the S3 website endpoint. You can find this endpoint in the output of `npm run infra:apply:dev` or by navigating to your S3 bucket in the AWS Management Console and checking its properties under "Static website hosting."
