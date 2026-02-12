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

  site_config {
    application_stack {
      docker_image_name   = "${var.image_name}:${var.image_tag}"
      docker_registry_url = "https://${var.acr_login_server}"
    }
    
    # IP restrictions (if provided)
    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        ip_address = "${ip_restriction.value.ip_address}/32"  # ADD /32 HERE
        action     = "Allow"
      }
    }
    
	ip_restriction_default_action = length(var.ip_restrictions) > 0 ? "Deny" : "Allow"
	
    minimum_tls_version = "1.2"
  }

  app_settings = merge(
    {
      "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
      "APPINSIGHTS_INSTRUMENTATIONKEY"      = var.app_insights_key
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
    },
    var.additional_app_settings
  )

  tags = var.tags
}
