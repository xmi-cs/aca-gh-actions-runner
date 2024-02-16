param location string
param project string
param tags {
  *: string
}

@secure()
param gitHubAppKey string

var uniqueSuffix = uniqueString(subscription().id, location, project)

module acr '../modules/containerRegistry.bicep' = {
  name: 'deploy-${project}-acr'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'containerRegistry.bicep' })
    uniqueSuffix: uniqueSuffix
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

module keyVault '../modules/keyVault.bicep' = {
  name: 'deploy-${project}-kv'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'keyVault.bicep' })
    uniqueSuffix: uniqueSuffix
  }
}

module keyVaultGitHubAppKey '../modules/keyVaultKey.bicep' = {
  name: 'deploy-${project}-kv-github-app-key'
  params: {
    keyName: 'key-github-app'
    keyValue: gitHubAppKey
    location: location
    project: project
    tags: union(tags, {module: 'keyVaultKey.bicep'})
    vaultName: keyVault.outputs.name
  }
}

output acrName string = acr.outputs.acrName
output acaEnvName string = acaEnv.outputs.acaEnvName
