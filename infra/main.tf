############################################
# Resource Group
############################################
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
  }
}

############################################
# Azure Container Registry
############################################
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false  # ✅ CHANGED: Disabled admin credentials
}

############################################
# Key Vault (OPTIONAL - only for other secrets)
############################################
resource "azurerm_key_vault" "kv" {
  name                = "${var.acr_name}-kv"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  depends_on = [
    azurerm_container_registry.acr
  ]
}

############################################
# App Service Plan
############################################
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  os_type  = "Linux"
  sku_name = var.sku_name
}

############################################
# Access Policy for Terraform SPN
############################################
resource "azurerm_key_vault_access_policy" "terraform_spn_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.sp_object_id

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover"
  ]
}

############################################
# Web App with Managed Identity
############################################
resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  # ✅ CRITICAL: System-assigned Managed Identity
  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      docker_image_name   = "${var.image_name}:${var.image_tag}"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
    # ✅ NEW: No docker_registry_username/password needed!
  }

  app_settings = {
    # ✅ CRITICAL: Enable managed identity for ACR
    "DOCKER_REGISTRY_SERVER_URL"      = "https://${azurerm_container_registry.acr.login_server}"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }
}

############################################
# Grant Web App Managed Identity AcrPull Role
############################################
resource "azurerm_role_assignment" "webapp_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_linux_web_app.webapp.identity[0].principal_id

  depends_on = [
    azurerm_linux_web_app.webapp
  ]
}

############################################
# Grant Web App Access to Key Vault (for other secrets)
############################################
resource "azurerm_key_vault_access_policy" "webapp_kv_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.webapp.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List"
  ]

  depends_on = [
    azurerm_linux_web_app.webapp
  ]
}

data "azurerm_client_config" "current" {}
