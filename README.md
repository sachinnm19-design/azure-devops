# 🚀 Azure DevOps Demo - Complete CI/CD Pipeline

A production-ready DevOps demonstration project showcasing Infrastructure as Code (IaC), CI/CD automation, security best practices, and application monitoring on Azure

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
- [Best Practices](#-best-practices)
- [Future Enhancements](#-future-enhancements)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Overview

This project demonstrates a complete DevOps workflow with:

- **Infrastructure as Code** using Terraform with Terraform Cloud backend
- **Containerized Application** with Docker
- **Multi-Environment Deployment** (Dev/Prod)
- **Automated CI/CD** with GitHub Actions
- **Security Scanning** and vulnerability detection
- **Application Monitoring** with Application Insights
- **Network Security** with IP restrictions and TLS enforcement

### **Key Technologies**

- **Cloud Platform:** Microsoft Azure
- **IaC Tool:** Terraform (with Terraform Cloud state management)
- **Container Registry:** Azure Container Registry (ACR) - Public Access
- **Compute:** Azure App Service (Linux Containers)
- **Monitoring:** Application Insights + Log Analytics
- **CI/CD:** GitHub Actions
- **Application:** Python Flask with Gunicorn (Production-Ready)

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
│  │  │ Application        │      │  Application Insights  │  │  │
│  │  │ Insights           │      │  - Logs & Metrics      │  │  │
│  │  │ - Monitoring       │      │  - Exception Tracking  │  │  │
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

- ✅ **Multi-environment support** (dev, prod)
- ✅ **Modular Terraform code** for reusability
- ✅ **Terraform Cloud backend** for state management and workspaces
- ✅ **Azure Container Registry** for image storage (Public Access)
- ✅ **App Service with Linux containers**
- ✅ **Network Security Groups** for traffic control

### **Security**

- ✅ **Managed Identity** for Azure resource access
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
- ✅ **Terraform Cloud integration** via workspace variables
- ✅ **Pull request validation**
- ✅ **Production approval gates**

### **Observability & Monitoring**

- ✅ **Application Insights** integration
- ✅ **Log Analytics Workspace** for centralized logging
- ✅ **Structured application logging**
- ✅ **Health check endpoint** with auto-healing
- ✅ **Exception tracking** with stack traces
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
| Azure CLI | 2.40+ | Azure resource management |
| Terraform | 1.3+ | Infrastructure provisioning |
| Docker | 20.10+ | Container builds and testing |
| Git | 2.30+ | Version control |
| GitHub Account | - | Code hosting and CI/CD |

### **Azure Requirements**

- Active Azure subscription
- Contributor or Owner role on subscription
- Resource quotas for:
  - App Service Plans
  - Container Registries
  - Application Insights
  - Log Analytics Workspaces

### **Terraform Cloud Requirements**

- Terraform Cloud account (free tier available)
- API token for CI/CD authentication
- Workspace configured in Terraform Cloud

---

## 🚀 Quick Start

### **1. Clone the Repository**

```bash
git clone https://github.com/sachinnm19-design/azure-devops.git
cd azure-devops
```

### **2. Create Azure Resources via Portal**

Create the following resources in Azure Portal:
- Resource Group (e.g., `devops-demo-rg-dev`)
- Container Registry (e.g., `devopsdemoregistry`)
- App Service Plan and Web App
- Application Insights
- Log Analytics Workspace

### **3. Set Up Terraform Cloud**

1. Create a Terraform Cloud account at https://app.terraform.io
2. Create an API token in your user settings
3. Create a workspace for each environment (dev, prod)
4. Configure workspace variables:
   - `subscription_id`
   - `tenant_id`
   - `client_id`
   - `client_secret`

### **4. Configure GitHub Secrets**

Add the following secrets to your GitHub repository:

```
Settings → Secrets and variables → Actions → New repository secret
```

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `AZURE_CREDENTIALS` | Azure Service Principal JSON | Azure authentication |
| `TF_API_TOKEN` | Terraform Cloud API Token | Terraform Cloud authentication |

**Azure Credentials Format:**
```json
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "your-secret",
  "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}
```

### **5. Update Configuration Files**

**Update `infra/provider.tf`:**

```hcl
terraform {
  cloud {
    organization = "your-organization"
    
    workspaces {
      name = "azure-devops-dev"
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
3. ✅ Deploy infrastructure via Terraform Cloud
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
```

---

## 🏗️ Infrastructure

### **Core Resources**

| Resource | Purpose | Configuration |
|----------|---------|---------------|
| Resource Group | Logical container | Per environment |
| App Service Plan | Compute capacity | B1 (dev), P1V2 (prod) |
| Web App | Application hosting | Linux container |
| Container Registry | Image storage | Public access enabled |
| Application Insights | Monitoring | Web application type |
| Log Analytics | Centralized logging | PerGB2018 pricing |

### **Managed Identity**

The Web App uses **System-Assigned Managed Identity** for:
- ✅ Pulling images from ACR (AcrPull role)
- ✅ Secure, credential-free authentication

### **Infrastructure Modules**

#### **ACR Module** (`modules/acr`)
- Container Registry provisioning
- SKU selection (Basic/Standard/Premium)
- **Public access enabled** for GitHub Actions CI/CD to pull images
- Managed Identity integration

**Note on Public ACR Access:** ACR is configured with public access to allow GitHub Actions CI/CD pipeline to pull container images. To make ACR private while maintaining CI/CD functionality:
- Implement private endpoints in your VNet
- Use Managed Identity with proper RBAC roles
- Restrict ACR access via network rules
- Use a self-hosted GitHub Actions runner in the VNet

#### **App Service Module** (`modules/app_service`)
- App Service Plan creation
- Web App configuration with Managed Identity
- Container settings
- Application Insights integration
- IP restrictions
- Health check configuration

#### **Networking Module** (`modules/networking`)
- Network Security Groups
- Security rules
- Configurable creation

### **Terraform Commands**

```bash
cd infra

# Initialize (connects to Terraform Cloud)
terraform init

# Validate
terraform validate

# Plan (dev workspace)
terraform plan

# Apply (dev workspace)
terraform apply

# Destroy (dev workspace)
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
│  Terraform  │ Plan & Apply via Cloud
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
- ✅ **Terraform Cloud integration** for state management
- ✅ **Environment-specific deployments**
- ✅ **Workspace variables** for secure configuration
- ✅ **Rollback capability**

### **Workflow File**

Located at `.github/workflows/deploy.yml`

Key steps:
1. **Checkout code**
2. **Setup Azure CLI**
3. **Build Docker image**
4. **Security scanning**
5. **Terraform init/plan/apply** (via Terraform Cloud)
6. **Push image to ACR**
7. **Restart Web App**

### **GitHub Secrets Used**

Only 2 secrets are configured:
- `AZURE_CREDENTIALS`: For Azure CLI authentication
- `TF_API_TOKEN`: For Terraform Cloud authentication

All other configuration is managed via Terraform Cloud workspace variables.

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

- ✅ No secrets stored in code or configuration files
- ✅ Managed Identity for Azure resource access
- ✅ GitHub Secrets for CI/CD credentials (only 2: AZURE_CREDENTIALS, TF_API_TOKEN)
- ✅ Terraform Cloud workspace variables for sensitive configuration

### **Access Control**

| Resource | Principal | Authentication |
|----------|-----------|-----------------|
| ACR | Web App Managed Identity | AcrPull role |
| Azure Resources | Service Principal (GitHub Actions) | Contributor role via AZURE_CREDENTIALS |
| Terraform Cloud | GitHub Actions | TF_API_TOKEN |

### **Security Checklist**

- [x] HTTPS enforced
- [x] TLS 1.2+ required
- [x] IP restrictions enabled
- [x] Default deny on unmatched traffic
- [x] FTP disabled
- [x] Managed Identity enabled
- [x] Container scanning enabled
- [x] IaC security scanning enabled
- [x] Minimal base images
- [x] No sensitive data in code

---

## 📊 Monitoring & Observability

### **Application Insights**

Application Insights is automatically configured and provides:
- ✅ Request tracking and exception logging
- ✅ Dependency tracking (external calls)
- ✅ Live metrics stream
- ✅ Structured application logging

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
    Count = count()
  by bin(timestamp, 5m)
| render timechart
```

#### **Error Analysis**

```kusto
requests
| where success == false
| summarize ErrorCount = count() by bin(timestamp, 1h), resultCode
| render barchart
```

#### **Exception Analysis**

```kusto
exceptions
| where timestamp > ago(24h)
| summarize Count = count() by type, outerMessage
| order by Count desc
```

### **Application Endpoints**

| Endpoint | Method | Description | Response |
|----------|--------|-------------|----------|
| `/health` | GET | Health check | `{"status": "ok"}` |

#### **Testing Endpoint**

```bash
# Health check
curl https://devops-demo-webapp-dev.azurewebsites.net/health
```

### **Viewing Logs**

#### **Real-time Log Streaming**

```bash
# Stream application logs
az webapp log tail \
  --name devops-demo-webapp-dev \
  --resource-group devops-demo-rg-dev
```

#### **Query Logs via CLI**

```bash
# Query Application Insights logs
az monitor app-insights query \
  --app devops-demo-webapp-dev-insights \
  --resource-group devops-demo-rg-dev \
  --analytics-query "traces | where timestamp > ago(1h) | limit 100"
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

# Test endpoint
curl http://localhost:3000/health
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

# Test from unauthorized IP (should fail with 403)
curl -v https://$WEBAPP_URL/health
```

---

## 💡 Best Practices

### **Infrastructure as Code**

- ✅ Use modules for reusability
- ✅ Version control all infrastructure code
- ✅ Use Terraform Cloud for state management
- ✅ Separate environments (dev/prod)
- ✅ Use workspace variables for configuration
- ✅ Document all resources with comments
- ✅ Use consistent naming conventions

### **Security**

- ✅ Use Managed Identities over credentials
- ✅ Minimize stored secrets (only 2 GitHub secrets)
- ✅ Enable vulnerability scanning
- ✅ Use minimal base images
- ✅ Implement network restrictions
- ✅ Enable HTTPS-only traffic
- ✅ Use TLS 1.2 or higher
- ✅ Regularly update dependencies

### **CI/CD**

- ✅ Automate all deployments
- ✅ Use separate workspaces per environment
- ✅ Run security scans in pipeline
- ✅ Test infrastructure changes in dev first
- ✅ Use semantic versioning for images
- ✅ Enable rollback capabilities

### **Monitoring**

- ✅ Enable Application Insights from day one
- ✅ Use structured logging
- ✅ Monitor error rates and exceptions
- ✅ Review logs regularly
- ✅ Configure log retention policies

### **Cost Optimization**

- ✅ Use appropriate SKUs (B1 for dev, P1V2 for prod)
- ✅ Clean up unused resources
- ✅ Monitor spend with Azure Cost Management
- ✅ Use free tier of Terraform Cloud

---

## 🚀 Future Enhancements

### **Phase 1: Enhanced Infrastructure**

- [ ] Implement Virtual Network with private endpoints
- [ ] Make ACR private with private endpoints
- [ ] Enable ACR geo-replication
- [ ] Use Premium App Service Plan with auto-scaling
- [ ] Add Azure Firewall for advanced security

### **Phase 2: Advanced Application Features**

- [ ] Implement readiness/liveness probes
- [ ] Add distributed tracing (OpenTelemetry)
- [ ] Implement API rate limiting
- [ ] Add Redis cache for performance
- [ ] Add authentication/authorization (Azure AD)

### **Phase 3: DevOps Maturity**

- [ ] Implement blue-green deployments
- [ ] Add canary deployment strategy
- [ ] Implement feature flags
- [ ] Add automated rollback on failure
- [ ] Implement GitOps with Flux/ArgoCD

### **Phase 4: Compliance & Governance**

- [ ] Implement Azure Policy
- [ ] Add compliance scanning (CIS benchmarks)
- [ ] Implement audit logging
- [ ] Add regulatory compliance checks
- [ ] Implement backup and disaster recovery

---

## 🤝 Contributing

We welcome contributions! Here's how to contribute:

### **1. Fork the Repository**

```bash
git clone https://github.com/YOUR-USERNAME/azure-devops.git
cd azure-devops
```

### **2. Create a Feature Branch**

```bash
git checkout -b feature/your-feature-name
```

### **3. Test Your Changes**

```bash
# Test Terraform changes
cd infra
terraform init
terraform validate
terraform plan

# Test application changes
cd app
docker build -t demo-app:test .
docker run -p 3000:3000 demo-app:test
```

### **4. Commit and Push**

```bash
git add .
git commit -m "feat: add new feature"
git push origin feature/your-feature-name
```

### **5. Create a Pull Request**

- Describe your changes
- Link related issues
- Request review

---

## 📄 License

This project is for demonstration and educational purposes.

---

## 📞 Support

For issues, questions, or contributions:

- 🐛 **Report bugs:** [GitHub Issues](https://github.com/sachinnm19-design/azure-devops/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/sachinnm19-design/azure-devops/discussions)

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

### **Terraform**

- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Cloud Documentation](https://www.terraform.io/cloud-docs)

### **CI/CD**

- [GitHub Actions Documentation](https://docs.github.com/actions)

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
✅ Application Insights monitoring  
✅ Log Analytics workspace  
✅ Health checks with auto-healing  
✅ IP-based access restrictions  
✅ HTTPS enforcement with TLS 1.2+  
✅ Structured application logging  
✅ Docker containerization  
✅ Production-ready with Gunicorn  
✅ Terraform Cloud integration  
✅ Minimal GitHub Secrets (only 2)  

---

**Made with ❤️ for the DevOps Community**

⭐ Star this repository if you found it helpful!

🐛 Found a bug? [Open an issue](https://github.com/sachinnm19-design/azure-devops/issues)

🤝 Want to contribute? [Fork and submit a PR](#-contributing)

---

**Last Updated:** 2026-02-17  
**Version:** 1.0.0
