output "event_hub_namespace_hostname" {
  value = module.eventhub.event_hub_namespace_hostname
}

output "event_hub_name" {
  value = module.eventhub.event_hub_name
}

output "access_connector_id" {
  value = module.databricks.access_connector_id
}

output "workspace_url" {
  value = module.databricks.workspace_url
}
