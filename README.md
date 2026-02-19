# 🚀 Azure DevOps Demo - Complete CI/CD Pipeline

A production-ready DevOps demonstration project showcasing Infrastructure as Code (IaC), CI/CD automation, security best practices, and comprehensive monitoring on Azure.

[![CI/CD Pipeline](https://github.com/sachinnm19-design/azure-devops/actions/workflows/deploy.yml/badge.svg)](https://github.com/sachinnm19-design/azure-devops/actions/workflows/deploy.yml)

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Features](#-features)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Infrastructure](#-infrastructure)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Security](#-security)
- [Monitoring & Observability](#-monitoring--observability)
- [Testing](#-testing)
- [Troubleshooting](#-troubleshooting)
- [Best Practices](#-best-practices)
- [Acknowledgments](#-acknowledgments)
- [Additional Resources](#-additional-resources)
- [Project Status](#-project-status)

---

## 🎯 Overview

This project demonstrates a complete DevOps workflow with:

- **Infrastructure as Code** using Terraform
- **Containerized Application** with Docker
- **Multi-Environment Deployment** (Dev/Prod)
- **Automated CI/CD** with GitHub Actions
- **Security Scanning** and vulnerability detection
- **Monitoring & Alerting** with Application Insights
- **Network Security** with IP restrictions and TLS enforcement

### **Key Technologies**

- **Cloud Platform:** Microsoft Azure
- **IaC Tool:** Terraform
- **Container Registry:** Azure Container Registry (ACR)
- **Compute:** Azure App Service (Linux Containers)
- **Monitoring:** Application Insights + Log Analytics
- **Security:** Managed Identities
- **CI/CD:** GitHub Actions
- **Application:** Python Flask (containerized)
  
---

## 🏗️ Architecture

### **High-Level Architecture**
```
┌─────────────────────────────────────────────────────────────────┐
│                         GitHub Repository                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐   │
│  │ Application  │  │     IaC      │  │   GitHub Actions     │   │
│  │  Code (Flask)│  │  (Terraform) │  │   (CI/CD Pipeline)   │   │
│  └──────────────┘  └──────────────┘  └──────────────────────┘   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                    Triggers on Push / Pull Request
                             │
                             ▼
┌───────────────────────────────────────────────────────────────┐
│                    GitHub Actions Workflow                    │
│                                                               │
│  ┌───────────┐  ┌──────────────┐  ┌────────────┐  ┌─────────┐ │
│  │   Build   │→ │ Security     │→ │ Terraform  │→ │ Deploy  │ │
│  │  & Test   │  │ Scan (Trivy) │  │   Apply    │  │  App    │ │
│  └───────────┘  └──────────────┘  └────────────┘  └─────────┘ │
│                                                               │
└────────────────────────────┬──────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                         Azure Platform                          │
│                                                                 │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │                     Resource Group                        │  │
│  │                                                           │  │
│  │  ┌────────────────────┐     ┌────────────────────────┐    │  │
│  │  │ Azure Container    │     │   App Service Plan     │    │  │
│  │  │ Registry (ACR)     │     │     (Linux)            │    │  │
│  │  │  - Docker Images   │     │  ┌──────────────────┐  │    │  │
│  │  │  - Flask App       │     │  │ Azure Web App    │  │    |  │
│  │  └────────────────────┘     │  │ (Containerized)  │  │    │  │
│  │                             │  │   Gunicorn       │  │    │  │
│  │                             │  └──────────────────┘  │    │  │
│  │                             └────────────────────────┘    │  │
│  │  ┌──────────────────────────────────────────────────┐     │  │
│  │  │              Application Insights                │     │  │
│  │  │  - Request Tracking                              │     │  │
│  │  │  - Exception Logging                             │     │  │
│  │  │  - Performance Metrics                           │     │  │
│  │  └──────────────────────────────────────────────────┘     │  │
│  │                                                           │  │
│  │  ┌────────────────────┐      ┌──────────────────────┐     │  │
│  │  │ Health Endpoint    │      │ Networking / Security│     │  │
│  │  │  /health           │      │ - IP Restrictions    │     │  │
│  │  │  Monitoring        │      │ - HTTPS Only         │     │  │
│  │  └────────────────────┘      └──────────────────────┘     │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘

```
---
### **Network Security**

```
┌─────────────────────────────────────────────────────────────────┐
│                         Internet                                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                   ┌─────────▼──────────┐
                   │   HTTPS (TLS 1.2)  │
                   └─────────┬──────────┘
                             │
                   ┌─────────▼──────────┐
                   │  IP Restrictions   │
                   │  (Whitelist Only)  │
                   └─────────┬──────────┘
                             │
                   ┌─────────▼──────────┐
                   │    Azure Web App   │
                   │   (Flask in Docker)│
                   └─────────┬──────────┘
                             │
                   ┌─────────▼──────────┐
                   │ (Managed Identity) │
                   │        ACR         │
                   └────────────────────┘
```

---

## ✨ Features

### **Infrastructure & Platform**

- ✅ **Multi-environment support** (dev, prod)
- ✅ **Modular Terraform code** for reusability
- ✅ **Azure Container Registry** for image storage
- ✅ **App Service with Linux containers**
- ✅ **Network Security Groups** for traffic control

### **Security**

- ✅ **Managed Identity** for Azure resource access
- ✅ **Azure Key Vault** for secrets management(optional)
- ✅ **IP-based access restrictions** with default deny
- ✅ **TLS 1.2+** enforcement
- ✅ **HTTPS-only** traffic
- ✅ **Container vulnerability scanning** with Trivy
- ✅ **Terraform security scanning** with Checkov(optonal)

### **CI/CD Pipeline**

- ✅ **Automated builds** on every commit
- ✅ **Multi-stage deployment** (build → test → deploy)
- ✅ **Environment-specific configurations**
- ✅ **Automated security scanning**
- ✅ **Terraform state management** in Terraform Cloud
- ✅ **Pull request validation**
- ✅ **Production approval gates**

### **Observability & Monitoring**

- ✅ **Application Insights** integration
- ✅ **Log Analytics Workspace** for centralized logging
- ✅ **Structured application logging**
- ✅ **Health check endpoint** with auto-healing
- ✅ **Real-time log streaming**
- ✅ **Request/response logging**

### **Application**

- ✅ **Containerized Python Flask** application
- ✅ **Production-ready** with Gunicorn
- ✅ **Health check endpoint** (`/health`)
- ✅ **Docker health checks**
- ✅ **Comprehensive error handling**

---

## 📁 Project Structure

```
.
├── .github/
│   └── workflows/
│       ├── pr-validation.yml          # CI – Pull Request validation pipeline
│       └── deploy.yml                 # CD – Multi-stage deployment pipeline (DEV → PROD)
│
├── app/
│   ├── app.py                         # Flask application with health endpoint
│   ├── requirements.txt               # Python dependencies
│   └── Dockerfile                     # Container build definition
│
├── infra/
│   ├── main.tf                        # Root infrastructure composition
│   ├── provider.tf                    # Terraform + Azure provider config
│   ├── variables.tf                   # Global input variables
│   ├── outputs.tf                     # Terraform outputs (ACR, WebApp, etc.)
│   ├── datasources.tf                 # Azure data sources
│   │
│   ├── modules/
│   │   ├── acr/                       # Azure Container Registry module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── app_service/               # App Service + Plan module
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   └── networking/                # Optional networking (NSG / IP rules)
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│
├── images/                            # Architecture diagrams (optional)
│   ├── Azure-Architecture.jpg
│   └── CICD-Flow.jpg
│
├── README.md                          # Project documentation

```

---

## Prerequisites

Before setting up this project, ensure you have:

- An active Azure subscription
- A GitHub account
- A Terraform Cloud account
- Basic knowledge of Git, Terraform, and Azure

---

### Azure Setup

#### Create a Service Principal

Create a Service Principal with Contributor access:

```bash
az ad sp create-for-rbac \
  --name devops-demo-sp \
  --role Contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID> \
  --sdk-auth
```

Save the JSON output securely. It will be used in GitHub and Terraform Cloud.

### Terraform Cloud Setup

#### Create an Organization
- Sign in to [Terraform Cloud](https://app.terraform.io)
- Create an organization (example: `AzureDevOpsDemo`)

#### Create Workspaces
Create two workspaces:

| Workspace Name       |
|----------------------|
| devops-demo-dev      |
| devops-demo-prod     |

Each workspace represents a separate environment.

#### Configure Variables

##### Terraform Variables
| Key                           | Dev Example              | Prod Example             | Type   |
|-------------------------------|--------------------------|--------------------------|--------|
| acr_name                      | acrdemodev               | acrdemoprod              | string |
| app_service_plan_name         | asp-demo-dev             | asp-demo-prod            | string |
| environment                   | dev                      | prod                     | string |
| image_name                    | demo-app                 | demo-app                 | string |
| image_tag                     | latest                   | v1.0.0                   | string |
| location                      | eastus                   | eastus                   | string |
| resource_group_name           | rg-devops-demo-dev       | rg-devops-demo-prod      | string |
| sku_name                      | B1                       | P1V2                     | string |
| sp_object_id                  | <SP_OBJECT_ID>           | <SP_OBJECT_ID>           | string |
| webapp_name                   | devops-demo-webapp-dev   | devops-demo-webapp-prod  | string |
| key_vault_name                | kvdemodev2024            | kvdemoprod2024           | string |
| key_vault_sku                 | "standard"               | "premium"                | string |
| soft_delete_retention_days    | 90                       | 90                       | number |
| enable_purge_protection       | true                     | true                     | bool   |

##### Environment Variables
| Key                  |
|----------------------|
| ARM_CLIENT_ID        | 
| ARM_CLIENT_SECRET    | 
| ARM_SUBSCRIPTION_ID  | 
| ARM_TENANT_ID        |

Mark all sensitive environment variables appropriately in Terraform Cloud.
---

### GitHub Repository Setup

#### GitHub Secrets
Add the following secrets to your repository:

| Secret Name         | Description                             |
|---------------------|-----------------------------------------|
| AZURE_CREDENTIALS   | Service Principal JSON from Azure       |
| TF_API_TOKEN        | Terraform Cloud API token               |

---

#### GitHub Environments
Create two environments in GitHub:
| Environment | Requires Approval |
|-------------|--------------------|
| dev         | No                |
| prod        | Yes               |

---

## 🏗️ Infrastructure

### **Core Resources**

| Resource | Purpose | Configuration |
|----------|---------|---------------|
| Resource Group | Logical container | Per environment |
| App Service Plan | Compute capacity | B1 (dev), P1V2 (prod) |
| Web App | Application hosting | Linux container |
| Container Registry | Image storage | Premium SKU |
| Key Vault | Secrets management | Standard SKU (dev), Premium SKU (prod) |
| Application Insights | Monitoring | Web application type |
| Log Analytics | Centralized logging | PerGB2018 pricing |
| Network Security Group | Network security | Port 443 allowed |

### **Managed Identity**

The Web App uses **System-Assigned Managed Identity** for:
- ✅ Pulling images from ACR (AcrPull role)
- ✅ Accessing Key Vault secrets optional (Get, List permissions)
- ✅ Secure, credential-free authentication

### **Infrastructure Modules**

#### **ACR Module** (`modules/acr`)
- Container Registry provisioning
- SKU selection (Basic/Standard/Premium)
- Public/private access control

#### **App Service Module** (`modules/app_service`)
- App Service Plan creation
- Web App configuration
- Container settings
- Application Insights integration
- IP restrictions
- Health check configuration
- Logging configuration

#### **Key Vault Module** (`modules/key_vault`) ✨ NEW
- Azure Key Vault provisioning
- SKU selection (Standard/Premium)
- Automatic secrets creation for Application Insights:
  - `AppInsightsInstrumentationKey`
  - `AppInsightsConnectionString`
- Soft delete and purge protection
- Access policies for Web App Managed Identity (Read-only: Get, List)
- Access policies for Terraform Service Principal (Full management)

### **Terraform Commands**

```bash
cd infra

# Initialize
terraform init

# Validate
terraform validate

# Plan
terraform plan

# Apply
terraform apply

# Destroy
terraform destroy
```

---

## 🔄 CI/CD Pipeline

### **Workflow Stages**

```
┌─────────────┐
│   Trigger   │ Push to main or PR
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Checkout  │ Clone repository
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Build    │ Build Docker image
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   Security  │ Trivy + Checkov scans
│   Scanning  │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  Terraform  │ Init → Plan → Apply
│   Deploy    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Push Image  │ Push to ACR
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ Deploy App  │ Restart Web App
└─────────────┘
```

### **Pipeline Features**

- ✅ **Automated deployment on push** to `main`
- ✅ **Pull Request validation** (build + security + Terraform checks, no deployment)
- ✅ **Container security scanning** using Trivy
- ✅ **Remote Terraform state management** using Terraform Cloud
- ✅ **Environment separation** via Terraform Cloud workspaces (`dev` / `prod`)
- ✅ **Automatic DEV deployment**
- ✅ **Manual approval for PROD deployment**
- ✅ **Health endpoint verification after deployment**

### **Workflow Files**

Located at `.github/workflows/pr-validation.yml` & `.github/workflows/deploy.yml`

Key steps:
1. **Checkout code**
2. **Setup Azure CLI**
3. **Build Docker image**
4. **Security scanning**
5. **Terraform init/plan/apply**
6. **Push image to ACR**
7. **Restart Web App**

---

## 🔒 Security

### **Network Security**

#### **IP Restrictions**

Web App is protected by IP whitelist:

```hcl
ip_restrictions = [
  {
    ip_address = "2.223.114.28"
  }
]

ip_restriction_default_action = "Deny"  # Block all other IPs
```

#### **TLS/SSL Configuration**

```hcl
https_only          = true
minimum_tls_version = "1.2"  # Can be upgraded to 1.3
```

### **Container Security**

#### **Vulnerability Scanning**

Automated scanning with Trivy:

```bash
trivy image \
  --severity HIGH,CRITICAL \
  --exit-code 1 \
  myimage:tag
```

#### **Base Image Best Practices**

```dockerfile
# Use official, minimal base images
FROM python:3.10-slim

# Run as non-root user (optional)
# RUN useradd -m appuser
# USER appuser
```


#### **Secrets Management**


##### **Application Insights Secrets in Azure Key Vault**

All Application Insights credentials are securely stored in **Azure Key Vault** instead of environment variables:

###### **Secrets Stored**

| Secret Name | Description | Retrieved By |
|------------|-------------|--------------|
| `AppInsightsInstrumentationKey` | Application Insights instrumentation key for telemetry | Web App (via Managed Identity) |
| `AppInsightsConnectionString` | Application Insights connection string for diagnostics | Web App (via Managed Identity) |

###### **How Application Insights Secrets are Used**

1. **During Infrastructure Deployment (Terraform):**
   - Terraform creates the Key Vault
   - Terraform automatically stores Application Insights credentials in Key Vault
   - Terraform grants Web App Managed Identity read-only access

2. **At Runtime (Web App):**
   - Web App app settings reference Key Vault secrets using Azure Key Vault references:
     ```
     APPLICATIONINSIGHTS_CONNECTION_STRING = @Microsoft.KeyVault(SecretUri=https://<vault-name>.vault.azure.net/secrets/AppInsightsConnectionString/)
     APPINSIGHTS_INSTRUMENTATIONKEY = @Microsoft.KeyVault(SecretUri=https://<vault-name>.vault.azure.net/secrets/AppInsightsInstrumentationKey/)
     ```
   - Azure automatically resolves these references using Web App's Managed Identity
   - No credentials are exposed in app settings or logs

- ✅ All secrets in Azure Key Vault
- ✅ No secrets in code or environment files
- ✅ Managed Identity for authentication
- ✅ GitHub Secrets for CI/CD credentials

### **Access Control**

| Resource | Access Method | Permissions |
|----------|---------------|-------------|
| ACR | Managed Identity | AcrPull |
| Key Vault | Managed Identity | Get, List secrets |
| Azure Resources | Service Principal | Contributor |
| GitHub Actions | Secrets | Read-only |

### **Security Checklist**

- [x] HTTPS enforced
- [x] TLS 1.2+ required
- [x] IP restrictions enabled
- [x] Default deny on unmatched traffic
- [x] Managed Identity enabled
- [x] Secrets in Key Vault
- [x] Container scanning enabled
- [x] IaC security scanning enabled
- [x] Minimal base images
- [x] No admin credentials stored

---

## 📊 Monitoring & Observability

### **Application Insights**

Application Insights is automatically configured and provides:
- ✅ Request tracking and performance metrics
- ✅ Exception tracking and error logging
- ✅ Dependency tracking (external calls)
- ✅ Custom metrics and events
- ✅ Live metrics stream
- ✅ Distributed tracing

**Access Application Insights:**

```bash
# Via Azure Portal
az monitor app-insights component show \
  --app devops-demo-webapp-dev-insights \
  --resource-group rg-devops-demo-dev

# View live metrics
# Navigate to: Azure Portal → Application Insights → Live Metrics
```

### **Log Analytics Workspace**

Centralized logging with:
- 30-day retention
- Advanced query capabilities (KQL)
- Cross-resource queries
- Alert integration

### **Log Analytics Queries**

#### **View Application Logs**

```kusto
traces
| where timestamp > ago(1h)
| project timestamp, message, severityLevel
| order by timestamp desc
```

#### **Health Check Monitoring**

```kusto
requests
| where name == "GET /health"
| summarize 
    SuccessRate = avg(toint(success)) * 100,
    Count = count(),
    AvgDuration = avg(duration)
  by bin(timestamp, 5m)
| render timechart
```

### **Monitoring Alerts**

**View Alerts:**

```bash
az monitor metrics alert list \
  --resource-group rg-devops-demo-dev
```

### **Viewing Logs**

#### **Real-time Log Streaming**

```bash
# Stream application logs
az webapp log tail \
  --name devops-demo-webapp-dev \
  --resource-group rg-devops-demo-dev

# Stream with filter
az webapp log tail \
  --name devops-demo-webapp-dev \
  --resource-group rg-devops-demo-dev \
  --filter Error
```

#### **Download Logs**

```bash
# Download all logs
az webapp log download \
  --name devops-demo-webapp-dev \
  --resource-group rg-devops-demo-dev \
  --log-file logs.zip
```

### **Application Endpoint**

| Endpoint | Method | Description | Response |
|----------|--------|-------------|----------|
| `/health` | GET | Health check | Detailed health status |


### **Testing Endpoints**

```bash
# Health check from whitlisted IP
curl https://devops-demo-webapp-dev.azurewebsites.net/health

# Application info
curl https://devops-demo-webapp-dev.azurewebsites.net/info

# Test from non-whitelisted IP
curl https://devops-demo-webapp-dev.azurewebsites.net/health
Response should be below:
  Error 403 - Forbidden -> The web app you have attempted to reach has blocked your access

```

---

## 🧪 Testing

### **Local Testing**

#### **Test Docker Build**

```bash
cd app

# Build image
docker build -t demo-app:test .

# Run container
docker run -p 3000:3000 demo-app:test

# Test endpoints
curl http://localhost:3000/health
```

### **Infrastructure Testing**

```bash
cd infra

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Run plan
terraform plan
```

### **Integration Testing**

After deployment:

```bash
# Get Web App URL
WEBAPP_URL=$(az webapp show \
  --name devops-demo-webapp-dev \
  --resource-group rg-devops-demo-dev \
  --query defaultHostName -o tsv)

# Test health endpoint
curl -f https://$WEBAPP_URL/health || echo "Health check failed"

# Test from unauthorized IP (should fail with 403)
curl -v https://$WEBAPP_URL/health  # From non-whitelisted IP
```


## 🔧 Troubleshooting

### **Common Issues**

#### **Issue: Web App not accessible (403 Forbidden)**

**Cause:** Your IP is not in the whitelist.

**Solution:**

```bash
# Get your current public IP

# Update infra/main.tf
ip_restrictions = [
  {
    ip_address = "YOUR.NEW.IP.ADDRESS"
  }
]

# Redeploy
terraform apply
```

#### **Issue: Container fails to start**

**Cause:** Image pull error or application crash.

**Solution:**

```bash
# Check container logs
az webapp log tail \
  --name devops-demo-webapp-dev \
  --resource-group rg-devops-demo-dev


# Verify managed identity has AcrPull role
az role assignment list \
  --assignee <webapp-principal-id> \
  --scope <acr-id>

# Restart web app
az webapp restart \
  --name devops-demo-webapp-dev \
  --resource-group rg-devops-demo-dev
```

#### **Issue: No logs in Application Insights**

**Cause:** Instrumentation key not configured or sampling disabled.

**Solution:**

```bash
# Verify instrumentation key
az webapp config appsettings list \
  --name devops-demo-webapp-dev \
  --resource-group rg-devops-demo-dev \
  --query "[?name=='APPINSIGHTS_INSTRUMENTATIONKEY']"
```

#### **Issue: Health check failing**

**Cause:** Application not responding on `/health`.

**Solution:**

```bash
# Check application logs
az webapp log tail \
  --name devops-demo-webapp-dev \
  --resource-group rg-devops-demo-dev

# Verify health endpoint
curl https://devops-demo-webapp-dev.azurewebsites.net/health

# Check container status
az webapp show \
  --name devops-demo-webapp-dev \
  --resource-group rg-devops-demo-dev \
  --query state

```

#### **Issue: CI/CD pipeline failing**

**Cause:** Missing secrets or permissions.

**Solution:**

```bash
# Verify GitHub secrets are set
# Settings → Secrets and variables → Actions

# Check service principal has Contributor role
az role assignment list --assignee <service-principal-id>

# Test service principal login
az login --service-principal \
  -u $ARM_CLIENT_ID \
  -p $ARM_CLIENT_SECRET \
  --tenant $ARM_TENANT_ID

# Check workflow logs in GitHub Actions tab
```

#### **Issue: High response times**

**Cause:** Insufficient resources or inefficient code.

**Solution:**

```bash
# Check Application Insights performance tab
# Azure Portal → Application Insights → Performance

# Scale up App Service Plan
az appservice plan update \
  --name devops-demo-asp-dev \
  --resource-group rg-devops-demo-dev \
  --sku P1V2

# Scale out (add instances)
az appservice plan update \
  --name devops-demo-asp-dev \
  --resource-group rg-devops-demo-dev \
  --number-of-workers 2

# Review dependency calls in Application Insights
```

---

## 💡 Best Practices

### **Infrastructure as Code**

- ✅ Use modules for reusability
- ✅ Version control all infrastructure code
- ✅ Use remote state with locking
- ✅ Separate environments (dev/staging/prod)
- ✅ Use variables for configuration
- ✅ Document all resources with comments
- ✅ Use consistent naming conventions
- ✅ Tag all resources for cost management

### **Security**

- ✅ Use Managed Identities over credentials
- ✅ Store secrets in Key Vault only
- ✅ Enable vulnerability scanning
- ✅ Use minimal base images
- ✅ Implement network restrictions
- ✅ Enable HTTPS-only traffic
- ✅ Use TLS 1.2 or higher
- ✅ Regularly update dependencies
- ✅ Follow principle of least privilege

### **CI/CD**

- ✅ Automate all deployments
- ✅ Use separate pipelines per environment
- ✅ Implement approval gates for production
- ✅ Run security scans in pipeline
- ✅ Test infrastructure changes in dev first
- ✅ Enable rollback capabilities
- ✅ Monitor pipeline health

### **Monitoring**

- ✅ Enable Application Insights from day one
- ✅ Set up alerts for critical metrics
- ✅ Use structured logging
- ✅ Monitor error rates and latency
- ✅ Track business metrics
- ✅ Review logs regularly
- ✅ Set up dashboards for visibility
- ✅ Configure log retention policies

### **Cost Optimization**

- ✅ Use appropriate SKUs (Basic for dev, Standard/Premium for prod)
- ✅ Enable auto-scaling in production
- ✅ Clean up unused resources
- ✅ Use cost alerts
- ✅ Monitor spend with Cost Management

---

## 🙏 Acknowledgments

- Azure documentation and best practices
- Terraform community
- GitHub Actions community
- Open source contributors

---

## 📚 Additional Resources

### **Azure Documentation**

- [Azure App Service](https://docs.microsoft.com/azure/app-service/)
- [Azure Container Registry](https://docs.microsoft.com/azure/container-registry/)
- [Application Insights](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
- [Azure Key Vault](https://docs.microsoft.com/azure/key-vault/)

### **Terraform**

- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

### **CI/CD**

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [CI/CD Best Practices](https://docs.microsoft.com/azure/architecture/best-practices/ci-cd)

### **Security**

- [Azure Security Best Practices](https://docs.microsoft.com/azure/security/fundamentals/best-practices-and-patterns)
- [Container Security](https://docs.microsoft.com/azure/container-registry/container-registry-best-practices)

---

## 📊 Project Status

### **Current Status**

✅ Infrastructure as Code: **Complete**  
✅ CI/CD Pipeline: **Complete**  
✅ Security: **Complete**  
✅ Monitoring: **Complete**  
✅ Documentation: **Complete**  

### **What's Implemented**

✅ Multi-environment support (dev/prod)  
✅ Automated CI/CD pipeline  
✅ Security scanning (Trivy + Checkov)  
✅ Managed Identity  
✅ Key Vault integration  
✅ Application Insights monitoring  
✅ Log Analytics workspace  
✅ Health checks with auto-healing  
✅ IP-based access restrictions  
✅ HTTPS enforcement with TLS 1.2+  
✅ Structured application logging  
✅ Automated alerting  
✅ Docker containerization  
✅ Production-ready with Gunicorn  



**Last Updated:** 2026-02-18  
**Version:** 1.0.0
