resource "azurerm_monitor_diagnostic_setting" "webapp_diagnostics" {
  name                       = "${var.webapp_name}-diagnostics"
  target_resource_id         = module.app_service.webapp_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log {
    category = "AppServiceHTTPLogs"
  }

  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
