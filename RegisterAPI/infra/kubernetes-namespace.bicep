param name string

resource k8sNs 'Microsoft.ContainerService/managedClusters/namespaces@2023-01-01-preview' = {
  name: name
  scope: resourceGroup()
  properties: {}
}
