# ✅ Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.resource_prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# ✅ Subnet for App Service Delegation
resource "azurerm_subnet" "app_service_subnet" {
  name                 = "${var.resource_prefix}-app-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.app_service_subnet_prefix]

  delegation {
    name = "appServiceDelegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# ✅ Subnet for Private Endpoints
resource "azurerm_subnet" "private_endpoints_subnet" {
  name                 = "${var.resource_prefix}-pe-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.private_endpoint_subnet_prefix]

  private_endpoint_network_policies_enabled = true
}

# ✅ Network Security Group
resource "azurerm_network_security_group" "app_nsg" {
  count               = var.create_nsg ? 1 : 0
  name                = "${var.resource_prefix}-app-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "allow_https" {
  count                       = var.create_nsg ? 1 : 0
  name                        = "allow-https"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app_nsg[0].name
}

resource "azurerm_subnet_network_security_group_association" "app_subnet_nsg" {
  count                     = var.create_nsg ? 1 : 0
  subnet_id                 = azurerm_subnet.app_service_subnet.id
  network_security_group_id = azurerm_network_security_group.app_nsg[0].id
}

# ✅ Private DNS Zone for ACR
resource "azurerm_private_dns_zone" "acr_dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# ✅ Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "acr_dns_link" {
  name                  = "${var.resource_prefix}-acr-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.acr_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  tags = var.tags
}
