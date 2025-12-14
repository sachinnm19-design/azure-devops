# DevOps Take-Home Assignment – Azure, Terraform & GitHub Actions

## 1. Introduction

This repository demonstrates a complete, production-oriented DevOps workflow using:

- Terraform for Infrastructure as Code (IaC)
- Terraform Cloud for remote state management and environment isolation
- Azure for hosting a containerized application
- GitHub Actions for CI/CD automation
- Pull Request–based workflow with approvals and environment gates

The solution provisions Azure infrastructure, builds a containerized application, and deploys it safely across DEV and PROD environments.

---

## 2. High-Level Architecture

### Azure Resources Provisioned
- Resource Group
- Azure Container Registry (ACR)
- App Service Plan (Linux)
- Azure Web App for Containers

### CI/CD Flow
1. Developer creates a feature branch and raises a Pull Request
2. CI pipeline runs Terraform plan (DEV workspace) and Docker build validation
3. Pull Request is reviewed and approved
4. Merge to `main` triggers CD pipeline
5. DEV deployment happens automatically
6. PROD deployment requires manual approval

Terraform state and environment separation are handled using Terraform Cloud workspaces.

---
## 3. Repository Structure

```
.
├── app/
│ ├── app.py / index.js
│ ├── requirements.txt / package.json
│ └── Dockerfile
│
├── infra/
│ ├── main.tf # Azure resources
│ ├── provider.tf # Providers & backend configuration
│ ├── variables.tf # Input variables
│ └── outputs.tf # Output values
│
├── .github/
│ └── workflows/
│ ├── pr-validation.yml
│ └── cd-dev-prod.yml
│
└── README.md
```


---

## 4. Application Details

- Simple containerized application
- Exposes a health endpoint:
    ```
    GET /health
    Response: { "status": "ok" }

- Application listens on port **3000**
- Dockerized using a standard Dockerfile

---

## 5. Prerequisites

Before setting up this project, ensure you have:

- An active Azure subscription
- A GitHub account
- A Terraform Cloud account
- Basic knowledge of Git, Terraform, and Azure

---

## 6. Azure Setup

### 6.1 Create a Service Principal

Create a Service Principal with Contributor access:

az ad sp create-for-rbac
--name devops-demo-sp
--role Contributor
--scopes /subscriptions/<SUBSCRIPTION_ID>
--sdk-auth


Save the JSON output securely. It will be used in GitHub and Terraform Cloud.

---

## 7. Terraform Cloud Setup

### 7.1 Create Organization

- Sign in to https://app.terraform.io
- Create an organization (example: `AzureDevOpsDemo`)

---

### 7.2 Create Workspaces

Create two workspaces:

| Workspace Name |
|---------------|
| devops-demo-dev |
| devops-demo-prod |

Each workspace represents a separate environment.

---

### 7.3 Configure Workspace Variables

#### Terraform Variables (per workspace)

| Variable Name |
|--------------|
| location |
| resource_group_name |
| acr_name |
| app_service_plan |
| webapp_name |
| image_name |
| image_tag |

> These values can differ between DEV and PROD.

---

#### Environment Variables (per workspace)

| Variable Name |
|--------------|
| ARM_CLIENT_ID |
| ARM_CLIENT_SECRET |
| ARM_SUBSCRIPTION_ID |
| ARM_TENANT_ID |

> Mark all as **Sensitive** in Terraform Cloud.

---

## 8. GitHub Repository Setup

### 8.1 GitHub Secrets

Add the following repository secrets:

| Secret Name | Description |
|------------|-------------|
| AZURE_CREDENTIALS | Service Principal JSON from Azure |
| TF_API_TOKEN | Terraform Cloud API token |

---

### 8.2 GitHub Environments

Create two GitHub environments:

| Environment | Approval Required |
|------------|-------------------|
| dev | No |
| prod | Yes |

Production environment requires at least one reviewer approval.

---

## 9. CI/CD Pipelines

### 9.1 CI – Pull Request Validation

Triggered when a Pull Request is raised against the `main` branch.

Pipeline steps:
- Terraform init and plan using DEV workspace
- Docker image build validation
- No infrastructure changes applied

This ensures early validation and safe code review.

---

### 9.2 CD – Deployment Pipeline

Triggered on merge to the `main` branch.

#### DEV Deployment
- Terraform plan and apply
- Docker image build and push to ACR
- Azure Web App restart
- Health check

#### PROD Deployment
- Manual approval required
- Terraform plan and apply
- Docker image build and push
- Azure Web App restart
- Health check

---

## 10. Verification

After deployment, verify the application:

curl https://<webapp-name>.azurewebsites.net/health

Expected response:

{ "status": "ok" }


---

## 11. Design & Best Practices

- Infrastructure fully defined as code
- No secrets hardcoded
- Environment isolation using Terraform Cloud workspaces
- PR-based CI validation
- Approval-gated production deployments
- Single Terraform codebase reused across environments

---

## 12. Conclusion

This project demonstrates a real-world DevOps implementation using Terraform, Azure, and GitHub Actions, with a strong focus on automation, security, and governance.

---

## Author

Sachin Mohan  
DevOps Engineer  
