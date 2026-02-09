terraform {
  required_version = ">= 1.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.55.0"
    }
  }

  #  Single workspace - no prefix
  backend "remote" {
    organization = "TerraformDevOpsDemo"
    
    workspaces {
      name = "devops-demo"  # Single workspace for all environments
    }
  }
}

provider "azurerm" {
  features {}
}
