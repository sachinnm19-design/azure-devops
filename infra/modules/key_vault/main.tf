# New module: infra/modules/key_vault/main.tf

resource "azurerm_key_vault" "kv" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = var.tenant_id
  sku_name                   = "standard"
  enabled_for_disk_encryption = false
  purge_protection_enabled   = true
  soft_delete_retention_days = 90

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.webapp_principal_id

    secret_permissions = [
      "Get",
      "List",
    ]
  }

  tags = var.tags
}

# Store secrets
resource "azurerm_key_vault_secret" "app_insights_key" {
  name         = "AppInsightsInstrumentationKey"
  value        = var.app_insights_key
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "app_insights_conn_string" {
  name         = "AppInsightsConnectionString"
  value        = var.app_insights_connection_string
  key_vault_id = azurerm_key_vault.kv.id
}
