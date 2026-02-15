output "private_endpoint_id" {
  description = "Private Endpoint ID"
  value       = azurerm_private_endpoint.acr.id
}

output "private_endpoint_name" {
  description = "Private Endpoint Name"
  value       = azurerm_private_endpoint.acr.name
}
