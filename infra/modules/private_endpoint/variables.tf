variable "acr_name" {
  type        = string
  description = "ACR name"
}

variable "acr_id" {
  type        = string
  description = "ACR resource ID"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "private_endpoint_subnet_id" {
  type        = string
  description = "Subnet ID for private endpoint"
}

variable "acr_private_dns_zone_id" {
  type        = string
  description = "Private DNS Zone ID for ACR"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
