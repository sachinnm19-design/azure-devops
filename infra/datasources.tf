data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Check resource provider registration status
data "azurerm_resource_provider_registration" "compute" {
  name = "Microsoft.Compute"
}

data "azurerm_resource_provider_registration" "container_registry" {
  name = "Microsoft.ContainerRegistry"
}
