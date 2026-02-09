terraform {
  required_version = ">= 1.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.55.0"
    }
  }

  # Single workspace - no prefix
  backend "remote" {
    organization = "TerraformDevOpsDemo"
    
    workspaces {
      name = "devops-demo"
    }
  }
}

provider "azurerm" {
  features {}
  
  # ✅ Use environment variables for authentication
  # These will be set by GitHub Actions from AZURE_CREDENTIALS secret
  use_cli                         = false
  use_msi                         = false
  use_oidc                        = false
  skip_provider_registration      = false
}

# ❌ REMOVED: data "azurerm_client_config" "current" {} 
# This is already defined in main.tf
