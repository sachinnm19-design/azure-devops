resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
  }
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_key_vault" "kv" {
  name                = "${var.acr_name}-kv"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  depends_on = [azurerm_container_registry.acr]
}

resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  os_type  = "Linux"
  sku_name = var.sku_name
}

# Step 1: Create the Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      docker_image_name        = "${var.image_name}:${var.image_tag}"
      docker_registry_url      = "https://${azurerm_container_registry.acr.login_server}"
      docker_registry_username = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.kv.name};SecretName=acr-admin-username)"
      docker_registry_password = "@Microsoft.KeyVault(VaultName=${azurerm_key_vault.kv.name};SecretName=acr-admin-password)"
    }
  }

  app_settings = {
    WEBSITES_PORT = "3000"
    "AzureWebJobsSecretStorageType" = "keyvault"
  }

  https_only = true
}

# Step 2: Create the Access Policy for the Web App's Managed Identity
resource "azurerm_key_vault_access_policy" "webapp" {
  depends_on = [azurerm_linux_web_app.webapp] # Ensure the webapp is created first

  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.webapp.identity[0].principal_id # Dynamically fetch the object_id of the Web App's identity

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_role_assignment" "acr_pull_webapp" {
  depends_on = [azurerm_linux_web_app.webapp] # Ensure the webapp is created first
  scope                = azurerm_container_registry.acr.id # Assign permissions at the ACR level
  role_definition_name = "AcrPull"                         # Provide the AcrPull role
  principal_id         = azurerm_linux_web_app.webapp.identity[0].principal_id # Use Web App’s Managed Identity
}

data "azurerm_client_config" "current" {}
