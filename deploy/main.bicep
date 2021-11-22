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

module environment './environment.bicep' = {
  name: 'environment'
  params: {
    location: location
    environmentName: environmentName
  }
}

module httpApps 'container.bicep' = {
  name: 'httpApps'
  params: {
    location: location
    containerAppName: containerAppName
    containerImage: containerImage
    containerPort: containerPort
    containerRegistry: containerRegistry
    containerRegistryPassword: containerRegistryPassword
    containerRegistryUsername: containerRegistryUsername
    environmentId: environment.outputs.environmentId
    isExternalIngress: isExternalIngress
    minReplicas: minReplicas
    transport: transport
    allowInsecure: allowInsecure
    env: env
  }
}
