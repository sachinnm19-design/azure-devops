variable "app_service_plan_name" {
  type = string
}

variable "webapp_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku_name" {
  type = string
}

variable "image_name" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "acr_login_server" {
  type = string
}

variable "app_insights_key" {
  type    = string
  default = ""
}

variable "app_insights_connection_string" {
  type    = string
  default = ""
}

variable "ip_restrictions" {
  type = list(object({
    ip_address = string
  }))
  default = []
}

variable "additional_app_settings" {
  type    = map(string)
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
