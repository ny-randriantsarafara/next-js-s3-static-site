# Next.js Static Site on AWS S3

This repository contains a Next.js static site and its infrastructure as code (IaC) using Terraform, organized for enterprise-grade development practices.

## Project Overview

This project demonstrates a modular and scalable approach to deploying a Next.js static website to AWS S3. It separates application code from infrastructure code, uses Terraform modules for reusability, and provides clear scripts for development and deployment.

## Repository Structure

- `app/`: Contains the Next.js application code, including pages, components, and application-specific configurations.
- `infra/`: Contains the Terraform configurations for provisioning AWS infrastructure (S3 bucket, etc.).
  - `infra/environments/`: Holds environment-specific Terraform variable files (`dev.tfvars`, `prod.tfvars`).
  - `infra/modules/`: Contains reusable Terraform modules (e.g., `s3-static-site` module).
- `docs/`: Placeholder for project documentation.
- `.github/workflows/`: Placeholder for GitHub Actions CI/CD workflows.
- `package.json`: Root-level `package.json` for orchestrating application and infrastructure tasks via npm scripts.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

-   [Node.js](https://nodejs.org/en/) (LTS version recommended)
-   [npm](https://www.npmjs.com/get-npm) (comes with Node.js)
-   [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials and a default region.
-   [Terraform](https://www.terraform.io/downloads.html) (v1.0.0 or later recommended)

## Local Development

To set up the project and run the Next.js application locally:

1.  **Install all dependencies and initialize infrastructure:**
    ```bash
    npm install
    ```
    This command will automatically:
    *   Install root-level npm dependencies.
    *   Install Next.js application dependencies in `app/`.
    *   Initialize Terraform in `infra/`.

2.  **Start the development server:**
    ```bash
    npm start
    ```
    The application will be accessible at `http://localhost:3000`.

## Infrastructure Setup and Deployment

All infrastructure commands are aliased as npm scripts in the root `package.json`. After running `npm install` once, you can use these commands:

1.  **Initialize Terraform (if not already done by `npm install`):**
    ```bash
    npm run infra:init
    ```

2.  **Plan Infrastructure Changes (Development Environment):**
    ```bash
    npm run infra:plan:dev
    ```
    (For production, use `npm run infra:plan:prod`)

3.  **Apply Infrastructure Changes (Development Environment):**
    ```bash
    npm run infra:apply:dev
    ```
    (For production, use `npm run infra:apply:prod`)

4.  **Destroy Infrastructure (Development Environment - Use with Caution!):**
    ```bash
    npm run infra:destroy:dev
    ```
    (For production, use `npm run infra:destroy:prod`)

## Application Build and Deployment

To build the Next.js application and deploy it to the provisioned S3 bucket:

1.  **Deploy the application to the development environment:**
    ```bash
    npm run deploy:app:dev
    ```
    This script will:
    *   Build the Next.js application (output to `app/out/`).
    *   Dynamically retrieve the S3 bucket name from Terraform outputs.
    *   Synchronize the built files to the S3 bucket.

    For production deployment, use:
    ```bash
    npm run deploy:app:prod
    ```

## Pre-commit Hooks

This repository uses [Husky](https://typicode.github.io/husky/) and [lint-staged](https://github.com/okonet/lint-staged/) to automatically format and lint code before commits. When you commit changes, the following will happen:

*   Files staged for commit will be linted and formatted according to the configurations in `app/.eslintrc.json` and `app/.prettierrc.json`.
*   Any formatting fixes will be automatically added to your commit.

## Accessing Your Site

Once the application assets are synced to the S3 bucket, your static site will be accessible via the S3 website endpoint. You can find this endpoint in the Terraform output after `terraform apply` or by checking the S3 bucket properties in the AWS console.