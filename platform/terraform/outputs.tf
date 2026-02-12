output "event_hub_namespace_hostname" {
  value = "${azurerm_eventhub_namespace.evhns.name}.servicebus.windows.net:9093"
}

output "event_hub_name" {
  value = azurerm_eventhub.hub.name
}

output "access_connector_id" {
  value = azurerm_databricks_access_connector.acc.id
}

output "workspace_url" {
  value = azurerm_databricks_workspace.dbks.workspace_url
}
