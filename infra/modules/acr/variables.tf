variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "sku" {
  type        = string
  description = "SKU for ACR (Basic, Standard, Premium)"
  default     = "Premium"
  
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be Basic, Standard, or Premium"
  }
}

variable "public_access_enabled" {
  type        = bool
  description = "Enable public network access (only works with Premium SKU)"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the ACR"
  default     = {}
}
