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

module resources 'resources.bicep' = {
  name: 'deploy-${suffix}-app-resources'
  params: {
    acaEnvName: acaEnvName
    acrName: acrName
    gitHubAccessToken: gitHubAccessToken
    gitHubOrganization: gitHubOrganization
    imageTag: imageTag
    location: location
    suffix: suffix
    tags: union(resourceGroup().tags, { module: '02-app/resources.bicep' })
  }
}
