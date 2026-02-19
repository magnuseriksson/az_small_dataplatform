param vnetName string
param location string

resource nsgPublic 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: '${vnetName}-public-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'databricks-worker-to-databricks-webapp'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'AzureDatabricks'
          destinationPortRanges: ['443', '3306', '8443-8451']
          priority: 100
        }
      }
      {
        name: 'databricks-worker-to-sql'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Sql'
          destinationPortRange: '3306'
          priority: 101
        }
      }
      {
        name: 'databricks-worker-to-eventhub'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'EventHub'
          destinationPortRange: '9093'
          priority: 103
        }
      }
      {
        name: 'databricks-worker-to-storage'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Storage'
          destinationPortRange: '443'
          priority: 104
        }
      }
    ]
  }
}

resource nsgPrivate 'Microsoft.Network/networkSecurityGroups@2025-05-01' = {
  name: '${vnetName}-private-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'databricks-worker-to-databricks-webapp'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'AzureDatabricks'
          destinationPortRanges: ['443', '3306', '8443-8451']
          priority: 100
        }
      }
      {
        name: 'databricks-worker-to-sql'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Sql'
          destinationPortRange: '3306'
          priority: 101
        }
      }
      {
        name: 'databricks-worker-to-eventhub'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'EventHub'
          destinationPortRange: '9093'
          priority: 103
        }
      }
      {
        name: 'databricks-worker-to-storage'
        properties: {
          access: 'Allow'
          direction: 'Outbound'
          protocol: 'Tcp'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: 'Storage'
          destinationPortRange: '443'
          priority: 104
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/18'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_public_subnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  parent:virtualNetwork
  name: 'public'
  properties: {
    addressPrefixes: [
      '10.0.0.0/20'
    ]
    networkSecurityGroup: {
      id: nsgPublic.id
    }
    delegations: [
      {
        name: 'databricks-delegation-public'
        properties: {
          serviceName: 'Microsoft.Databricks/workspaces'
        }
      }
    ]
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}


resource virtualNetworks_private_subnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  parent:virtualNetwork
  name: 'private'
  properties: {
    addressPrefixes: [
      '10.0.32.0/20'
    ]
    networkSecurityGroup: {
      id: nsgPrivate.id
    }
    delegations: [
      {
        name: 'databricks-delegation-private'
        properties: {
          serviceName: 'Microsoft.Databricks/workspaces'
        }
      }
    ]
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

output virtualNetworkId string = virtualNetwork.id
output pubSubnetName string = 'public'
output privSubnetName string = 'private'
