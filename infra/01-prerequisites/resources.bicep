param location string
param suffix string
param tags {
  *: string
}

module acr '../modules/containerRegistry.bicep' = {
  name: 'deploy-${suffix}-acr'
  params: {
    location: location
    suffix: suffix
    tags: union(tags, { module: 'containerRegistry.bicep' })
  }
}

module acaEnv '../modules/containerAppEnvironment.bicep' = {
  name: 'deploy-${suffix}-aca-env'
  params: {
    location: location
    suffix: suffix
    tags: union(tags, { module: 'containerAppEnvironment.bicep' })
  }
}

output acrName string = acr.outputs.acrName
output acaEnvName string = acaEnv.outputs.acaEnvName
