variable "app_service_plan_name" {
  type        = string
  description = "Name of the App Service Plan"
}

variable "webapp_name" {
  type        = string
  description = "Name of the Web App"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region location"
}

variable "sku_name" {
  type        = string
  description = "SKU name for App Service Plan (e.g., B1, P1V2)"
}

variable "image_name" {
  type        = string
  description = "Docker image name"
}

variable "image_tag" {
  type        = string
  description = "Docker image tag"
}

variable "acr_login_server" {
  type        = string
  description = "ACR login server URL"
}

# ✅ NEW: Key Vault Name - Required for KeyVault references
variable "key_vault_name" {
  type        = string
  description = "Name of the Azure Key Vault containing secrets (without .vault.azure.net)"
}

# ✅ OPTIONAL: Key Vault Resource Group (if different from app RG)
variable "key_vault_resource_group_name" {
  type        = string
  default     = ""
  description = "Resource group name of Key Vault (defaults to current RG if empty)"
}

variable "app_insights_key" {
  type        = string
  default     = ""
  description = "Application Insights instrumentation key (can be empty if using Key Vault)"
}

variable "app_insights_connection_string" {
  type        = string
  default     = ""
  description = "Application Insights connection string (can be empty if using Key Vault)"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
}

# ✅ Tenant ID from Azure AD
variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID from data source azurerm_client_config - Used for Azure AD authentication"
}

# ✅ Subscription ID from Azure
variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID from data source azurerm_subscription - Used for resource management"
}

variable "ip_restrictions" {
  type = list(object({
    ip_address = string
  }))
  default     = []
  description = "List of IP addresses allowed to access the web app"
}

variable "additional_app_settings" {
  type        = map(string)
  default     = {}
  description = "Additional app settings (application-specific key-value pairs)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}
