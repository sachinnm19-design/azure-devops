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
# ACR Module - ✅ NOW USES VARIABLE
############################################
module "acr" {
  source = "./modules/acr"

  acr_name              = var.acr_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  sku                   = "Premium"
  public_access_enabled = var.acr_public_access_enabled  # ✅ FROM VARIABLE (controlled by pipeline)

  tags = {
    environment = var.environment
  }
}

############################################
# Networking Module - ✅ UPDATED WITH VNET VARS
############################################
module "networking" {
  source = "./modules/networking"

  resource_prefix              = var.webapp_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  create_nsg                   = true
  vnet_address_space           = var.vnet_address_space           # ✅ NEW
  app_service_subnet_prefix    = var.app_service_subnet_prefix    # ✅ NEW
  private_endpoint_subnet_prefix = var.private_endpoint_subnet_prefix  # ✅ NEW

  tags = {
    environment = var.environment
  }
}

############################################
# Private Endpoint Module - ✅ NEW
############################################
module "private_endpoint" {
  source = "./modules/private_endpoint"

  acr_name                  = var.acr_name
  acr_id                    = module.acr.acr_id
  location                  = var.location
  resource_group_name       = azurerm_resource_group.rg.name
  private_endpoint_subnet_id = module.networking.private_endpoints_subnet_id
  acr_private_dns_zone_id   = module.networking.acr_private_dns_zone_id

  tags = {
    environment = var.environment
  }

  depends_on = [module.acr, module.networking]
}

############################################
# App Service Module - ✅ UPDATED WITH VNET INTEGRATION
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
  app_service_subnet_id = module.networking.app_service_subnet_id  # ✅ NEW
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

  depends_on = [module.networking, module.acr]  # ✅ NEW
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
