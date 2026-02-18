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
# Log Analytics Workspace
############################################
resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.webapp_name}-law"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = var.environment
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
  workspace_id        = azurerm_log_analytics_workspace.law.id

  tags = {
    environment = var.environment
  }
}

############################################
# ACR Module
############################################
module "acr" {
  source = "./modules/acr"

  acr_name              = var.acr_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  sku                   = "Premium"  # ✅ Premium for better features
  public_access_enabled = true       # ✅ PUBLIC

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
  environment           = var.environment
  
  app_insights_key               = azurerm_application_insights.app_insights.instrumentation_key
  app_insights_connection_string = azurerm_application_insights.app_insights.connection_string
  
  ip_restrictions = [
    {
      ip_address = "90.204.44.55"
    }
  ]

  tags = {
    environment = var.environment
  }
}

############################################
# Role Assignments for ACR (RBAC)
############################################

# ✅ Allow Web App Managed Identity to pull images from ACR
resource "azurerm_role_assignment" "webapp_acr_pull" {
  scope              = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id       = module.app_service.webapp_principal_id
  
  description = "Allow Web App to pull container images from ACR using Managed Identity"
}

# ✅ Allow GitHub Actions Service Principal to push images in ACR
resource "azurerm_role_assignment" "github_actions_acr_push" {
  scope              = module.acr.acr_id
  role_definition_name = "AcrPush"
  principal_id       = var.sp_object_id
  
  skip_service_principal_aad_check = true
  description = "Allow GitHub Actions to push container images to ACR"
}
