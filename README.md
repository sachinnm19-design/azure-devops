# DevOps Take-Home Assignment – Terraform, Azure, and GitHub Actions.

## 📋 Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Repository Structure](#repository-structure)
4. [Prerequisites](#prerequisites)
5. [Setup Instructions](#setup-instructions)
6. [CI/CD Pipeline](#cicd-pipeline)
7. [Security Considerations](#security-considerations)
8. [Cost Awareness](#cost-awareness)
9. [Production Readiness](#production-readiness)

## 🎯 Overview

This project demonstrates a production-ready DevOps workflow using:
- **Infrastructure as Code**: Terraform with modular design
- **Cloud Platform**: Microsoft Azure
- **CI/CD**: GitHub Actions with multi-stage pipeline
- **Security**: Managed Identity, Key Vault, security scanning
- **Observability**: Application Insights for logging and monitoring
- **Environment Separation**: Dev and Prod environments

### Key Features
✅ Modular Terraform structure with reusable components  
✅ Environment separation (dev/prod) using Terraform workspaces  
✅ Multi-stage CI/CD pipeline (Build → Security → Deploy)  
✅ Security scanning with Trivy  
✅ Managed Identity for secure ACR access  
✅ Azure Key Vault for secrets management  
✅ Application Insights for observability  
✅ HTTPS-only enforcement and TLS 1.2+  
✅ Manual approval gates for production  
✅ Branch-based deployment strategy  

## 🏗️ Architecture

### Infrastructure Design
[Insert your architecture diagram here]

**Components:**
- **Resource Group**: Logical container for all resources
- **Container Registry (ACR)**: Private Docker registry with public access disabled in prod
- **App Service Plan**: Linux-based hosting plan
- **Web App for Containers**: Hosts the containerized application
- **Application Insights**: Monitoring and logging
- **Key Vault**: Secrets management
- **Managed Identity**: Secure authentication without credentials
- **Network Security Group**: Basic network security rules

### Deployment Flow
```
Developer → Feature Branch → Pull Request → CI Validation
                                ↓
                          Merge to main
                                ↓
                    ┌───────────┴───────────┐
                    ↓                       ↓
              Build Stage           Security Scan
                    ↓                       ↓
              Docker Image            Trivy Scan
                    └───────────┬───────────┘
                                ↓
                          Deploy to DEV
                                ↓
                      Manual Approval Gate
                                ↓
                          Deploy to PROD
```

## 📁 Repository Structure

```
.
├── app/
│   ├── app.py              # Flask application
│   ├── requirements.txt    # Python dependencies
│   └── Dockerfile          # Container definition
│
├── infra/
│   ├── main.tf            # Main infrastructure
│   ├── provider.tf        # Provider configuration
│   ├── variables.tf       # Input variables
│   ├── outputs.tf         # Output values
│   └── datasources.tf     # Data sources
│
├── modules/
│   ├── acr/               # Container Registry module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── app_service/       # App Service module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── networking/        # Networking module
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── .github/
│   └── workflows/
│       ├── deploy.yml          # Multi-stage CD pipeline
│       └── pr-validation.yml   # PR validation
│
├── images/
│   └── architecture.png   # Architecture diagram
│
└── README.md
```

## ✅ Prerequisites

- **Azure Account**: Free tier subscription ([Sign up](https://azure.microsoft.com/free))
- **Terraform Cloud Account**: Free tier ([Sign up](https://app.terraform.io/signup/account))
- **GitHub Account**: For repository and Actions
- **Tools**: Azure CLI, Terraform CLI (for local testing)

## 🚀 Setup Instructions

### 1. Azure Configuration

#### Create Service Principal
```bash
az ad sp create-for-rbac \
  --name "devops-demo-sp" \
  --role Contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID> \
  --sdk-auth
```

Save the output JSON - you'll need it for GitHub Secrets.

### 2. Terraform Cloud Setup

#### Create Organization and Workspaces
1. Sign in to [Terraform Cloud](https://app.terraform.io)
2. Create organization: `YourOrgName`
3. Create workspaces:
   - `devops-demo-dev`
   - `devops-demo-prod`

#### Configure Workspace Variables

**For BOTH workspaces, add these Terraform variables:**

| Variable | Dev Value | Prod Value |
|----------|-----------|------------|
| `environment` | `dev` | `prod` |
| `location` | `eastus` | `eastus` |
| `resource_group_name` | `rg-devops-dev` | `rg-devops-prod` |
| `acr_name` | `acrdevopsdev123` | `acrdevopsprod123` |
| `app_service_plan_name` | `asp-devops-dev` | `asp-devops-prod` |
| `webapp_name` | `webapp-devops-dev-123` | `webapp-devops-prod-123` |
| `sku_name` | `B1` | `P1V2` |
| `image_name` | `demo-app` | `demo-app` |
| `image_tag` | `latest` | `latest` |
| `sp_object_id` | `<SP_OBJECT_ID>` | `<SP_OBJECT_ID>` |

**Environment Variables (mark as sensitive):**

| Variable | Value |
|----------|-------|
| `ARM_CLIENT_ID` | From Service Principal JSON |
| `ARM_CLIENT_SECRET` | From Service Principal JSON |
| `ARM_SUBSCRIPTION_ID` | Your Azure Subscription ID |
| `ARM_TENANT_ID` | From Service Principal JSON |

### 3. GitHub Configuration

#### Add Repository Secrets
Go to: **Settings → Secrets and variables → Actions → New repository secret**

| Secret Name | Value |
|-------------|-------|
| `AZURE_CREDENTIALS` | Service Principal JSON (full output) |
| `TF_API_TOKEN` | Terraform Cloud API token |

#### Configure Environments
Go to: **Settings → Environments**

Create two environments:
1. **dev** - No protection rules
2. **prod** - Add required reviewers (yourself or team)

### 4. Update Terraform Backend

Edit `infra/provider.tf` to match your Terraform Cloud organization:

```hcl
backend "remote" {
  organization = "YourOrgName"  # ← Change this

  workspaces {
    prefix = "devops-demo-"
  }
}
```

## 🔄 CI/CD Pipeline

### Pipeline Stages

#### 1️⃣ **Build Stage**
- Checkout code
- Build Docker image
- Run local container tests
- Save image as artifact

#### 2️⃣ **Security & Quality Stage**
- Trivy security scan for vulnerabilities
- Upload results to GitHub Security
- Terraform format and validation checks

#### 3️⃣ **Deploy to DEV** (Automatic)
- Terraform plan and apply
- Push image to ACR
- Configure managed identity
- Deploy to Web App
- Health check validation
- View application logs

#### 4️⃣ **Deploy to PROD** (Manual Approval)
- Wait for approval
- Same steps as DEV
- Production health checks

### Triggering Deployments

**Automatic (DEV):**
```bash
git checkout main
git pull origin main
# Make changes
git add .
git commit -m "feat: your feature"
git push origin main
```

**With PR Validation:**
```bash
git checkout -b feature/my-feature
# Make changes
git add .
git commit -m "feat: my feature"
git push origin feature/my-feature
# Create PR on GitHub
# CI runs automatically
# After approval, merge triggers CD
```

## 🔒 Security Considerations

### 1. **Identity & Access Management**
- ✅ Managed Identity for Web App (no credentials in code)
- ✅ Service Principal with least privilege (Contributor role)
- ✅ Key Vault access policies (SPN: write, App: read-only)

### 2. **Secrets Management**
- ✅ GitHub Secrets for CI/CD credentials
- ✅ Azure Key Vault for application secrets
- ✅ No hardcoded secrets in code/configs
- ✅ Terraform Cloud variables marked as sensitive

### 3. **Network Security**
- ✅ HTTPS-only enforcement on Web App
- ✅ TLS 1.2 minimum version
- ✅ IP restrictions support (configurable)
- ✅ ACR public access disabled in production
- ✅ Network Security Group for basic rules

### 4. **Container Security**
- ✅ Trivy scanning in pipeline
- ✅ Private container registry (ACR)
- ✅ Image tagging with commit SHA
- ✅ Base image from official Python (slim variant)

### 5. **Code Security**
- ✅ Branch protection on main
- ✅ Required PR reviews
- ✅ Automated security scanning
- ✅ SARIF upload to GitHub Security tab

## 💰 Cost Awareness

### Current Configuration Costs (Approximate)

| Resource | SKU/Tier | Monthly Cost (USD) |
|----------|----------|-------------------|
| **App Service Plan (Dev)** | B1 | ~$13 |
| **App Service Plan (Prod)** | P1V2 | ~$80 |
| **Container Registry** | Basic | ~$5 |
| **Key Vault** | Standard | ~$0.03/10k operations |
| **Application Insights** | Free tier | $0 (up to 5GB) |
| **Storage (TF state)** | N/A (Terraform Cloud free) | $0 |

**Total Dev Environment**: ~$18/month  
**Total Prod Environment**: ~$85/month  
**Combined**: ~$103/month

### Cost Optimization Recommendations

1. **Development Environment**
   - Use Azure free tier credits
   - Scale down or stop resources after hours
   - Use B1 tier (sufficient for testing)

2. **Production Environment**
   - Right-size based on actual load
   - Consider Reserved Instances for long-term (save up to 72%)
   - Enable auto-scaling based on metrics

3. **Container Registry**
   - Basic tier is sufficient for small projects
   - Clean up old/unused images regularly
   - Consider Standard tier only if needed (geo-replication, webhooks)

4. **Application Insights**
   - Free tier covers 5GB/month
   - Set up data retention policies
   - Configure sampling for high-volume apps

5. **General**
   - Set up Azure budgets and alerts
   - Use tags for cost allocation
   - Review Azure Advisor recommendations monthly

## 🚀 Production Readiness

### What's Currently Implemented
✅ Infrastructure as Code with version control  
✅ Environment separation (dev/prod)  
✅ Automated CI/CD pipeline  
✅ Security scanning  
✅ Managed Identity  
✅ Secrets management  
✅ Application monitoring  
✅ Health checks  
✅ HTTPS enforcement  

### What I'd Change for Production at Scale

#### 1. **Infrastructure**
- [ ] Implement Virtual Network with subnets
- [ ] Add Azure Front Door or Application Gateway for global load balancing
- [ ] Enable ACR geo-replication for disaster recovery
- [ ] Use Premium App Service Plan with auto-scaling
- [ ] Implement Azure Private Link for ACR and Key Vault
- [ ] Add Azure Firewall or WAF for advanced security
- [ ] Deploy multi-region for high availability

#### 2. **Application**
- [ ] Implement health/readiness/liveness probes
- [ ] Add distributed tracing (OpenTelemetry)
- [ ] Implement structured logging
- [ ] Add performance monitoring (APM)
- [ ] Implement caching (Redis)
- [ ] Add CDN for static assets
- [ ] Implement rate limiting and throttling

#### 3. **CI/CD**
- [ ] Implement blue-green or canary deployments
- [ ] Add automated integration tests
- [ ] Implement automated rollback on failure
- [ ] Add performance testing in pipeline
- [ ] Implement GitOps with ArgoCD or Flux
- [ ] Add deployment slots for zero-downtime
- [ ] Implement feature flags

#### 4. **Security**
- [ ] Implement Azure DDoS Protection
- [ ] Add Azure Security Center recommendations
- [ ] Implement Azure Sentinel for SIEM
- [ ] Add vulnerability scanning in registry
- [ ] Implement Azure Policy for compliance
- [ ] Add pen testing before major releases
- [ ] Implement secret rotation

#### 5. **Observability**
- [ ] Centralized logging with Log Analytics
- [ ] Custom dashboards in Azure Monitor
- [ ] Alert rules with actionable runbooks
- [ ] SLA monitoring and reporting
- [ ] Distributed tracing across services
- [ ] Business metrics tracking
- [ ] On-call rotation with PagerDuty/Opsgenie

#### 6. **Compliance & Governance**
- [ ] Implement Azure Blueprints
- [ ] Add compliance as code
- [ ] Implement resource locks
- [ ] Add backup and disaster recovery
- [ ] Document incident response procedures
- [ ] Implement change management process
- [ ] Regular security audits

#### 7. **Cost Management**
- [ ] Reserved Instances for predictable workloads
- [ ] Implement auto-shutdown for non-prod
- [ ] Use Azure Cost Management + Billing
- [ ] Implement FinOps practices
- [ ] Regular right-sizing reviews

## 🧪 Testing

### Local Testing
```bash
# Test Docker build
cd app
docker build -t demo-app:test .
docker run -p 3000:3000 demo-app:test

# Test health endpoint
curl http://localhost:3000/health

# Test Terraform
cd ../infra
terraform init
terraform validate
terraform fmt -check
terraform plan
```

### Viewing Logs
```bash
# Azure CLI
az webapp log tail --name <webapp-name> --resource-group <rg-name>

# Application Insights
# Navigate to Azure Portal → Application Insights → Logs
# Query: traces | where timestamp > ago(1h)
```

## 📊 Monitoring

### Application Insights Queries

**Health Check Monitoring:**
```kusto
requests
| where name == "GET /health"
| summarize SuccessRate = avg(success)*100, Count = count() by bin(timestamp, 5m)
| render timechart
```

**Error Rate:**
```kusto
requests
| where success == false
| summarize ErrorCount = count() by bin(timestamp, 1h), resultCode
| render barchart
```

**Response Time:**
```kusto
requests
| summarize avg(duration), percentile(duration, 95) by bin(timestamp, 5m)
| render timechart
```

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Ensure all tests pass locally
4. Create a Pull Request
5. Wait for CI validation
6. Request review
7. Merge after approval

## 📝 License

This project is for demonstration purposes.

## 👤 Author

**Your Name**  
DevOps Engineer  
[Your LinkedIn] | [Your GitHub]

---

## 🆘 Troubleshooting

### Common Issues

**Issue: Terraform state locked**
```bash
# View locks
terraform force-unlock <LOCK_ID>
```

**Issue: ACR authentication failed**
```bash
# Verify managed identity role assignment
az role assignment list --assignee <WEBAPP_PRINCIPAL_ID> --scope <ACR_ID>

# Ensure acrUseManagedIdentityCreds is enabled
az webapp config show --name <webapp> --resource-group <rg> | grep acrUseManagedIdentityCreds
```

**Issue: Health check failing**
```bash
# Check application logs
az webapp log tail --name <webapp> --resource-group <rg>

# Check if container is running
az webapp show --name <webapp> --resource-group <rg> --query state

# Restart web app
az webapp restart --name <webapp> --resource-group <rg>
```

**Issue: Terraform Cloud connection failed**
```bash
# Verify token
cat ~/.terraformrc

# Generate new token
# Go to: https://app.terraform.io/app/settings/tokens
```

## 📚 Additional Resources

- [Azure Documentation](https://docs.microsoft.com/azure/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Application Insights Documentation](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
