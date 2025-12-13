# DevOps Take-Home Assignment – Terraform, Azure, and GitHub Actions

This repo demonstrates a simple DevOps workflow:

- Infrastructure as Code using **Terraform**
- Containerized **Python Flask** application
- Automated CI/CD using **GitHub Actions**
- Deployment to **Azure Web App for Containers** with images stored in **Azure Container Registry (ACR)**

---

## 📁 Repository Structure

```text
app/                     # Containerized web application (Flask)
  app.py
  requirements.txt
  Dockerfile

infra/                   # Terraform IaC for Azure resources
  provider.tf
  variables.tf
  main.tf
  outputs.tf

.github/workflows/
  build-and-deploy.yml   # CI/CD pipeline: build → push → deploy

README.md
architecture-diagram.md  # Description + link/screenshot to diagram
