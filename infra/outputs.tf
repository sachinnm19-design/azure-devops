output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "webapp_name" {
  value = azurerm_linux_web_app.webapp.name
}

# ✅ NEW: Output managed identity details
output "webapp_principal_id" {
  description = "Principal ID of the Web App's managed identity"
  value       = azurerm_linux_web_app.webapp.identity[0].principal_id
}

output "webapp_tenant_id" {
  description = "Tenant ID of the Web App's managed identity"
  value       = azurerm_linux_web_app.webapp.identity[0].tenant_id
}
