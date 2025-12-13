variable "location" {
  default = "uksouth"
}

variable "resource_group_name" {
  default = "devops-demo-rg"
}

variable "acr_name" {
  default = "devopsdemoacr9999" # MUST BE UNIQUE
}

variable "app_service_plan" {
  default = "devops-demo-asp"
}

variable "webapp_name" {
  default = "devops-demo-webapp9999" # MUST BE UNIQUE
}

variable "image_name" {
  default = "demo-app"
}

variable "image_tag" {
  default = "latest"
}
