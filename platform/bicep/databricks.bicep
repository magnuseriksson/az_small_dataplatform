param location string
param workspaceName string
param managedResourceGroupId string
param sku string = 'premium'
param vnetId string
param privateSubnetName string
param publicSubnetName string
param accessConnectorName string

resource databricksWorkspace 'Microsoft.Databricks/workspaces@2026-01-01' = {
  name: workspaceName
  location: location
  sku: { name: sku }
  properties: {
    managedResourceGroupId: managedResourceGroupId
    computeMode: 'Hybrid'
    parameters: {
      customVirtualNetworkId: {
        value: vnetId
      }
      customPrivateSubnetName: {
        value: privateSubnetName
      }
      customPublicSubnetName: {
        value: publicSubnetName
      }
      enableNoPublicIp: {
        value: true
      }
    }
  }
}

resource accessConnector 'Microsoft.Databricks/accessConnectors@2026-01-01' = {
  name: accessConnectorName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}

output accessConnectorId string = accessConnector.id
output principalId string = accessConnector.identity.principalId
output workspaceUrl string = databricksWorkspace.properties.workspaceUrl

/**
    Some manual steps need to be done to get the unity-catalog working , since bicep doesnt support this

    1. Create a Metastore (Databricks Account Level)
        You must go to the Databricks Account Console, create a Metastore, and provide:

        * The ADLS Gen2 path (e.g., abfss://container@storageaccount.dfs.core.windows.net/).
        * The Access Connector ID (which is an output in our Bicep script).

    2. Create a Storage Credential (Inside Databricks)
        * Within the Databricks SQL or Data Science workspace, you create a "Storage Credential" object.
        This object tells Databricks: "When you need to talk to Azure Storage, use this Access Connector's identity."

    3. Create an External Location
        * You then create an "External Location" in Databricks that points to your specific storage container
        and uses the Storage Credential created in step 2.

*/