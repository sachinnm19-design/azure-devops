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

# Additions for Key Vault
variable "key_vault_name" {
  type        = string
  default     = "" # Default to be provided during runtime
  description = "The name of the Azure Key Vault to be created for storing sensitive credentials such as ACR admin secrets."
}

variable "key_vault_access_policy" {
  type        = list(object({
    object_id   = string
    permissions = list(string)
  }))
  default = []
  description = "A list of access policies specifying the object IDs and permissions for users or components accessing the Azure Key Vault."
}
variable "sp_object_id" {
  description = "Object ID of the Service Principal used by Terraform"
}
