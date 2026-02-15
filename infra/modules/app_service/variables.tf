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

variable "app_insights_key" {
  type        = string
  default     = ""
  description = "Application Insights instrumentation key"
}

variable "app_insights_connection_string" {
  type        = string
  default     = ""
  description = "Application Insights connection string"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
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
  description = "Additional app settings"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to resources"
}

variable "app_service_subnet_id" {
  type        = string
  description = "Subnet ID for App Service VNET integration"
  default     = null
}
