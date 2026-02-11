############################################
# Resource Group
############################################
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

############################################
# Application Insights
############################################
resource "azurerm_application_insights" "app_insights" {
  name                = "${var.webapp_name}-insights"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"

  tags = {
    environment = var.environment
  }
}

############################################
# ACR Module
############################################
module "acr" {
  source = "./modules/acr"

  acr_name                  = var.acr_name
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = var.location
  sku                       = "Premium"  # CHANGED: Must be Premium to disable public access
  public_access_enabled     = false      # CHANGED: Now we can disable public access

  tags = {
    environment = var.environment
  }
}

############################################
# Networking Module
############################################
module "networking" {
  source = "./modules/networking"

  resource_prefix     = var.webapp_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  create_nsg          = true

  tags = {
    environment = var.environment
  }
}

############################################
# App Service Module
############################################
module "app_service" {
  source = "./modules/app_service"

  app_service_plan_name = var.app_service_plan_name
  webapp_name           = var.webapp_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  sku_name              = var.sku_name
  image_name            = var.image_name
  image_tag             = var.image_tag
  acr_login_server      = module.acr.acr_login_server
  
  app_insights_key               = azurerm_application_insights.app_insights.instrumentation_key
  app_insights_connection_string = azurerm_application_insights.app_insights.connection_string
  
  ip_restrictions = var.ip_restrictions

  tags = {
    environment = var.environment
  }
}

############################################
# Key Vault
############################################
resource "azurerm_key_vault" "kv" {
  name                = "${var.acr_name}-kv"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enable_rbac_authorization = false
  purge_protection_enabled  = false

  tags = {
    environment = var.environment
  }
}

############################################
# Key Vault Access Policies
############################################
resource "azurerm_key_vault_access_policy" "terraform_spn_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.sp_object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Purge"
  ]
}

resource "azurerm_key_vault_access_policy" "webapp_kv_access" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.app_service.webapp_principal_id

  secret_permissions = ["Get", "List"]
}

############################################
# Role Assignments
############################################
resource "azurerm_role_assignment" "webapp_acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.app_service.webapp_principal_id
}
