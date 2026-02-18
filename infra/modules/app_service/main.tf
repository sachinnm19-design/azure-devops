resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.sku_name
  
  tags = var.tags
}

resource "azurerm_linux_web_app" "webapp" {
  name                = var.webapp_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id
  https_only          = true

  # ✅ System-Assigned Managed Identity (for ACR access)
  identity {
    type = "SystemAssigned"
  }

  site_config {

    container_registry_use_managed_identity = true
    # ✅ Docker configuration via application_stack
    application_stack {
      docker_image_name   = "${var.image_name}:${var.image_tag}"
      docker_registry_url = "https://${var.acr_login_server}"
      # ✅ NO username/password - Managed Identity will handle authentication
    }
    
    # IP restrictions
    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        ip_address = "${ip_restriction.value.ip_address}/32"
        action     = "Allow"
        priority   = 100
        name       = "AllowSpecificIP"
      }
    }
    
    ip_restriction_default_action = length(var.ip_restrictions) > 0 ? "Deny" : "Allow"
    
    # SCM (Deployment) IP restrictions
    dynamic "scm_ip_restriction" {
      for_each = var.ip_restrictions
      content {
        ip_address = "${scm_ip_restriction.value.ip_address}/32"
        action     = "Allow"
        priority   = 100
        name       = "AllowSpecificIPSCM"
      }
    }
    
    scm_ip_restriction_default_action = length(var.ip_restrictions) > 0 ? "Deny" : "Allow"
    
    # Health check configuration
    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 5
    
    # Security settings
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
  }

  # ✅ App Settings
  app_settings = merge(
    {
      "APPLICATIONINSIGHTS_CONNECTION_STRING"     = var.app_insights_connection_string
      "APPINSIGHTS_INSTRUMENTATIONKEY"            = var.app_insights_key
      "AZURE_TENANT_ID"                           = var.tenant_id
      "AZURE_SUBSCRIPTION_ID"                     = var.subscription_id
    },
  )

  tags = var.tags
}
