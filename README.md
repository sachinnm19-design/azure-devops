# 🚀 Azure DevOps Demo - Complete CI/CD Pipeline

A production-ready DevOps demonstration project showcasing Infrastructure as Code (IaC), CI/CD automation, security best practices, and application monitoring on Azure.

[![CI/CD Pipeline](https://github.com/sachinnm19-design/azure-devops/actions/workflows/deploy.yml/badge.svg)](https://github.com/sachinnm19-design/azure-devops/actions/workflows/deploy.yml)

## 📋 Table of Contents

- [Introduction](#introduction)
- [High-Level Architecture](#high-level-architecture)
- [Repository Structure](#repository-structure)
- [Application Details](#application-details)
- [Prerequisites](#prerequisites)
- [Azure Setup](#azure-setup)
- [Terraform Cloud Setup](#terraform-cloud-setup)
- [GitHub Repository Setup](#github-repository-setup)
- [Infrastructure](#infrastructure)
- [CI/CD Pipelines](#cicd-pipelines)
- [Security](#security)
- [Monitoring & Observability](#monitoring--observability)
- [Testing](#testing)
- [Best Practices](#best-practices)
- [Verification](#verification)
- [Future Enhancements](#future-enhancements)
- [Contributing](#contributing)
- [License](#license)

---

## Introduction

This repository demonstrates a complete, production-oriented DevOps workflow using:

- **Terraform** for Infrastructure as Code (IaC)
- **Terraform Cloud** for remote state management and environment isolation
- **Azure** for hosting a containerized application
- **GitHub Actions** for CI/CD automation with PR-based workflow
- **Azure Container Registry (ACR)** for secure container image storage
- **Application Insights & Log Analytics** for comprehensive monitoring
- **Role-Based Access Control (RBAC)** for secure resource access

The solution provisions Azure infrastructure, builds a containerized application, and deploys it safely across DEV and PROD environments with automated security scanning and validation.

### Key Technologies

- **Cloud Platform:** Microsoft Azure
- **IaC Tool:** Terraform (with Terraform Cloud state management)
- **Container Registry:** Azure Container Registry (ACR) - Public Access
- **Compute:** Azure App Service (Linux Containers)
- **Monitoring:** Application Insights + Log Analytics
- **CI/CD:** GitHub Actions
- **Application:** Python Flask with Gunicorn (Production-Ready)

---

## High-Level Architecture

For detailed visual representations of the architecture, see the diagrams in the `images/` folder:
- **Azure Cloud Architecture.jpg**: Azure infrastructure and resource relationships
- **CI CD Architecture.jpg**: Complete CI/CD pipeline flow

### Azure Resources Provisioned

- Resource Group
- Azure Container Registry (ACR)
- App Service Plan (Linux)
- Azure Web App for Containers
- Application Insights
- Log Analytics Workspace

### CI/CD Flow

1. Developer creates a feature branch and raises a Pull Request
2. CI pipeline runs Terraform plan (DEV workspace) and Docker build validation
3. Pull Request is reviewed and approved
4. Merge to `main` triggers CD pipeline
5. DEV deployment happens automatically
6. PROD deployment requires manual approval

Terraform state and environment separation are handled using **Terraform Cloud workspaces**.

---

## Repository Structure

.
├── app/
│   ├── app.py                      # Flask application with logging
│   ├── requirements.txt            # Python dependencies
│   └── Dockerfile                  # Multi-stage container build
│
├── infra/
│   ├── main.tf                     # Main infrastructure resources
│   ├── provider.tf                 # Azure provider configuration
│   ├── variables.tf                # Input variables
│   ├── outputs.tf                  # Output values
│   └── datasources.tf              # Data sources
│
│   ├── modules/
│   │   ├── acr/                    # Container Registry module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── app_service/            # App Service module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   └── networking/             # Networking module
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│
│   └── environments/
│       ├── dev.tfvars              # Dev environment variables
│       └── prod.tfvars             # Prod environment variables
│
├── images/
│   ├── Azure Cloud Architecture.jpg
│   └── CI CD Architecture.jpg
│
├── .github/
│   └── workflows/
│       ├── pr-validation.yml       # PR validation pipeline
│       └── deploy.yml              # Deployment pipeline
│
├── README.md                       # This file
└── .gitignore                      # Git ignore rules

---

## Application Details

### Overview
- Simple containerized application using **Flask** (Python)
- Production-ready with **Gunicorn** WSGI server
- Exposes a **health endpoint** for monitoring and load balancer checks

### Health Endpoint

GET /health
Response: { "status": "ok" }

### Technical Specifications

- **Language:** Python 3.10
- **Framework:** Flask
- **Server:** Gunicorn (production-grade WSGI server)
- **Port:** 3000
- **Base Image:** python:3.10-slim (minimal, security-focused)
- **Health Checks:** Docker health checks enabled
- **Logging:** Structured logging with JSON output to Application Insights

---

## Prerequisites

### Required Tools

Tool | Version | Purpose
Azure CLI | 2.40+ | Azure resource management
Terraform | 1.3+ | Infrastructure provisioning
Docker | 20.10+ | Container builds and testing
Git | 2.30+ | Version control
GitHub Account | - | Code hosting and CI/CD

### Azure Requirements

- Active Azure subscription
- Contributor or Owner role on subscription
- Resource quotas for App Service Plans, Container Registries, Application Insights, Log Analytics Workspaces

### Terraform Cloud Requirements

- Terraform Cloud account (free tier available at https://app.terraform.io)
- API token for CI/CD authentication
- Workspaces configured in Terraform Cloud

### GitHub Requirements

- GitHub account with admin access to create secrets and environments
- Repository created and cloned locally

---

## Azure Setup

### Create a Service Principal

Create a Service Principal with Contributor access for Terraform and GitHub Actions:

az ad sp create-for-rbac \
  --name devops-demo-sp \
  --role Contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID> \
  --sdk-auth

Save the JSON output securely. It will be used in both GitHub Secrets and Terraform Cloud Environment Variables.

Example output format:

{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "your-secret",
  "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

---

## Terraform Cloud Setup

### Step 1: Create an Organization

1. Sign in to https://app.terraform.io
2. Create an organization (example: AzureDevOpsDemo)
3. Create an API token in your user settings:
   - Navigate to User Settings → Tokens
   - Create a new token and save it securely

### Step 2: Create Workspaces

Create two workspaces for environment isolation:

Workspace Name | Purpose
devops-demo-dev | Development environment
devops-demo-prod | Production environment

Each workspace maintains its own state file and variable values.

### Step 3: Configure Terraform Variables

#### Terraform Variables (Per Workspace)

Variable Name | Type | Description
acr_name | string | Name for Azure Container Registry
app_service_plan_name | string | Name for App Service Plan
environment | string | Environment name (dev/prod)
image_name | string | Docker image name
image_tag | string | Docker image tag
location | string | Azure region (e.g., eastus)
resource_group_name | string | Azure Resource Group name
sku_name | string | App Service Plan SKU (B1 for dev, P1V2 for prod)
webapp_name | string | Azure Web App name

#### Environment Variables (Sensitive - Mark as Sensitive)

Variable Name | Source | Description
ARM_CLIENT_ID | Service Principal | Azure Client ID
ARM_CLIENT_SECRET | Service Principal | Azure Client Secret
ARM_SUBSCRIPTION_ID | Service Principal | Azure Subscription ID
ARM_TENANT_ID | Service Principal | Azure Tenant ID

Important: Mark all ARM_* variables as Sensitive in Terraform Cloud to prevent them from being displayed in logs.

---

## GitHub Repository Setup

### Step 1: Configure GitHub Secrets

Add the following secrets to your repository (Settings → Secrets and variables → Actions):

Secret Name | Value | Description
AZURE_CREDENTIALS | Service Principal JSON | For Azure CLI authentication in workflows
TF_API_TOKEN | Terraform Cloud API Token | For Terraform Cloud authentication

Azure Credentials Format:

{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "your-secret",
  "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

### Step 2: Create GitHub Environments

Create two environments for deployment gates:

Environment | Requires Approval | Branch Protection
dev | No | main
prod | Yes | main

To create environments:
1. Go to Settings → Environments
2. Click New environment
3. For prod: Enable Required reviewers under Deployment branches

---

## Infrastructure

### Core Resources Provisioned

Resource | Purpose | Configuration
Resource Group | Logical container for all resources | Per environment
Azure Container Registry | Container image storage and management | Public access for GitHub Actions
App Service Plan | Compute capacity for Web App | B1 (dev), P1V2 (prod)
Web App for Containers | Containerized application hosting | Linux, with Managed Identity
Application Insights | Application monitoring and diagnostics | Web application type
Log Analytics Workspace | Centralized logging and analytics | PerGB2018 pricing, 30-day retention

### Managed Identity

The Web App uses System-Assigned Managed Identity for:
- Pulling images from ACR (AcrPull role)
- Secure, credential-free authentication
- Role-Based Access Control to Azure resources

### Infrastructure Modules

#### ACR Module (modules/acr)

- Container Registry provisioning with configurable SKU
- Public access enabled for GitHub Actions CI/CD to pull images
- Managed Identity integration for Web App

Note on ACR Access: ACR is configured with public access to allow GitHub Actions CI/CD pipeline to pull container images. To make ACR private while maintaining CI/CD functionality:
- Implement private endpoints in your VNet
- Use Managed Identity with proper RBAC roles
- Restrict ACR access via network rules
- Use a self-hosted GitHub Actions runner in the VNet

#### App Service Module (modules/app_service)

- App Service Plan creation with environment-specific SKUs
- Web App configuration with Managed Identity
- Container settings and image pull configuration
- Application Insights integration
- IP restrictions (for production security)
- Health check configuration
- Docker health checks

#### Networking Module (modules/networking)

- Network Security Groups (NSG) creation
- Security rules for traffic control
- Optional NSG creation per environment

### Terraform Configuration Examples

Update infra/provider.tf:

terraform {
  cloud {
    organization = "your-organization"
    
    workspaces {
      name = "devops-demo-dev"
    }
  }
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

Terraform Commands:

cd infra

terraform init

terraform validate

terraform plan

terraform apply

terraform destroy

---

## CI/CD Pipelines

### Pipeline Overview

The CI/CD system uses two separate workflows:

1. PR Validation Pipeline (pr-validation.yml) - Runs on Pull Requests
2. Deployment Pipeline (deploy.yml) - Runs on merges to main

### CI – PR Validation Pipeline

Runs automatically on Pull Requests targeting the main branch.

Pipeline Steps:

1. Terraform Plan for DEV
   - Initializes Terraform with DEV workspace
   - Validates infrastructure configuration
   - Generates plan output for review

2. Docker Build Validation
   - Builds Docker image to ensure no build errors
   - Validates Dockerfile syntax and dependencies
   - Runs container security scans with Trivy

3. Terraform Security Scan
   - Runs Checkov for IaC security validation
   - Checks for misconfigurations and best practice violations

### CD – Deployment Pipeline

Triggered automatically on merges to the main branch.

DEV Deployment Steps:

1. Checkout Code
2. Setup Azure CLI
3. Terraform Plan (DEV)
4. Terraform Apply (DEV)
5. Build Docker Image
6. Push to ACR
7. Deploy to DEV Web App

PROD Deployment Steps:

1. Wait for Approval
2. Terraform Plan (PROD)
3. Terraform Apply (PROD)
4. Build Docker Image
5. Push to ACR
6. Deploy to PROD Web App

### Workflow Files

Located in .github/workflows/

Key Workflow Features:

- Environment-specific secrets and variables
- Conditional steps based on branch and environment
- Approval gates for production deployments
- Terraform state management via Terraform Cloud
- Security scanning at every step
- Detailed logging and artifact retention

---

## Security

### Network Security

#### IP Restrictions

Web App is protected by IP whitelist:

ip_restrictions = [
  {
    ip_address = "YOUR.IP.ADDRESS.HERE"
  }
]

ip_restriction_default_action = "Deny"

#### SCM (Deployment) Protection

Deployment endpoints are also protected:

scm_ip_restriction_default_action = "Deny"

#### TLS/SSL Configuration

https_only          = true
minimum_tls_version = "1.2"
ftps_state          = "Disabled"

### Container Security

#### Vulnerability Scanning

Automated scanning with Trivy:

trivy image \
  --severity HIGH,CRITICAL \
  --exit-code 1 \
  myimage:tag

#### Base Image Best Practices

FROM python:3.10-slim

### Infrastructure Security

#### Terraform Security Scanning

Automated with Checkov:

checkov -d infra/ \
  --quiet \
  --compact \
  --skip-check CKV_AZURE_*

#### Secrets Management

- No secrets stored in code or configuration files
- Managed Identity for Azure resource access
- GitHub Secrets for CI/CD credentials (only 2: AZURE_CREDENTIALS, TF_API_TOKEN)
- Terraform Cloud workspace variables for sensitive configuration
- All sensitive variables marked as Sensitive in Terraform Cloud

### Access Control

Access to Azure resources uses Role-Based Access Control (RBAC):

Resource | Principal | Role
ACR | Web App Managed Identity | AcrPull
Azure Resources | Service Principal (GitHub Actions) | Contributor
Terraform Cloud | GitHub Actions | API Token Authentication

### Security Checklist

[x] HTTPS enforced
[x] TLS 1.2+ required
[x] IP restrictions enabled
[x] Default deny on unmatched traffic
[x] FTP disabled
[x] Managed Identity enabled
[x] Container scanning enabled
[x] IaC security scanning enabled
[x] Minimal base images
[x] No sensitive data in code
[x] RBAC-based access control
[x] Workspace-level environment isolation

---

## Monitoring & Observability

### Application Insights

Application Insights is automatically configured and provides:
- Request tracking and exception logging
- Dependency tracking (external calls)
- Live metrics stream
- Structured application logging
- Performance counters

Access Application Insights:

az monitor app-insights component show \
  --app devops-demo-webapp-dev-insights \
  --resource-group devops-demo-rg-dev

### Log Analytics Workspace

Centralized logging with:
- 30-day retention
- Advanced query capabilities (KQL)
- Cross-resource queries
- Alert rules for proactive monitoring

### Log Analytics Queries

#### View Application Logs

traces
| where timestamp > ago(1h)
| project timestamp, message, severityLevel
| order by timestamp desc

#### Health Check Monitoring

requests
| where name == "GET /health"
| summarize 
    SuccessRate = avg(success)*100, 
    Count = count()
  by bin(timestamp, 5m)
| render timechart

#### Error Analysis

requests
| where success == false
| summarize ErrorCount = count() by bin(timestamp, 1h), resultCode
| render barchart

#### Exception Analysis

exceptions
| where timestamp > ago(24h)
| summarize Count = count() by type, outerMessage
| order by Count desc

### Application Endpoints

Endpoint | Method | Description | Response
/health | GET | Health check with application status | {"status": "ok"}

Testing Endpoint:

curl https://devops-demo-webapp-dev.azurewebsites.net/health
curl https://devops-demo-webapp-prod.azurewebsites.net/health

### Viewing Logs

#### Real-time Log Streaming

az webapp log tail \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev

#### Query Logs via CLI

az monitor app-insights query \
  --app devops-demo-webapp-dev-insights \
  --resource-group devops-demo-rg-dev \
  --analytics-query "traces | where timestamp > ago(1h) | limit 100"

---

## Testing

### Local Testing

#### Test Docker Build

cd app

docker build -t demo-app:test .

docker run -p 3000:3000 demo-app:test

curl http://localhost:3000/health

### Infrastructure Testing

cd infra

terraform init

terraform validate

terraform fmt -check

checkov -d . --quiet

### Integration Testing

After deployment:

WEBAPP_URL=$(az webapp show \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev \
  --query defaultHostName -o tsv)

curl -f https://$WEBAPP_URL/health || echo "Health check failed"

curl -v https://$WEBAPP_URL/health

---

## Best Practices

### Infrastructure as Code

- Use modules for reusability and maintainability
- Version control all infrastructure code
- Use Terraform Cloud for state management and collaboration
- Separate environments using workspaces (dev/prod)
- Use workspace variables for environment-specific values
- Document all resources with comments
- Use consistent naming conventions
- Implement tag-based organization

### Security

- Use Managed Identities over static credentials
- Minimize stored secrets (only 2 GitHub secrets)
- Enable vulnerability scanning in CI/CD
- Use minimal base images (slim, alpine)
- Implement network restrictions
- Enable HTTPS-only traffic
- Use TLS 1.2 or higher
- Regularly update dependencies
- Implement RBAC for all resource access
- Secure sensitive variables in Terraform Cloud

### CI/CD

- Automate all deployments through CI/CD
- Use separate workspaces per environment
- Run security scans in every pipeline
- Test infrastructure changes in dev first
- Use semantic versioning for images
- Enable approval gates for production
- Implement rollback capabilities
- Monitor pipeline execution and failures

### Monitoring

- Enable Application Insights from day one
- Use structured logging for better querying
- Monitor error rates and exceptions
- Review logs regularly for anomalies
- Configure log retention policies
- Set up alerts for critical metrics
- Track deployment frequency and success rates

### Cost Optimization

- Use appropriate SKUs (B1 for dev, P1V2 for prod)
- Clean up unused resources regularly
- Monitor spend with Azure Cost Management
- Use free tier of Terraform Cloud
- Implement auto-shutdown for dev resources
- Review reserved instances for prod workloads

---

## Verification

### DEV Environment

DEV_URL=$(az webapp show \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev \
  --query defaultHostName -o tsv)

curl https://$DEV_URL/health

### PROD Environment

PROD_URL=$(az webapp show \
  --name devops-demo-webapp-prod \
  --resource-group devops-demo-rg-prod \
  --query defaultHostName -o tsv)

curl https://$PROD_URL/health

### Expected Response

Both endpoints should return:

{ "status": "ok" }

### Additional Verification Steps

1. Check Deployment Status:

az webapp deployment show --resource-group devops-demo-rg-dev --name devops-demo-webapp-dev

2. View Application Insights
   - Navigate to Azure Portal → Application Insights → devops-demo-webapp-dev-insights
   - Check Live Metrics, Failures, Performance

3. Review Logs:

az webapp log tail --resource-group devops-demo-rg-dev --name devops-demo-webapp-dev

4. Verify Terraform State
   - Check Terraform Cloud workspace for successful apply
   - Review outputs for resource details

---

## Future Enhancements

### Phase 1: Enhanced Infrastructure

[ ] Implement Virtual Network with private endpoints
[ ] Make ACR private with private endpoints
[ ] Enable ACR geo-replication for multi-region
[ ] Use Premium App Service Plan with auto-scaling
[ ] Add Azure Firewall for advanced security
[ ] Implement Azure Bastion for secure access

### Phase 2: Advanced Application Features

[ ] Implement readiness/liveness probes
[ ] Add distributed tracing (OpenTelemetry)
[ ] Implement API rate limiting
[ ] Add Redis cache for performance
[ ] Add authentication/authorization (Azure AD)
[ ] Implement database layer with Azure SQL

### Phase 3: DevOps Maturity

[ ] Implement blue-green deployments
[ ] Add canary deployment strategy
[ ] Implement feature flags
[ ] Add automated rollback on failure
[ ] Implement GitOps with Flux/ArgoCD
[ ] Add cost monitoring and optimization

### Phase 4: Compliance & Governance

[ ] Implement Azure Policy for compliance
[ ] Add compliance scanning (CIS benchmarks)
[ ] Implement comprehensive audit logging
[ ] Add regulatory compliance checks (SOC 2, ISO 27001)
[ ] Implement backup and disaster recovery
[ ] Add SIEM integration for security monitoring

---

## Contributing

### 1. Fork the Repository

git clone https://github.com/YOUR-USERNAME/azure-devops.git
cd azure-devops

### 2. Create a Feature Branch

git checkout -b feature/your-feature-name

### 3. Test Your Changes

cd infra
terraform init
terraform validate
terraform plan

cd app
docker build -t demo-app:test .
docker run -p 3000:3000 demo-app:test

### 4. Commit and Push

git add .
git commit -m "feat: add new feature"
git push origin feature/your-feature-name

### 5. Create a Pull Request

- Describe your changes clearly
- Link related issues
- Request review from maintainers

---

## License

This project is for demonstration and educational purposes.

---

Last Updated: 2026-02-18
Version: 2.0.0
