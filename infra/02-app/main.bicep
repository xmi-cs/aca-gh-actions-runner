param location string = resourceGroup().location
param project string

param acrName string
param acaEnvName string
param imageTag string

param gitHubAppId string
param gitHubAppInstallationId string
param gitHubAppKeySecretUri string
param gitHubOrganization string

module aca '../modules/containerApp.bicep' = {
  name: 'deploy-${project}-aca'
  params: {
    acaEnvironmentName: acaEnvName
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
