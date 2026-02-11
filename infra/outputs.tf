output "subscription_id" {
  description = "Current Azure subscription ID"
  value       = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  description = "Current Azure tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}

output "resource_group_id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.rg.id
}

output "resource_group_name" {
  description = "Resource Group name"
  value       = azurerm_resource_group.rg.name
}

output "acr_id" {
  description = "ACR resource ID"
  value       = module.acr.acr_id
}

output "acr_name" {
  description = "ACR name"
  value       = module.acr.acr_name
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = module.acr.acr_login_server
}

output "webapp_id" {
  description = "Web App resource ID"
  value       = module.app_service.webapp_id
}

output "webapp_name" {
  description = "Web App name"
  value       = module.app_service.webapp_name
}

output "webapp_url" {
  description = "Web App default URL"
  value       = "https://${module.app_service.webapp_default_hostname}"
}

output "webapp_principal_id" {
  description = "Web App managed identity principal ID"
  value       = module.app_service.webapp_principal_id
}

output "app_insights_instrumentation_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.app_insights.instrumentation_key
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "Application Insights connection string"
  value       = azurerm_application_insights.app_insights.connection_string
  sensitive   = true
}

output "key_vault_id" {
  description = "Key Vault resource ID"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_uri" {
  description = "Key Vault URI"
  value       = azurerm_key_vault.kv.vault_uri
}
