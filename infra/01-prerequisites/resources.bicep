param location string
param project string
param tags {
  *: string
}

module acr '../modules/containerRegistry.bicep' = {
  name: 'deploy-${project}-acr'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'containerRegistry.bicep' })
  }
}

module law '../modules/logAnalytics.bicep' = {
  name: 'deploy-${project}-law'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'logAnalytics.bicep' })
  }
}

module acaEnv '../modules/containerAppEnvironment.bicep' = {
  name: 'deploy-${project}-aca-env'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'containerAppEnvironment.bicep' })
    lawName: law.outputs.lawName
  }
}

output acrName string = acr.outputs.acrName
output acaEnvName string = acaEnv.outputs.acaEnvName
