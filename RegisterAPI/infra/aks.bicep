param location string = resourceGroup().location
param aksName string = 'aks-myapi'
param acrResourceId string
param namespaceList array = [ 'dev', 'uat', 'prod' ]

resource aks 'Microsoft.ContainerService/managedClusters@2023-01-01' = {
  name: aksName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: 'dns-${aksName}'
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        vmSize: 'Standard_B2s'
        count: 1
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
    enableRBAC: true
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(aks.identity.principalId, acrResourceId, 'acrpull')
  properties: {
    principalId: aks.identity.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')
    scope: acrResourceId
  }
}

@batch(resourceGroup = resourceGroup().name)
module namespaces 'kubernetes-namespace.bicep' = [for ns in namespaceList: {
  name: 'create-${ns}-namespace'
  scope: resourceGroup()
  params: {
    name: ns
  }
}]

output aksName string = aks.name
