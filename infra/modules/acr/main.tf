resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  admin_enabled                 = false
  public_network_access_enabled = false  # ✅ Keep PRIVATE by default

  tags = var.tags
}

# ✅ NEW: Network Rule Set with Allow default (so it works when temporarily enabled)
resource "azurerm_container_registry_network_rule_set" "acr_rules" {
  container_registry_id = azurerm_container_registry.acr.id
  default_action        = "Allow"  # ✅ KEY: Allow all IPs when public is enabled
  
  # No IP restrictions - when public is enabled, GitHub Actions can push
  # When public is disabled, only private endpoints work
}
