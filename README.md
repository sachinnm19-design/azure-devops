# DevOps Take-Home Assignment – Azure, Terraform & GitHub Actions

## 1. Introduction

This repository demonstrates a complete, production-oriented DevOps workflow using:

- Terraform for Infrastructure as Code (IaC)
- Terraform Cloud for remote state management and environment isolation
- Azure for hosting a containerized application
- Key Vault for secrets management and secure access
- GitHub Actions for CI/CD automation
- Pull Request–based workflow with approvals and environment gates

The solution provisions Azure infrastructure, builds a containerized application, and deploys it safely across DEV and PROD environments.

---

## 2. High-Level Architecture

For visual representations of the architecture, see the diagrams in the `images/` folder:
- **Azure Cloud Architecture.jpg**: Azure infrastructure and resource relationships
- **CI CD Architecture.jpg**: Complete CI/CD pipeline flow

### Azure Resources Provisioned
- Resource Group
- Azure Container Registry (ACR)
- App Service Plan (Linux)
- Azure Web App for Containers
- **Azure Key Vault**: Secure storage for sensitive application secrets (e.g., ACR credentials).

### CI/CD Flow
1. Developer creates a feature branch and raises a Pull Request
2. CI pipeline runs Terraform plan (DEV workspace) and Docker build validation
3. Pull Request is reviewed and approved
4. Merge to `main` triggers CD pipeline
5. DEV deployment happens automatically
6. PROD deployment requires manual approval

Terraform state and environment separation are handled using Terraform Cloud workspaces.
All sensitive credentials are securely stored in Azure Key Vault, eliminating the risk of hardcoding secrets.

---

## 3. Repository Structure

```
.
├── app/
│ ├── app.py
│ ├── requirements.txt
│ └── Dockerfile
│
├── infra/
│ ├── main.tf # Azure resources
│ ├── provider.tf # Providers & backend configuration
│ ├── variables.tf # Input variables
│ └── outputs.tf # Output values
│
├── images/
│ ├── Azure Cloud Architecture.jpg
│ └── CI CD Architecture.jpg
│
├── .github/
│ └── workflows/
│ ├── pr-validation.yml
│ └── deploy.yml
│
└── README.md
```

---

## 4. Application Details

- Simple containerized application using Flask (Python)
- Exposes a health endpoint:
    ```
    GET /health
    Response: { "status": "ok" }
    ```
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

```bash
az ad sp create-for-rbac \
  --name devops-demo-sp \
  --role Contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID> \
  --sdk-auth
```

Save the JSON output securely. It will be used in GitHub and Terraform Cloud.

### 6.2 Key Vault Setup

#### 6.2.1 Create Key Vault
Key Vault is automatically provisioned by Terraform using the configuration in `infra/main.tf`:
- Key Vault is named dynamically as `<acr_name>-kv` (based on the ACR name).
- Secrets for ACR credentials (`acr-admin-username`, `acr-admin-password`) are securely populated by Terraform.

#### 6.2.2 Access Policies
Terraform sets up the Key Vault Access Policies as follows:
- **Terraform Service Principal:** Full permissions for provisioning and managing secrets.
- **Web App Managed Identity:** Read-only access (`Get`, `List`) for retrieving secrets at runtime.

To review Access Policies:
```bash
az keyvault show --name <key-vault-name> --query properties.accessPolicies
```

---

## 7. Terraform Cloud Setup

### 7.1 Create an Organization
- Sign in to [Terraform Cloud](https://app.terraform.io)
- Create an organization (example: `AzureDevOpsDemo`)

### 7.2 Create Workspaces
Create two workspaces:

| Workspace Name       |
|-----------------------|
| devops-demo-dev       |
| devops-demo-prod      |

Each workspace represents a separate environment.

### 7.3 Configure Variables

#### Terraform Variables
| Key                  |
|----------------------|
| acr_name             |
| app_service_plan_name|
| environment          |
| image_name           |
| image_tag            |
| location             |
| resource_group_name  |
| sku_name             |
| sp_object_id         |
| webapp_name          |

#### Environment Variables
| Key                  |
|----------------------|
| ARM_CLIENT_ID        | 
| ARM_CLIENT_SECRET    | 
| ARM_SUBSCRIPTION_ID  | 
| ARM_TENANT_ID        |
Mark all sensitive environment variables appropriately in Terraform Cloud.

---

## 8. GitHub Repository Setup

### 8.1 GitHub Secrets
Add the following secrets to your repository:

| Secret Name         | Description                             |
|---------------------|-----------------------------------------|
| AZURE_CREDENTIALS   | Service Principal JSON from Azure       |
| TF_API_TOKEN        | Terraform Cloud API token               |

---

### 8.2 GitHub Environments
Create two environments in GitHub:
| Environment | Requires Approval |
|-------------|--------------------|
| dev         | No                |
| prod        | Yes               |

---

## 9. CI/CD Pipelines

### 9.1 CI – PR Validation
Runs on Pull Requests targeting the `main` branch.

Pipeline steps:
1. **Terraform Plan for DEV**:
   - Validates infrastructure configuration using DEV workspace.
2. **Docker Build Validation**:
   - Ensures containers are built correctly.

### 9.2 CD – Deployment Pipeline
Triggered on merges to the `main` branch.

#### DEV Deployment Pipeline:
1. Provisions infrastructure in DEV using Terraform.
2. Pushes Docker images to Azure Container Registry for DEV.
3. Deploys containers to a DEV Web App.

#### PROD Deployment Pipeline:
1. Waits for manual approval.
2. Provisions infrastructure in PROD using Terraform.
3. Pushes Docker images to Azure Container Registry for PROD.
4. Deploys containers to a PROD Web App.

---

## 10. Verification

After deployment, verify the application with the following:

- DEV:
```bash
curl https://<dev-webapp-name>.azurewebsites.net/health
```

- PROD:
```bash
curl https://<prod-webapp-name>.azurewebsites.net/health
```

Expected response:
```json
{ "status": "ok" }
```

---

## 11. Design & Best Practices

### Infrastructure
- Infrastructure is fully defined as code using Terraform.
- Terraform Cloud is used for remote state management and environment isolation.
- Single Terraform codebase reused across environments with variable overrides.

### CI/CD Governance
- PR-based validation ensures secure and reliable infrastructure updates.
- Approvals are required for production deployments.

### Secrets Management
- Sensitive credentials are securely stored in **Azure Key Vault**.
- Strict access control:
  - Terraform Service Principal for writes.
  - Web App Managed Identity for read-only access.
- No secrets are hardcoded in the codebase or pipelines.

---

## 12. Conclusion

This project demonstrates a real-world DevOps implementation using Terraform, Azure, Key Vault, and GitHub Actions. The overall focus is on secure infrastructure management, automation, and governance.

---

## Author

Sachin Mohan  
DevOps Engineer  
