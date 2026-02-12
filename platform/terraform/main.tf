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
