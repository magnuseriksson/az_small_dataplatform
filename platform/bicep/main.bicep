targetScope = 'subscription'

@description('environment name , dev,stage,prod...')
param env string = 'dev'

@description('The location for the resource group and all resources.')
param location string = 'northeurope'

@description('The name of the resource group to create.')
param resourceGroupName string = 'rg-dataplat-${env}-5'

@description('Prefix for resource names.')
param prefix string = 'myproject'

// First create the Resource Group
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

var uniqueSuffix = '${uniqueString(rg.id)}-${env}'


module vnet './databricks_vnet.bicep' = {
  name: 'VnetDeploy'
  scope: rg
  params: {
    location: location
    vnetName: '${prefix}-vnet-${uniqueSuffix}'
  }
}


module databricks './databricks.bicep' = {
  name: 'databricksDeploy'
  scope: rg
  params: {
    location: location
    workspaceName: '${prefix}-dbks-${uniqueSuffix}'
    managedResourceGroupId: subscriptionResourceId('Microsoft.Resources/resourceGroups', 'rg-dbks-managed-rg-${uniqueSuffix}')
    vnetId : vnet.outputs.virtualNetworkId
    publicSubnetName : vnet.outputs.pubSubnetName
    privateSubnetName : vnet.outputs.privSubnetName
    accessConnectorName: '${prefix}-acc-${uniqueSuffix}'
  }
}

module eventhub './eventhub.bicep' = {
  name: 'eventhubDeploy'
  scope: rg
  params: {
    location: location
    namespaceName: '${prefix}-evhns-${uniqueSuffix}'
    eventHubName: 'ingest-hub'
    accessConnectorPrincipalId: databricks.outputs.principalId
  }
}

output eventHubNamespaceHostName string = eventhub.outputs.eventHubNamespaceHostName
output eventHubName string = eventhub.outputs.eventHubName
output accessConnectorId string = databricks.outputs.accessConnectorId
