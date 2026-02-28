resource "azurerm_resource_group" "main" {
  name     = "${local.prefix}-rg-01"
  location = var.location
  tags     = local.tags
}

resource "azurerm_static_web_app" "main" {
  name                = "${local.prefix}-stapp-01"
  resource_group_name = azurerm_resource_group.main.name
  location            = "westeurope"
  sku_tier            = "Free"
  sku_size            = "Free"

  tags = local.tags
}
