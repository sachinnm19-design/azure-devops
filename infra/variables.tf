variable "environment" {
  type        = string
  description = "The name of the environment for the deployment (e.g., 'dev', 'staging', 'prod')."
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be deployed (e.g., 'eastus', 'westus2')."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the Azure Resource Group where all resources will be created."
}

variable "acr_name" {
  type        = string
  description = "The name of the Azure Container Registry to be created or referenced."
}

variable "app_service_plan_name" {
  type        = string
  description = "The name of the App Service Plan for deploying the web application."
}

variable "webapp_name" {
  type        = string
  description = "The name of the Azure Web App to be created within the App Service Plan."
}

variable "sku_name" {
  type        = string
  description = "The SKU name for the App Service Plan (e.g., 'B1', 'P1V2'). Determines performance and pricing."
}

variable "image_name" {
  type        = string
  description = "The name of the container image to be deployed in the Azure Web App."
}

variable "image_tag" {
  type        = string
  description = "The tag used to identify the version of the container image (e.g., 'latest', 'v1.0.0')."
}

variable "sp_object_id" {
  type        = string
  description = "Object ID of the Service Principal used by Terraform"
}

variable "ip_restrictions" {
  type = list(object({
    ip_address = string
  }))
  default     = []
  description = "List of IP addresses allowed to access the web app"
}

# ✅ NEW - Key Vault Configuration Variables
variable "enable_key_vault_protection" {
  type        = bool
  description = "Enable purge protection and soft delete for Key Vault"
  default     = true
}

variable "key_vault_sku" {
  type        = string
  description = "SKU for Key Vault (standard or premium)"
  default     = "standard"
  
  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "Key Vault SKU must be 'standard' or 'premium'"
  }
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Number of days to retain soft deleted items in Key Vault"
  default     = 90
  
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention must be between 7 and 90 days"
  }
}

variable "enable_purge_protection" {
  type        = bool
  description = "Enable purge protection on Key Vault"
  default     = true
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault (must be 3-24 alphanumeric characters, no consecutive hyphens)"
}
