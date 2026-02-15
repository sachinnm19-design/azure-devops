resource "azurerm_private_endpoint" "acr" {
  name                = "${var.acr_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.acr_name}-psc"
    private_connection_resource_id = var.acr_id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                           = "acr-dns-zone-group"
    private_dns_zone_ids           = [var.acr_private_dns_zone_id]
  }

  tags = var.tags
}
