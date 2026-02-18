resource "azurerm_key_vault" "kv" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = var.sku_name
  enabled_for_disk_encryption = false
  purge_protection_enabled   = var.enable_purge_protection
  soft_delete_retention_days = var.soft_delete_retention_days

  tags = var.tags
}

# ✅ Grant Web App Managed Identity access to Key Vault (only if principal_id provided)
resource "azurerm_key_vault_access_policy" "webapp_access" {
  count = var.webapp_principal_id != "" ? 1 : 0  # ✅ Only create if principal_id is not empty
  
  key_vault_id       = azurerm_key_vault.kv.id
  tenant_id          = var.tenant_id
  object_id          = var.webapp_principal_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

# ✅ Store Application Insights Instrumentation Key
resource "azurerm_key_vault_secret" "app_insights_instrumentation_key" {
  name         = "AppInsightsInstrumentationKey"
  value        = var.app_insights_instrumentation_key
  key_vault_id = azurerm_key_vault.kv.id

  tags = var.tags
}

# ✅ Store Application Insights Connection String
resource "azurerm_key_vault_secret" "app_insights_connection_string" {
  name         = "AppInsightsConnectionString"
  value        = var.app_insights_connection_string
  key_vault_id = azurerm_key_vault.kv.id

  tags = var.tags
}
