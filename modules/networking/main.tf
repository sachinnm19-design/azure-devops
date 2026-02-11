# Even if minimal, create a basic networking module
# This can be expanded later for VNets, subnets, etc.

resource "azurerm_network_security_group" "nsg" {
  count               = var.create_nsg ? 1 : 0
  name                = "${var.resource_prefix}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_rule" "https" {
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
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}
