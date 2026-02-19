resource "azurerm_eventhub_namespace" "evhns" {
  name                = "${var.prefix}-evhns-${local.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "hub" {
  name                = "ingest-hub"
  namespace_name      = azurerm_eventhub_namespace.evhns.name
  resource_group_name  = azurerm_resource_group.rg.name
  partition_count     = 2
  message_retention   = 1
}

# Role Assignment for Databricks Workspace
# to eventhub

resource "azurerm_role_assignment" "acc_eventhub_receiver" {
  scope                = azurerm_eventhub.hub.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = azurerm_databricks_access_connector.acc.identity[0].principal_id
}
