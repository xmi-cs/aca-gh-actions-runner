param location string = resourceGroup().location
param project string

param useJobs bool = true

param acrName string
param acaEnvName string
param acaMsiName string
param imageTag string

param gitHubAppId string
param gitHubAppInstallationId string
param gitHubAppKeySecretUri string
param gitHubOrganization string

module acj '../modules/containerAppJob.bicep' = if (useJobs) {
  name: '${deployment().name}-job'
  params: {
    acaEnvironmentName: acaEnvName
    acaMsiName: acaMsiName
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

module aca '../modules/containerApp.bicep' = if (!useJobs) {
  name: '${deployment().name}-aca'
  params: {
    acaEnvironmentName: acaEnvName
    acaMsiName: acaMsiName
    acrName: acrName
    gitHubAppId: gitHubAppId
    gitHubAppInstallationId: gitHubAppInstallationId
    gitHubAppKeySecretUri: gitHubAppKeySecretUri
    gitHubOrganization: gitHubOrganization
    imageTag: imageTag
    location: location
    project: project
    tags: union(resourceGroup().tags, { module: 'containerApp.bicep' })
  }
}
