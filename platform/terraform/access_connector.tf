resource "azurerm_databricks_access_connector" "acc" {
  name                = "${var.prefix}-acc-${local.suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }
}
