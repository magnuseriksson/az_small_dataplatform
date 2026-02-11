param location string
param namespaceName string
param eventHubName string
param accessConnectorPrincipalId string = ''

param sku string = 'Standard'

// adding a eventhub-namespace
resource namespace 'Microsoft.EventHub/namespaces@2025-05-01-preview' = {
  name: namespaceName
  location: location
  sku: {
    name: sku
    tier: sku
    capacity: 1
  }
}

// adding an eventhub to the eventhub-namespace
resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2025-05-01-preview' = {
  parent: namespace
  name: eventHubName
  properties: {
    messageRetentionInDays: 1
    partitionCount: 2
  }
}

// adding a role to connect to eventhub for the access connector.
resource accessConnectorEventHubDataReceiverRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = if (!empty(accessConnectorPrincipalId)) {
  name: guid(eventHub.id, accessConnectorPrincipalId, 'Azure Event Hubs Data Receiver')
  scope: eventHub
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a638d3c7-ab3a-418d-83e6-5f17a39d4fde')
    principalId: accessConnectorPrincipalId
    principalType: 'ServicePrincipal'
  }
}

output eventHubNamespaceHostName string = '${namespaceName}.servicebus.windows.net:9093'
output eventHubName string = eventHubName
