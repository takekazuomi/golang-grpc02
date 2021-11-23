param environmentName string
param containerAppName string
param containerImage string
param containerPort int
param containerRegistry string
@secure()
param containerRegistryPassword string
param containerRegistryUsername string
param isExternalIngress bool = true
param location string = resourceGroup().location
param minReplicas int = 0
param transport string = 'auto'
param allowInsecure bool = false
param env array = []
param containerOnly bool = false

var environmentId = containerOnly ? environmentExisting.id : environment.outputs.environmentId

resource environmentExisting 'Microsoft.Web/kubeEnvironments@2021-02-01' existing = {
  name: environmentName
}

module environment './environment.bicep' = if(!containerOnly) {
  name: 'environment'
  params: {
    location: location
    environmentName: environmentName
  }
}

module containerApps 'container.bicep' = {
  name: 'containerApps'
  params: {
    location: location
    containerAppName: containerAppName
    containerImage: containerImage
    containerPort: containerPort
    containerRegistry: containerRegistry
    containerRegistryPassword: containerRegistryPassword
    containerRegistryUsername: containerRegistryUsername
    environmentId: environmentId
    isExternalIngress: isExternalIngress
    minReplicas: minReplicas
    transport: transport
    allowInsecure: allowInsecure
    env: env
  }
}
