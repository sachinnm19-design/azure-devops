############################################
# Application Insights Alerts
############################################

# Alert for high error rate (using requests/failed metric)
resource "azurerm_monitor_metric_alert" "high_error_rate" {
  name                = "${var.webapp_name}-high-error-rate"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_application_insights.app_insights.id]
  description         = "Alert when failed request count exceeds threshold"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  enabled             = var.environment == "prod" ? true : false

  criteria {
    metric_namespace = "microsoft.insights/components"
    metric_name      = "requests/failed"
    aggregation      = "Count"  # Changed from Average to Count
    operator         = "GreaterThan"
    threshold        = 10  # More than 10 failed requests
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
  description         = "Alert when average response time exceeds 2 seconds"
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

# Alert for high CPU usage (corrected metric name for Linux App Service)
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
    metric_name      = "CpuTime"  # Changed from CpuPercentage
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 120  # 120 seconds of CPU time in 15 minutes
  }

  tags = {
    environment = var.environment
  }
}

# Alert for high memory usage (corrected metric name for Linux App Service)
resource "azurerm_monitor_metric_alert" "high_memory" {
  name                = "${var.webapp_name}-high-memory"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [module.app_service.webapp_id]
  description         = "Alert when memory usage exceeds threshold"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  enabled             = var.environment == "prod" ? true : false

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "MemoryWorkingSet"  # Changed from MemoryPercentage
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 1073741824  # 1GB in bytes
  }

  tags = {
    environment = var.environment
  }
}

# Alert for HTTP server errors (5xx)
resource "azurerm_monitor_metric_alert" "http_5xx_errors" {
  name                = "${var.webapp_name}-http-5xx-errors"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [module.app_service.webapp_id]
  description         = "Alert when HTTP 5xx errors exceed threshold"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"
  enabled             = var.environment == "prod" ? true : false

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http5xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 10
  }

  tags = {
    environment = var.environment
  }
}

# Alert for response time (App Service metric)
resource "azurerm_monitor_metric_alert" "response_time" {
  name                = "${var.webapp_name}-response-time"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [module.app_service.webapp_id]
  description         = "Alert when average response time exceeds threshold"
  severity            = 3
  frequency           = "PT5M"
  window_size         = "PT15M"
  enabled             = var.environment == "prod" ? true : false

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "AverageResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 2  # 2 seconds
  }

  tags = {
    environment = var.environment
  }
}
