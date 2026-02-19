output "workspace_url" {
  value = azurerm_databricks_workspace.dbks.workspace_url
}

output "access_connector_id" {
  value = azurerm_databricks_access_connector.acc.id
}

output "access_connector_principal_id" {
  value = azurerm_databricks_access_connector.acc.identity[0].principal_id
}
