output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "VNet resource ID"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "VNet name"
}

output "app_service_subnet_id" {
  value       = azurerm_subnet.app_service_subnet.id
  description = "App Service subnet ID"
}

output "private_endpoints_subnet_id" {
  value       = azurerm_subnet.private_endpoints_subnet.id
  description = "Private Endpoints subnet ID"
}

output "acr_private_dns_zone_id" {
  value       = azurerm_private_dns_zone.acr_dns.id
  description = "ACR Private DNS Zone ID"
}

output "app_nsg_id" {
  value       = var.create_nsg ? azurerm_network_security_group.app_nsg[0].id : null
  description = "App Service NSG ID"
}
