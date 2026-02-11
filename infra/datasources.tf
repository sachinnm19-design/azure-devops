data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Get resource providers if needed
data "azurerm_resource_provider" "compute" {
  name = "Microsoft.Compute"
}

data "azurerm_resource_provider" "container_registry" {
  name = "Microsoft.ContainerRegistry"
}
