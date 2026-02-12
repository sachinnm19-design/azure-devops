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

  identity {
    type = "SystemAssigned"
  }

  # App Service Logs Configuration
  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    application_logs {
      file_system_level = "Information"  # Options: Off, Error, Warning, Information, Verbose
    }

    http_logs {
      file_system {
        retention_in_mb   = 35
        retention_in_days = 7
      }
    }
  }

  site_config {
    application_stack {
      docker_image_name   = "${var.image_name}:${var.image_tag}"
      docker_registry_url = "https://${var.acr_login_server}"
    }
    
    # IP restrictions (if provided)
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

  app_settings = merge(
    {
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE"       = "false"
      "APPINSIGHTS_INSTRUMENTATIONKEY"            = var.app_insights_key
      "APPLICATIONINSIGHTS_CONNECTION_STRING"     = var.app_insights_connection_string
      
      # Enhanced Application Insights settings
      "APPLICATIONINSIGHTS_SAMPLING_PERCENTAGE"   = var.environment == "prod" ? "20" : "100"
      "APPINSIGHTS_PROFILER_ENABLED"              = "1"
      "APPINSIGHTS_SNAPSHOT_DEBUGGER_ENABLED"     = "0"
      
      # Application settings
      "ENVIRONMENT"                               = var.environment
      "APP_VERSION"                               = var.image_tag
    },
    var.additional_app_settings
  )

  tags = var.tags
}
