variable "resource_prefix" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "create_nsg" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
