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
# Bicep's authorizations[0].principalId corresponds to the workspace's identity.
# In Terraform with azurerm, the workspace identity is often accessible through managed identity 
# or specific attributes. For the storage account identity used for UC, we use storage_account_identity.
# However, for general workspace identity, if it's not explicitly enabled, we might need to use 
# the workspace_id or similar, but the most accurate for "managed identity" is the identity block.

# Since Bicep was using the first authorization principal, we assume it's the system identity.
resource "azurerm_role_assignment" "dbks_eventhub_receiver" {
  scope                = azurerm_eventhub.hub.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  # Using the storage_account_identity as it's the one most commonly used for integrations
  # If a system managed identity is enabled on the workspace itself, we would use dbks.identity[0].principal_id
  principal_id         = azurerm_databricks_workspace.dbks.storage_account_identity[0].principal_id
}

# Role Assignment for the Access Connector
resource "azurerm_role_assignment" "acc_eventhub_receiver" {
  scope                = azurerm_eventhub.hub.id
  role_definition_name = "Azure Event Hubs Data Receiver"
  principal_id         = azurerm_databricks_access_connector.acc.identity[0].principal_id
}
