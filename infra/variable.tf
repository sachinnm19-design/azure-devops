variable "environment" { type = string }
variable "location" { type = string }

variable "resource_group_name" { type = string }
variable "acr_name" { type = string }
variable "app_service_plan_name" { type = string }
variable "webapp_name" { type = string }

variable "sku_name" { type = string }

variable "image_name" { type = string }
variable "image_tag" { type = string }

# Auth (Terraform Cloud workspace variables)
variable "subscription_id" { type = string }
variable "tenant_id" { type = string }
variable "client_id" { type = string }
variable "client_secret" {
  type      = string
  sensitive = true
}
