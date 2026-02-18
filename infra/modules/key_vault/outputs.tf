output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_name" {
  description = "The name of the Key Vault"
  value       = azurerm_key_vault.kv.name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.kv.vault_uri
}

output "app_insights_instrumentation_key_secret_id" {
  description = "The ID (URI) of the Application Insights Instrumentation Key secret"
  value       = azurerm_key_vault_secret.app_insights_instrumentation_key.id
}

output "app_insights_connection_string_secret_id" {
  description = "The ID (URI) of the Application Insights Connection String secret"
  value       = azurerm_key_vault_secret.app_insights_connection_string.id
}
