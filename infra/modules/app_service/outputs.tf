output "webapp_id" {
  value = azurerm_linux_web_app.webapp.id
}

output "webapp_name" {
  value = azurerm_linux_web_app.webapp.name
}

output "webapp_default_hostname" {
  value = azurerm_linux_web_app.webapp.default_hostname
}

output "webapp_principal_id" {
  value = azurerm_linux_web_app.webapp.identity[0].principal_id
}

output "webapp_tenant_id" {
  value = azurerm_linux_web_app.webapp.identity[0].tenant_id
}

output "app_service_plan_id" {
  value = azurerm_service_plan.asp.id
}
