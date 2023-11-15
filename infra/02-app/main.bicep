@minLength(1)
@description('Primary location for all resources')
param location string = resourceGroup().location
param suffix string

param acrName string
param acaEnvName string
param imageTag string

@secure()
param gitHubAccessToken string
param gitHubOrganization string

param gitHubAppId string
param gitHubInstallationId string
@secure()
param gitHubAppPrivateKey string

module resources 'resources.bicep' = {
  name: 'deploy-${suffix}-app-resources'
  params: {
    acaEnvName: acaEnvName
    acrName: acrName
    gitHubAccessToken: gitHubAccessToken
    gitHubOrganization: gitHubOrganization
    gitHubAppId: gitHubAppId
    gitHubInstallationId: gitHubInstallationId
    gitHubAppPrivateKey: gitHubAppPrivateKey
    imageTag: imageTag
    location: location
    suffix: suffix
    tags: union(resourceGroup().tags, { module: '02-app/resources.bicep' })
  }
}
