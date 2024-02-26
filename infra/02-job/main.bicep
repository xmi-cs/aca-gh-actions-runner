param location string = resourceGroup().location
param project string

param acrName string
param acaEnvName string
param imageTag string

param gitHubAppId string
param gitHubAppInstallationId string
param gitHubAppKeySecretUri string
param gitHubOrganization string

var kvName = replace(substring(gitHubAppKeySecretUri, 0, indexOf(gitHubAppKeySecretUri, '.')), 'https://', '')
module msi '../modules/containerAppIdentity.bicep' = {
  name: '${deployment().name}-msi'
  params: {
    acrName: acrName
    kvName: kvName
    location: location
    project: project
  }
}

module acj '../modules/containerAppJob.bicep' = {
  name: '${deployment().name}-job'
  params: {
    acaEnvironmentName: acaEnvName
    acaMsiId: msi.outputs.resourceId
    acaMsiClientId: msi.outputs.clientId
    acrName: acrName
    gitHubAppId: gitHubAppId
    gitHubAppInstallationId: gitHubAppInstallationId
    gitHubAppKeySecretUri: gitHubAppKeySecretUri
    gitHubOrganization: gitHubOrganization
    imageTag: imageTag
    location: location
    project: project
    tags: union(resourceGroup().tags, { module: 'containerAppJob.bicep' })
  }
}
