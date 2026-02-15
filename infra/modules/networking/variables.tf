variable "resource_prefix" {
  type        = string
  description = "Prefix for all resources"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "create_nsg" {
  type        = bool
  description = "Whether to create Network Security Group"
  default     = true
}

variable "vnet_address_space" {
  type        = string
  description = "Address space for VNet"
  default     = "10.0.0.0/16"
}

variable "app_service_subnet_prefix" {
  type        = string
  description = "Address prefix for App Service subnet"
  default     = "10.0.1.0/24"
}

variable "private_endpoint_subnet_prefix" {
  type        = string
  description = "Address prefix for private endpoints subnet"
  default     = "10.0.2.0/24"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
