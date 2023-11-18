param location string = resourceGroup().location
param suffix string

param acrName string
param acaEnvName string
param imageTag string

@secure()
param gitHubAccessToken string
param gitHubOrganization string

module aca '../modules/containerApp.bicep' = {
  name: 'deploy-${suffix}-aca'
  params: {
    acaEnvironmentName: acaEnvName
    acrName: acrName
    gitHubAccessToken: gitHubAccessToken
    gitHubOrganization: gitHubOrganization
    imageTag: imageTag
    location: location
    suffix: suffix
    tags: union(resourceGroup().tags, { module: '01-prerequisites/resources.bicep' })
  }
}
