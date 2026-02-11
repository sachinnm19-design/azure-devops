resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  admin_enabled                 = false
  public_network_access_enabled = false

  # Allow Azure services and resources to access this registry
  network_rule_bypass_option = "AzureServices"

  tags = var.tags
}
