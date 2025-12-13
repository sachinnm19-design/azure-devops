# ---------------------------
# Resource Group
# ---------------------------
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}


# ---------------------------
# Azure Container Registry
# ---------------------------
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"

  # For Managed Identity authentication, admin creds must be disabled
  admin_enabled = true

  depends_on = [
    azurerm_resource_group.rg
  ]
}


# ---------------------------
# App Service Plan (Linux)
# ---------------------------
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location

  os_type  = "Linux"
  sku_name = "S1"  # Use S1; B1 sometimes fails in UK South due to capacity issues

  depends_on = [
    azurerm_resource_group.rg
  ]
}


# ---------------------------
# Web App for Containers
# ---------------------------
resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      docker_image_name     = "${var.image_name}:${var.image_tag}"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
	  docker_registry_username = "${azurerm_container_registry.acr.admin_username}"
	  docker_registry_password = "${azurerm_container_registry.acr.admin_password}"
    }
  }

  app_settings = {
    WEBSITES_PORT = "3000"
  }

  https_only = true

  depends_on = [
    azurerm_service_plan.asp,
    azurerm_container_registry.acr
  ]
}
