# Setting Up Your AWS CI/CD Role with OIDC for GitHub Actions

This guide outlines the steps to create a secure IAM Role for your Continuous Integration/Continuous Deployment (CI/CD) pipeline using OpenID Connect (OIDC) with GitHub Actions. OIDC allows GitHub Actions to securely assume an AWS IAM Role without needing long-lived AWS credentials, significantly enhancing your security posture.

## Why IAM Roles for CI/CD?

Instead of using traditional IAM Users with static access keys, IAM Roles provide temporary credentials that are automatically rotated. This means:

- **Enhanced Security**: No long-lived credentials to manage or accidentally expose.
- **Least Privilege**: You can define precise permissions for what your CI/CD pipeline can do.
- **Cross-Account Access**: Securely grant your GitHub Actions workflow access to specific AWS accounts.
- **Auditability**: All actions performed by the assumed role are logged in AWS CloudTrail.

## Prerequisites

- An AWS account where your project resources will be deployed (e.g., your Project 1 Dev Account).
- Your GitHub Organization/Username and Repository Name (e.g., `my-org/my-repo`). These are part of your repository's URL on GitHub.
- Your AWS Account ID (a 12-digit number, found in the AWS Management Console by clicking on your account name in the top right corner, under 'Account ID').

## Step-by-Step Guide

You will perform these steps primarily in the AWS Management Console of the target AWS account where your CI/CD pipeline needs to deploy resources (e.g., your Project 1 Dev Account).

### Step 1: Create an IAM OIDC Provider

This step establishes a trust relationship between AWS and GitHub's OIDC identity provider.

1.  Log in to your target AWS account.
2.  Navigate to the **IAM** service.
3.  In the left navigation pane, choose **Identity providers**.
4.  Click **Add provider**.
5.  Select **OpenID Connect**.
6.  Configure Provider Details:
    - **Provider URL**: `https://token.actions.githubusercontent.com`
    - **Audience**: `sts.amazonaws.com`
7.  Click **Add provider**.

### Step 2: Create the CI/CD Deployment IAM Role

Now, you'll create the IAM Role that your GitHub Actions workflow will assume to interact with AWS.

1.  Navigate to **IAM** > **Roles**.
2.  Click **Create role**.
3.  For "Select type of trusted entity," choose **Custom trust policy**.
4.  Paste the following Trust Policy. This policy defines who (your GitHub Actions workflow) is allowed to assume this role and under what conditions.

    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Federated": "arn:aws:iam::<YOUR_ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
          },
          "Action": "sts:AssumeRoleWithWebIdentity",
          "Condition": {
            "StringLike": {
              "token.actions.githubusercontent.com:sub": "repo:<YOUR_GITHUB_ORG>/<YOUR_GITHUB_REPO>:*"
            },
            "StringEquals": {
              "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
            }
          }
        }
      ]
    }
    ```

    **Replace:**

    - `<YOUR_ACCOUNT_ID>`: Your 12-digit AWS account ID (e.g., `512083376328`).
    - `<YOUR_GITHUB_ORG>`: Your GitHub organization name (or your username if it's a personal repository).
    - `<YOUR_GITHUB_REPO>`: The name of the GitHub repository that will trigger the CI/CD.

    The `:*` in `repo:<YOUR_GITHUB_ORG>/<YOUR_GITHUB_REPO>:*` allows any branch within that repository to assume the role. You can make this more specific (e.g., `repo:<YOUR_GITHUB_ORG>/<YOUR_GITHUB_REPO>:ref:refs/heads/main`) if you only want a specific branch to deploy.

5.  Click **Next**.

### Step 3: Attach Permissions Policies

This is where you define what actions the CI/CD pipeline is allowed to perform in your AWS account.

1.  Search for and attach policies:

    - **Principle of Least Privilege is CRITICAL here.** Only attach the absolute minimum permissions required for your CI/CD pipeline to deploy your application.
    - **NEVER attach `AdministratorAccess` to a CI/CD role for production environments.** For development, you might start with `PowerUserAccess` or a custom policy and refine it.
    - **Better Practice**: Create a custom policy that grants only the specific actions your pipeline needs (e.g., `s3:PutObject`, `cloudformation:CreateStack`, `cloudformation:UpdateStack`, `lambda:UpdateFunctionCode`). Avoid using `*` for resources or actions unless absolutely necessary, as this grants overly broad permissions and increases security risk.

2.  Click **Next**.

### Step 4: Name and Create the Role

1.  **Role name**: Give your role a clear and descriptive name (e.g., `github-actions-deploy-role-project1-dev`).
2.  **Description**: Add a brief description of the role's purpose.
3.  Review the trust policy and permissions.
4.  Click **Create role**.

**Important**: Once the role is created, click on its name to view its details. Copy the **Role ARN** (e.g., `arn:aws:iam::<YOUR_ACCOUNT_ID>:role/github-actions-deploy-role-project1-dev`). You will need this in your GitHub Actions workflow configuration.

### Step 5: Configure Your GitHub Actions Workflow

Finally, you'll update your GitHub Actions workflow file to assume the newly created IAM Role.
