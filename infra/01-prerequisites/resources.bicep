param location string
param project string
param tags {
  *: string
}

@secure()
param gitHubAppKey string

var uniqueSuffix = uniqueString(subscription().id, location, project)

module acr '../modules/containerRegistry.bicep' = {
  name: '${deployment().name}-acr'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'containerRegistry.bicep' })
    uniqueSuffix: uniqueSuffix
  }
}

module law '../modules/logAnalytics.bicep' = {
  name: '${deployment().name}-law'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'logAnalytics.bicep' })
  }
}

module acaEnv '../modules/containerAppEnvironment.bicep' = {
  name: '${deployment().name}-aca-env'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'containerAppEnvironment.bicep' })
    lawName: law.outputs.lawName
  }
}

module keyVault '../modules/keyVault.bicep' = {
  name: '${deployment().name}-kv'
  params: {
    location: location
    project: project
    tags: union(tags, { module: 'keyVault.bicep' })
    uniqueSuffix: uniqueSuffix
  }
}

module keyVaultGitHubAppKey '../modules/keyVaultSecret.bicep' = {
  name: '${deployment().name}-kv-github-app-key'
  params: {
    secretName: 'key-github-app'
    secretValue: gitHubAppKey
    tags: union(tags, {module: 'keyVaultSecret.bicep'})
    vaultName: keyVault.outputs.name
  }
}

output acrName string = acr.outputs.acrName
output acaEnvName string = acaEnv.outputs.acaEnvName
output gitHubAppKeySecretUri string = keyVaultGitHubAppKey.outputs.uri
