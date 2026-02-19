variable "name" {
  description = "Name of the Event Hub"
  type        = string
}

variable "namespace_name" {
  description = "Name of the Event Hub Namespace"
  type        = string
}

variable "location" {
  description = "The location for the resource group and all resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group to create."
  type        = string
}

variable "sku" {
  description = "The SKU of the Event Hub Namespace"
  type        = string
  default     = "Standard"
}

variable "capacity" {
  description = "The capacity of the Event Hub Namespace"
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "The partition count of the Event Hub"
  type        = number
  default     = 2
}

variable "message_retention" {
  description = "The message retention of the Event Hub"
  type        = number
  default     = 1
}

variable "access_connector_principal_id" {
  description = "The principal ID of the Databricks Access Connector"
  type        = string
}
