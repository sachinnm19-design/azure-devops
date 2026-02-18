variable "key_vault_name" {
  type        = string
  description = "Name of the Azure Key Vault"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region location"
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID"
}

variable "webapp_principal_id" {
  type        = string
  description = "Principal ID of the Web App Managed Identity for Key Vault access"
  default     = ""  # ✅ Add default to make it optional
}

variable "app_insights_instrumentation_key" {
  type        = string
  description = "Application Insights instrumentation key"
  sensitive   = true
}

variable "app_insights_connection_string" {
  type        = string
  description = "Application Insights connection string"
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the Key Vault"
  default     = {}
}

variable "enable_purge_protection" {
  type        = bool
  description = "Enable purge protection for the Key Vault"
  default     = true
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Number of days to retain soft deleted items"
  default     = 90
}

variable "sku_name" {
  type        = string
  description = "SKU for Key Vault (standard or premium)"
  default     = "standard"
  
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "SKU must be standard or premium"
  }
}
