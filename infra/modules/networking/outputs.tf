output "nsg_id" {
  value = var.create_nsg ? azurerm_network_security_group.nsg[0].id : null
}

output "nsg_name" {
  value = var.create_nsg ? azurerm_network_security_group.nsg[0].name : null
}
