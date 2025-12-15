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

resource "azurerm_key_vault_access_policy" "terraform_spn_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.sp_object_id  # Pass the SPN Object ID to Terraform.

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
	"Recover"
  ]

  depends_on = [
    azurerm_key_vault.kv
  ]
}

resource "azurerm_key_vault_secret" "acr_username" {
  name         = "acr-admin-username"
  value        = azurerm_container_registry.acr.admin_username
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_container_registry.acr,
    azurerm_key_vault_access_policy.terraform_spn_access
  ]
}

resource "azurerm_key_vault_secret" "acr_password" {
  name         = "acr-admin-password"
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = azurerm_key_vault.kv.id

  depends_on = [
    azurerm_container_registry.acr,
    azurerm_key_vault_access_policy.terraform_spn_access
  ]
}

resource "azurerm_key_vault_access_policy" "webapp" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.sp_object_id # WebApp Managed Identity

  secret_permissions = [
    "Get",
    "List"
  ]

  depends_on = [
    azurerm_key_vault_secret.acr_username,
    azurerm_key_vault_secret.acr_password
  ]
}

resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  os_type  = "Linux"
  sku_name = var.sku_name
}

resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  # Enable Managed Identity for the Web App
  identity {
    type = "SystemAssigned"
  }

  site_config {
    application_stack {
      docker_image_name        = "${var.image_name}:${var.image_tag}"
      docker_registry_url      = "https://${azurerm_container_registry.acr.login_server}"
      docker_registry_username = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.acr_username.id})"
      docker_registry_password = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.acr_password.id})"
    }
  }

  app_settings = {
    WEBSITES_PORT = "3000"
    "AzureWebJobsSecretStorageType" = "keyvault"
  }

  https_only = true

  depends_on = [
    azurerm_key_vault_access_policy.webapp
  ]
}

data "azurerm_client_config" "current" {}
