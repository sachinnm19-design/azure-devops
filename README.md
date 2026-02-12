# 🚀 Azure DevOps Demo - Complete CI/CD Pipeline

A production-ready DevOps demonstration project showcasing Infrastructure as Code (IaC), CI/CD automation, security best practices, and comprehensive monitoring on Azure.

[![CI/CD Pipeline](https://github.com/sachinnm19-design/azure-devops/actions/workflows/deploy.yml/badge.svg)](https://github.com/sachinnm19-design/azure-devops/actions/workflows/deploy.yml)

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Features](#-features)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Infrastructure](#-infrastructure)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Security](#-security)
- [Monitoring & Observability](#-monitoring--observability)
- [Testing](#-testing)
- [Troubleshooting](#-troubleshooting)
- [Best Practices](#-best-practices)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)
- [License](#-license)

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
- **Security:** Azure Key Vault, Managed Identities
- **CI/CD:** GitHub Actions
- **Application:** Python Flask (containerized)

---

## 🏗️ Architecture

### **High-Level Architecture**

```
┌─────────────────────────────────────────────────────────────────┐
│                         GitHub Repository                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐  │
│  │ Application  │  │     IaC      │  │   GitHub Actions     │  │
│  │  Code (Flask)│  │  (Terraform) │  │   (CI/CD Pipeline)   │  │
│  └──────────────┘  └──────────────┘  └──────────────────────┘  │
└────────────────────────────┬────────────────────────────────────┘
                             │
                    Triggers on Push/PR
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Actions Workflow                       │
│  ┌───────────┐  ┌──────────────┐  ┌────────────┐  ┌─────────┐ │
│  │   Build   │→ │Security Scan │→ │  Terraform │→ │ Deploy  │ │
│  │  & Test   │  │   (Trivy)    │  │   Apply    │  │  to App │ │
│  └───────────┘  └──────────────┘  └────────────┘  └─────────┘ │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Azure Cloud Platform                        │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    Resource Group                         │  │
│  │                                                            │  │
│  │  ┌────────────────────┐      ┌────────────────────────┐  │  │
│  │  │  Container Registry│      │   App Service Plan     │  │  │
│  │  │      (ACR)         │      │     (Linux)            │  │  │
│  │  │  ┌──────────────┐  │      │  ┌──────────────────┐  │  │  │
│  │  │  │Docker Images │  │      │  │   Web App        │  │  │  │
│  │  │  │  - Flask App │  │─────▶│  │  (Container)     │  │  │  │
│  │  │  └──────────────┘  │      │  └──────────────────┘  │  │  │
│  │  └────────────────────┘      └────────────────────────┘  │  │
│  │                                                            │  │
│  │  ┌────────────────────┐      ┌────────────────────────┐  │  │
│  │  │   Key Vault        │      │  Application Insights  │  │  │
│  │  │  - Secrets         │      │  - Logs & Metrics      │  │  │
│  │  │  - Access Policies │      │  - Alerts              │  │  │
│  │  └────────────────────┘      └────────────────────────┘  │  │
│  │                                                            │  │
│  │  ┌────────────────────┐      ┌────────────────────────┐  │  │
│  │  │ Log Analytics      │      │  Networking            │  │  │
│  │  │  - Centralized Logs│      │  - IP Restrictions     │  │  │
│  │  │  - Query Engine    │      │  - NSG Rules           │  │  │
│  │  └────────────────────┘      └────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### **Network Security**

```
┌─────────────────────────────────────────────────────────────────┐
│                         Internet                                 │
└────────────────────────────┬────────────────────────────────────┘
                             │
                   ┌─────────▼──────────┐
                   │  Azure Front Door  │
                   │    (Optional)      │
                   └─────────┬──────────┘
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
                   │  Managed Identity  │
                   │   ACR Pull Access  │
                   └────────────────────┘
```

---

## ✨ Features

### **Infrastructure & Platform**

- ✅ **Multi-environment support** (dev, staging, prod)
- ✅ **Modular Terraform code** for reusability
- ✅ **Azure Container Registry** for image storage
- ✅ **App Service with Linux containers**
- ✅ **Virtual Network** integration ready
- ✅ **Network Security Groups** for traffic control

### **Security**

- ✅ **Managed Identity** for Azure resource access
- ✅ **Azure Key Vault** for secrets management
- ✅ **IP-based access restrictions** with default deny
- ✅ **TLS 1.2+** enforcement
- ✅ **HTTPS-only** traffic
- ✅ **FTP disabled** for security
- ✅ **Container vulnerability scanning** with Trivy
- ✅ **Terraform security scanning** with Checkov
- ✅ **SCM endpoint protection**

### **CI/CD Pipeline**

- ✅ **Automated builds** on every commit
- ✅ **Multi-stage deployment** (build → test → deploy)
- ✅ **Environment-specific configurations**
- ✅ **Automated security scanning**
- ✅ **Terraform state management** in Azure
- ✅ **Pull request validation**
- ✅ **Production approval gates**

### **Observability & Monitoring**

- ✅ **Application Insights** integration
- ✅ **Log Analytics Workspace** for centralized logging
- ✅ **Structured application logging**
- ✅ **Health check endpoint** with auto-healing
- ✅ **Performance metrics** (CPU, memory, response time)
- ✅ **Automated alerts** for critical metrics
- ✅ **Real-time log streaming**
- ✅ **Exception tracking** with stack traces
- ✅ **Request/response logging**

### **Application**

- ✅ **Containerized Python Flask** application
- ✅ **Production-ready** with Gunicorn
- ✅ **Health check endpoint** (`/health`)
- ✅ **Info endpoint** (`/info`)
- ✅ **Docker health checks**
- ✅ **Comprehensive error handling**

---

## 📁 Project Structure

```
.
├── .github/
│   └── workflows/
│       └── deploy.yml              # CI/CD pipeline definition
│
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
│   ├── datasources.tf              # Data sources
│   ├── monitoring.tf               # Monitoring alerts
│   │
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
│   │
│   └── environments/
│       ├── dev.tfvars              # Dev environment variables
│       └── prod.tfvars             # Prod environment variables
│
├── README.md                       # This file
└── .gitignore                      # Git ignore rules
```

---

## 🔧 Prerequisites

### **Required Tools**

| Tool | Version | Purpose |
|------|---------|---------|
| Azure CLI | 2.50+ | Azure resource management |
| Terraform | 1.5+ | Infrastructure provisioning |
| Docker | 20.10+ | Container builds and testing |
| Git | 2.30+ | Version control |
| GitHub Account | - | Code hosting and CI/CD |

### **Azure Requirements**

- Active Azure subscription
- Contributor or Owner role on subscription
- Service Principal for Terraform
- Resource quotas for:
  - App Service Plans
  - Container Registries
  - Key Vaults
  - Log Analytics Workspaces

---

## 🚀 Quick Start

### **1. Clone the Repository**

```bash
git clone https://github.com/sachinnm19-design/azure-devops.git
cd azure-devops
```

### **2. Set Up Azure Service Principal**

```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "<your-subscription-id>"

# Create Service Principal
az ad sp create-for-rbac \
  --name "terraform-sp" \
  --role Contributor \
  --scopes /subscriptions/<subscription-id>

# Output (save these values):
# {
#   "appId": "xxxx",           # ARM_CLIENT_ID
#   "password": "xxxx",        # ARM_CLIENT_SECRET
#   "tenant": "xxxx"           # ARM_TENANT_ID
# }
```

### **3. Configure GitHub Secrets**

Add the following secrets to your GitHub repository:

```
Settings → Secrets and variables → Actions → New repository secret
```

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `AZURE_CLIENT_ID` | Service Principal App ID | Terraform authentication |
| `AZURE_CLIENT_SECRET` | Service Principal Password | Terraform authentication |
| `AZURE_SUBSCRIPTION_ID` | Your subscription ID | Target Azure subscription |
| `AZURE_TENANT_ID` | Your tenant ID | Azure AD tenant |
| `ARM_CLIENT_ID` | Same as AZURE_CLIENT_ID | Terraform provider auth |
| `ARM_CLIENT_SECRET` | Same as AZURE_CLIENT_SECRET | Terraform provider auth |
| `ARM_SUBSCRIPTION_ID` | Same as AZURE_SUBSCRIPTION_ID | Terraform provider auth |
| `ARM_TENANT_ID` | Same as AZURE_TENANT_ID | Terraform provider auth |

### **4. Create Storage Account for Terraform State**

```bash
# Create resource group
az group create \
  --name terraform-state-rg \
  --location eastus

# Create storage account
az storage account create \
  --name tfstatedevops$(date +%s) \
  --resource-group terraform-state-rg \
  --location eastus \
  --sku Standard_LRS

# Create container
az storage container create \
  --name tfstate \
  --account-name <storage-account-name>

# Get storage account key
az storage account keys list \
  --resource-group terraform-state-rg \
  --account-name <storage-account-name> \
  --query "[0].value" -o tsv
```

Add these to GitHub secrets:
- `TF_STATE_STORAGE_ACCOUNT`: Storage account name
- `TF_STATE_STORAGE_KEY`: Storage account key

### **5. Update Configuration Files**

**Update `infra/provider.tf`:**

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "<your-storage-account-name>"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
```

**Update IP restrictions in `infra/main.tf`:**

```hcl
ip_restrictions = [
  {
    ip_address = "YOUR.IP.ADDRESS.HERE"  # Replace with your IP
  }
]
```

### **6. Deploy**

```bash
# Create feature branch
git checkout -b feature/initial-setup

# Commit changes
git add .
git commit -m "Initial setup with custom configuration"
git push origin feature/initial-setup

# Create Pull Request on GitHub
# Merge to main branch
```

The CI/CD pipeline will automatically:
1. ✅ Build the Docker image
2. ✅ Run security scans
3. ✅ Deploy infrastructure
4. ✅ Deploy application

### **7. Verify Deployment**

```bash
# Get the Web App URL
az webapp show \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev \
  --query defaultHostName -o tsv

# Test the application
curl https://<webapp-url>/health
curl https://<webapp-url>/info
```

---

## 🏗️ Infrastructure

### **Core Resources**

| Resource | Purpose | Configuration |
|----------|---------|---------------|
| Resource Group | Logical container | Per environment |
| App Service Plan | Compute capacity | B1 (dev), P1V2 (prod) |
| Web App | Application hosting | Linux container |
| Container Registry | Image storage | Basic SKU (dev), Premium (prod) |
| Key Vault | Secrets management | Standard SKU |
| Application Insights | Monitoring | Web application type |
| Log Analytics | Centralized logging | PerGB2018 pricing |
| Network Security Group | Network security | Port 443 allowed |

### **Managed Identity**

The Web App uses **System-Assigned Managed Identity** for:
- ✅ Pulling images from ACR (AcrPull role)
- ✅ Accessing Key Vault secrets (Get, List permissions)
- ✅ Secure, credential-free authentication

### **Infrastructure Modules**

#### **ACR Module** (`modules/acr`)
- Container Registry provisioning
- SKU selection (Basic/Standard/Premium)
- Public/private access control
- Admin user management

#### **App Service Module** (`modules/app_service`)
- App Service Plan creation
- Web App configuration
- Container settings
- Application Insights integration
- IP restrictions
- Health check configuration
- Logging configuration

#### **Networking Module** (`modules/networking`)
- Virtual Network (optional)
- Subnets
- Network Security Groups
- Security rules

### **Terraform Commands**

```bash
cd infra

# Initialize
terraform init

# Validate
terraform validate

# Plan (dev)
terraform plan -var-file="environments/dev.tfvars"

# Apply (dev)
terraform apply -var-file="environments/dev.tfvars"

# Destroy (dev)
terraform destroy -var-file="environments/dev.tfvars"
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

- ✅ **Automated on push** to main branch
- ✅ **PR validation** without deployment
- ✅ **Security scanning** with Trivy and Checkov
- ✅ **Terraform state locking** in Azure Storage
- ✅ **Environment-specific deployments**
- ✅ **Manual approval** for production (optional)
- ✅ **Rollback capability**

### **Workflow File**

Located at `.github/workflows/deploy.yml`

Key steps:
1. **Checkout code**
2. **Setup Azure CLI**
3. **Build Docker image**
4. **Security scanning**
5. **Terraform init/plan/apply**
6. **Push image to ACR**
7. **Restart Web App**

### **Environment Variables**

Set in GitHub Actions workflow:

```yaml
env:
  AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  RESOURCE_GROUP: devops-demo-rg-${{ github.ref == 'refs/heads/main' && 'dev' || 'dev' }}
  WEBAPP_NAME: devops-demo-webapp-${{ github.ref == 'refs/heads/main' && 'dev' || 'dev' }}
  ACR_NAME: devopsdemoregistry
```

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

#### **SCM (Deployment) Protection**

Deployment endpoints are also protected:

```hcl
scm_ip_restriction_default_action = "Deny"
```

#### **TLS/SSL Configuration**

```hcl
https_only          = true
minimum_tls_version = "1.2"  # Can be upgraded to 1.3
ftps_state          = "Disabled"
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

### **Infrastructure Security**

#### **Terraform Security Scanning**

Automated with Checkov:

```bash
checkov -d infra/ \
  --quiet \
  --compact \
  --skip-check CKV_AZURE_*
```

#### **Secrets Management**

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
- [x] FTP disabled
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
  --resource-group devops-demo-rg-dev

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
    SuccessRate = avg(success)*100, 
    Count = count(),
    AvgDuration = avg(duration)
  by bin(timestamp, 5m)
| render timechart
```

#### **Error Rate Analysis**

```kusto
requests
| where success == false
| summarize ErrorCount = count() by bin(timestamp, 1h), resultCode
| render barchart
```

#### **Response Time Percentiles**

```kusto
requests
| summarize 
    p50 = percentile(duration, 50),
    p95 = percentile(duration, 95),
    p99 = percentile(duration, 99)
  by bin(timestamp, 5m)
| render timechart
```

#### **Exception Analysis**

```kusto
exceptions
| where timestamp > ago(24h)
| summarize Count = count() by type, outerMessage
| order by Count desc
```

#### **Custom Metrics**

```kusto
customMetrics
| where name == "your_metric_name"
| summarize avg(value) by bin(timestamp, 5m)
| render timechart
```

### **Monitoring Alerts**

The following alerts are automatically configured:

| Alert | Threshold | Severity | Enabled |
|-------|-----------|----------|---------|
| High Error Rate | > 5% | Warning | Prod only |
| Slow Response Time | > 2000ms | Warning | Prod only |
| Health Check Failed | < 100 | Critical | Prod only |
| High CPU Usage | > 80% | Warning | Prod only |
| High Memory Usage | > 80% | Warning | Prod only |

**View Alerts:**

```bash
az monitor metrics alert list \
  --resource-group devops-demo-rg-dev
```

### **Viewing Logs**

#### **Real-time Log Streaming**

```bash
# Stream application logs
az webapp log tail \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev

# Stream with filter
az webapp log tail \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev \
  --filter Error
```

#### **Download Logs**

```bash
# Download all logs
az webapp log download \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev \
  --log-file logs.zip
```

#### **Query Logs via CLI**

```bash
# Query Application Insights logs
az monitor app-insights query \
  --app devops-demo-webapp-dev-insights \
  --resource-group devops-demo-rg-dev \
  --analytics-query "traces | where timestamp > ago(1h) | limit 100"
```

### **Application Endpoints**

| Endpoint | Method | Description | Response |
|----------|--------|-------------|----------|
| `/` | GET | Home page | JSON with app info |
| `/health` | GET | Health check | Detailed health status |
| `/info` | GET | App information | System and config details |

#### **Health Endpoint Response**

```json
{
  "status": "healthy",
  "timestamp": "2024-02-11T10:30:00Z",
  "environment": "dev",
  "version": "latest",
  "checks": {
    "application": "ok",
    "logging": "ok",
    "app_insights": "enabled"
  }
}
```

#### **Info Endpoint Response**

```json
{
  "application": "DevOps Demo App",
  "environment": "dev",
  "version": "latest",
  "python_version": "3.10.x",
  "monitoring": {
    "application_insights": "enabled",
    "logging_level": "INFO"
  }
}
```

### **Testing Endpoints**

```bash
# Health check
curl https://devops-demo-webapp-dev.azurewebsites.net/health

# Application info
curl https://devops-demo-webapp-dev.azurewebsites.net/info

# From specific IP (if behind proxy)
curl -H "X-Forwarded-For: YOUR.IP.ADDRESS" https://...
```

### **Performance Monitoring**

Monitor these key metrics:

- **Response Time:** < 500ms (target)
- **Error Rate:** < 1% (target)
- **Availability:** > 99.9% (target)
- **CPU Usage:** < 70% (normal operation)
- **Memory Usage:** < 70% (normal operation)

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
curl http://localhost:3000/info
curl http://localhost:3000/
```

#### **Test with Application Insights (Local)**

```bash
# Set environment variables
export APPINSIGHTS_INSTRUMENTATIONKEY="your-key"
export APPLICATIONINSIGHTS_CONNECTION_STRING="your-connection-string"

# Run application
python app.py

# Generate traffic
for i in {1..100}; do curl http://localhost:3000/health; done
```

### **Infrastructure Testing**

```bash
cd infra

# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Check formatting
terraform fmt -check

# Run plan
terraform plan -var-file="environments/dev.tfvars"

# Run security scan
checkov -d . --quiet
```

### **Integration Testing**

After deployment:

```bash
# Get Web App URL
WEBAPP_URL=$(az webapp show \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev \
  --query defaultHostName -o tsv)

# Test health endpoint
curl -f https://$WEBAPP_URL/health || echo "Health check failed"

# Test response time
curl -w "\nTime: %{time_total}s\n" https://$WEBAPP_URL/health

# Test from unauthorized IP (should fail with 403)
curl -v https://$WEBAPP_URL/health  # From non-whitelisted IP
```

### **Load Testing**

```bash
# Using Apache Bench
ab -n 1000 -c 10 https://$WEBAPP_URL/health

# Using hey (modern alternative)
hey -n 1000 -c 10 https://$WEBAPP_URL/health
```

---

## 🔧 Troubleshooting

### **Common Issues**

#### **Issue: Web App not accessible (403 Forbidden)**

**Cause:** Your IP is not in the whitelist.

**Solution:**

```bash
# Get your current public IP
curl ifconfig.me

# Update infra/main.tf
ip_restrictions = [
  {
    ip_address = "YOUR.NEW.IP.ADDRESS"
  }
]

# Redeploy
terraform apply -var-file="environments/dev.tfvars"
```

#### **Issue: Container fails to start**

**Cause:** Image pull error or application crash.

**Solution:**

```bash
# Check container logs
az webapp log tail \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev

# Check if image exists in ACR
az acr repository show \
  --name devopsdemoregistry \
  --image demo-app:latest

# Verify managed identity has AcrPull role
az role assignment list \
  --assignee <webapp-principal-id> \
  --scope <acr-id>

# Restart web app
az webapp restart \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev
```

#### **Issue: Terraform state locked**

**Cause:** Previous run didn't complete or release lock.

**Solution:**

```bash
# View locks
az storage container list \
  --account-name <storage-account> \
  --query "[?name=='tfstate']"

# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>
```

#### **Issue: No logs in Application Insights**

**Cause:** Instrumentation key not configured or sampling disabled.

**Solution:**

```bash
# Verify instrumentation key
az webapp config appsettings list \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev \
  --query "[?name=='APPINSIGHTS_INSTRUMENTATIONKEY']"

# Check sampling percentage
# Should be 100 for dev, lower for prod

# Wait 2-5 minutes for initial telemetry
# Then check Application Insights in portal
```

#### **Issue: Health check failing**

**Cause:** Application not responding on `/health`.

**Solution:**

```bash
# Check application logs
az webapp log tail \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev

# Verify health endpoint
curl https://devops-demo-webapp-dev.azurewebsites.net/health

# Check container status
az webapp show \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev \
  --query state

# Review Application Insights for exceptions
# Azure Portal → Application Insights → Failures
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
  --resource-group devops-demo-rg-dev \
  --sku P1V2

# Scale out (add instances)
az appservice plan update \
  --name devops-demo-asp-dev \
  --resource-group devops-demo-rg-dev \
  --number-of-workers 2

# Review dependency calls in Application Insights
```

#### **Issue: Memory leaks**

**Cause:** Application not releasing resources.

**Solution:**

```bash
# Monitor memory usage
az monitor metrics list \
  --resource <webapp-id> \
  --metric MemoryPercentage \
  --start-time 2024-02-11T00:00:00Z \
  --interval PT1H

# Check Application Insights for memory trends
# Investigate long-running requests
# Review application code for resource management

# Restart as temporary fix
az webapp restart \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev
```

### **Debugging Commands**

```bash
# Get all Web App configuration
az webapp config show \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev

# List all app settings
az webapp config appsettings list \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev

# Check deployment logs
az webapp log deployment list \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev

# SSH into container (if enabled)
az webapp ssh \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev
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
- ✅ Use semantic versioning for images
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
- ✅ Review Azure Advisor recommendations
- ✅ Use reserved instances for predictable workloads
- ✅ Monitor spend with Cost Management

---

## 🚀 Future Enhancements

### **Phase 1: Enhanced Infrastructure**

- [ ] Implement Virtual Network with private endpoints
- [ ] Add Azure Front Door for CDN and WAF
- [ ] Enable ACR geo-replication
- [ ] Use Premium App Service Plan with auto-scaling
- [ ] Implement Azure Private Link for ACR and Key Vault
- [ ] Add Azure Firewall for advanced security
- [ ] Deploy multi-region for high availability

### **Phase 2: Advanced Application Features**

- [ ] Implement readiness/liveness probes
- [ ] Add distributed tracing (OpenTelemetry)
- [ ] Implement API rate limiting
- [ ] Add Redis cache for performance
- [ ] Implement CDN for static assets
- [ ] Add authentication/authorization (Azure AD)
- [ ] Implement database integration (Cosmos DB/PostgreSQL)

### **Phase 3: DevOps Maturity**

- [ ] Implement blue-green deployments
- [ ] Add canary deployment strategy
- [ ] Implement feature flags
- [ ] Add automated rollback on failure
- [ ] Implement chaos engineering tests
- [ ] Add performance testing in pipeline
- [ ] Implement GitOps with Flux/ArgoCD

### **Phase 4: Observability**

- [ ] Add custom Application Insights metrics
- [ ] Implement distributed tracing
- [ ] Add user analytics
- [ ] Implement real-user monitoring (RUM)
- [ ] Add synthetic monitoring
- [ ] Implement AIOps for anomaly detection
- [ ] Add cost monitoring and alerts

### **Phase 5: Compliance & Governance**

- [ ] Implement Azure Policy
- [ ] Add compliance scanning (CIS benchmarks)
- [ ] Implement audit logging
- [ ] Add regulatory compliance checks
- [ ] Implement data classification
- [ ] Add RBAC hardening
- [ ] Implement backup and disaster recovery

---

## 🤝 Contributing

We welcome contributions! Here's how to contribute:

### **1. Fork the Repository**

```bash
# Click "Fork" on GitHub
# Then clone your fork
git clone https://github.com/YOUR-USERNAME/azure-devops.git
cd azure-devops
```

### **2. Create a Feature Branch**

```bash
git checkout -b feature/your-feature-name
```

### **3. Make Your Changes**

- Follow existing code style
- Add tests if applicable
- Update documentation
- Follow commit message conventions

### **4. Test Your Changes**

```bash
# Test Terraform changes
cd infra
terraform init
terraform validate
terraform plan -var-file="environments/dev.tfvars"

# Test application changes
cd app
docker build -t demo-app:test .
docker run -p 3000:3000 demo-app:test
```

### **5. Commit and Push**

```bash
git add .
git commit -m "feat: add new feature"
git push origin feature/your-feature-name
```

### **6. Create a Pull Request**

- Go to GitHub and create a PR
- Describe your changes
- Link related issues
- Request review

### **Commit Message Convention**

```
type(scope): subject

body (optional)

footer (optional)
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Tests
- `chore`: Maintenance

**Example:**

```
feat(monitoring): add Application Insights alerts

- Add high error rate alert
- Add slow response time alert
- Add health check failure alert
- Configure alerts for production only

Closes #123
```

---

## 📄 License

This project is for demonstration and educational purposes.

---

## 📞 Support

For issues, questions, or contributions:

- 🐛 **Report bugs:** [GitHub Issues](https://github.com/sachinnm19-design/azure-devops/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/sachinnm19-design/azure-devops/discussions)
- 📧 **Email:** your-email@example.com

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

### **Next Steps**

- [ ] Add automated testing in CI/CD
- [ ] Implement blue-green deployments
- [ ] Add performance testing
- [ ] Implement distributed tracing
- [ ] Add API documentation with Swagger
- [ ] Implement database layer

---

**Made with ❤️ for the DevOps Community**

⭐ Star this repository if you found it helpful!

🐛 Found a bug? [Open an issue](https://github.com/sachinnm19-design/azure-devops/issues)

🤝 Want to contribute? Check our [Contributing Guidelines](#-contributing)

---

**Last Updated:** 2024-02-11  
**Version:** 1.0.0
