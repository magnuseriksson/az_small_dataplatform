resource "azurerm_resource_group" "rg" {
  name     = "rg-dataplat-${var.env}-3"
  location = var.location
}

resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  suffix = "${random_id.suffix.hex}-${var.env}"
}

module "databricks" {
  source = "./modules/databricks"

  workspace_name              = "${var.prefix}-dbks-${local.suffix}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  managed_resource_group_name = "rg-dbks-managed-rg-${local.suffix}"
}

module "eventhub" {
  source = "./modules/eventhub"

  name                           = "ingest-hub"
  namespace_name                 = "${var.prefix}-evhns-${local.suffix}"
  location                       = azurerm_resource_group.rg.location
  resource_group_name            = azurerm_resource_group.rg.name
  access_connector_principal_id  = module.databricks.access_connector_principal_id
}
