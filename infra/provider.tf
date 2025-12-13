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
}
