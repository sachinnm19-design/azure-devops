terraform {
  required_version = ">= 1.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.55.0"
    }
  }

  # Terraform Cloud remote state + runs
  backend "remote" {
    organization = "AzureDevOpsDemo"

    workspaces {
      prefix = "devops-demo-"
    }
  }
}

provider "azurerm" {
  features {}

  # Service Principal auth (required for Terraform Cloud remote execution)
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}
