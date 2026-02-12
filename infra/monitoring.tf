############################################
# Application Insights Alerts
############################################

# Alert for high error rate
resource "azurerm_monitor_metric_alert" "high_error_rate" {
  name                = "${var.webapp_name}-high-error-rate"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_application_insights.app_insights.id]
  description         = "Alert when error rate exceeds 5%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  enabled             = var.environment == "prod" ? true : false

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "requests/failed"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 5
  }

  tags = {
    environment = var.environment
  }
}

# Alert for slow response time
resource "azurerm_monitor_metric_alert" "slow_response" {
  name                = "${var.webapp_name}-slow-response"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_application_insights.app_insights.id]
  description         = "Alert when response time exceeds 2 seconds"
  severity            = 3
  frequency           = "PT5M"
  window_size         = "PT15M"
  enabled             = var.environment == "prod" ? true : false

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "requests/duration"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 2000  # milliseconds
  }

  tags = {
    environment = var.environment
  }
}

# Alert for health check failures
resource "azurerm_monitor_metric_alert" "health_check_failed" {
  name                = "${var.webapp_name}-health-check-failed"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [module.app_service.webapp_id]
  description         = "Alert when health check fails"
  severity            = 1
  frequency           = "PT1M"
  window_size         = "PT5M"
  enabled             = var.environment == "prod" ? true : false

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "HealthCheckStatus"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 100
  }

  tags = {
    environment = var.environment
  }
}

# Alert for high CPU usage
resource "azurerm_monitor_metric_alert" "high_cpu" {
  name                = "${var.webapp_name}-high-cpu"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [module.app_service.webapp_id]
  description         = "Alert when CPU usage exceeds 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  enabled             = var.environment == "prod" ? true : false

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  tags = {
    environment = var.environment
  }
}

# Alert for high memory usage
resource "azurerm_monitor_metric_alert" "high_memory" {
  name                = "${var.webapp_name}-high-memory"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [module.app_service.webapp_id]
  description         = "Alert when memory usage exceeds 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  enabled             = var.environment == "prod" ? true : false

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "MemoryPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  tags = {
    environment = var.environment
  }
}
