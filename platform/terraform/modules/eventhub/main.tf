resource "azurerm_eventhub_namespace" "evhns" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity
}

resource "azurerm_eventhub" "hub" {
  name                = var.name
  namespace_id        = azurerm_eventhub_namespace.evhns.id
  partition_count     = var.partition_count
  message_retention   = var.message_retention
}

resource "azurerm_role_assignment" "acc_eventhub_receiver" {
  scope                = azurerm_eventhub.hub.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = var.access_connector_principal_id
}
