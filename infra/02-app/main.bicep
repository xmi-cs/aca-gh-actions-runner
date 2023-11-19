param location string = resourceGroup().location
param project string

param acrName string
param acaEnvName string
param imageTag string

@secure()
param gitHubAccessToken string
param gitHubOrganization string

module aca '../modules/containerApp.bicep' = {
  name: 'deploy-${project}-aca'
  params: {
    acaEnvironmentName: acaEnvName
    acrName: acrName
    gitHubAccessToken: gitHubAccessToken
    gitHubOrganization: gitHubOrganization
    imageTag: imageTag
    location: location
    project: project
    tags: union(resourceGroup().tags, { module: 'containerApp.bicep' })
  }
}
