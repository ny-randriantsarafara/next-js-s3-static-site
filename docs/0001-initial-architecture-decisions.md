# 0001 - Initial Architecture Decisions

## Status

Accepted

## Context

This document explains the core choices made for setting up this repository, which is designed for a simple, static website like a personal portfolio. We focused on making it easy to manage and deploy.

## Key Decisions

### 1. Next.js for the Website (using Pages Router)

*   **Why Next.js?** It's a great tool for building React websites, especially when you want a static site. It handles things like building your site into simple HTML, CSS, and JavaScript files.
*   **Why Pages Router?** For a straightforward static site like a portfolio, the Pages Router is perfect. It's simpler to use and gets the job done without the extra complexity of the newer App Router, which is more suited for dynamic, server-heavy applications.

### 2. Hosting on AWS S3

*   **Why S3?** Amazon S3 is a super reliable and cheap way to host static files. It's built for websites that don't need a server running all the time, like a portfolio.

### 3. Infrastructure as Code with Terraform

*   **Why Terraform?** Instead of manually setting up AWS, we use Terraform. This means our AWS setup is written as code, making it easy to track changes, share with others, and deploy consistently every time.

### 4. Organized Repository Structure

*   **Why separate `app/` and `infra/`?** We keep the website code (`app/`) separate from the AWS setup code (`infra/`). This makes the project cleaner, easier to understand, and allows us to work on the website and infrastructure independently.

### 5. Reusable Terraform Modules

*   **Why modules?** We've packaged common AWS setups (like the S3 website) into reusable blocks called modules. This avoids repeating code and ensures our infrastructure is consistent.

### 6. Easy Commands with npm Scripts

*   **Why npm scripts?** We've put all the common commands (like starting the website or deploying AWS) into simple `npm run` commands. This makes it super easy for anyone to get started and ensures everyone runs the same commands.

### 7. Environment-Specific Settings with `.tfvars`

*   **Why `.tfvars`?** We use special files (like `dev.tfvars` and `prod.tfvars`) to store settings that change between environments (like the website name). This keeps our main setup clean and makes it easy to deploy to different places without changing code.

## What This Means for You

*   **Initial Setup:** Getting everything set up might take a few more steps initially because we're using code for infrastructure.
*   **Easier to Maintain:** Once set up, the project is much easier to manage and update.
*   **Ready for Growth:** The way it's built makes it easy to add more features or deploy to new environments in the future.
*   **Consistent Deployments:** You'll get the same result every time you deploy, reducing surprises.
