variable "environment" {
  type        = string
  description = "The name of the environment for the deployment (e.g., 'dev', 'staging', 'prod')."
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be deployed (e.g., 'eastus', 'westus2')."
  default     = "eastus"
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
  default     = "B1"
}

variable "image_name" {
  type        = string
  description = "The name of the container image to be deployed in the Azure Web App."
  default     = "demo-app"
}

variable "image_tag" {
  type        = string
  description = "The tag used to identify the version of the container image (e.g., 'latest', 'v1.0.0')."
  default     = "latest"
}

variable "sp_object_id" {
  type        = string
  description = "Object ID of the Service Principal used by Terraform"
}

# Removed unused variables
# variable "key_vault_name" - not needed, we derive it from acr_name
# variable "key_vault_access_policy" - not needed, we manage it explicitly
