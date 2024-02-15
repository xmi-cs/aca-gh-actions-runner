param location string = resourceGroup().location
param project string

param acrName string
param acaEnvName string
param imageTag string

param gitHubAppId string
param gitHubAppInstallationId string
@secure()
param gitHubAppKey string
param gitHubOrganization string

module acj '../modules/containerAppJob.bicep' = {
  name: 'deploy-${project}-acj'
  params: {
    acaEnvironmentName: acaEnvName
    acrName: acrName
    gitHubAppId: gitHubAppId
    gitHubAppInstallationId: gitHubAppInstallationId
    gitHubAppKey: gitHubAppKey
    gitHubOrganization: gitHubOrganization
    imageTag: imageTag
    location: location
    project: project
    tags: union(resourceGroup().tags, { module: 'containerAppJob.bicep' })
  }
}
