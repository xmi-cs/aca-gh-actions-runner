param location string
param suffix string
param tags {
  *: string
}

param acrName string
param acaEnvName string
param imageTag string = 'latest'

@secure()
param gitHubAccessToken string
param gitHubOrganization string

@secure()
param gitHubAppPrivateKey string

module aca '../modules/containerApp.bicep' = {
  name: 'deploy-${suffix}-aca'
  params: {
    acaEnvironmentName: acaEnvName
    acrName: acrName
    gitHubAccessToken: gitHubAccessToken
    gitHubOrganization: gitHubOrganization
    gitHubAppPrivateKey: gitHubAppPrivateKey
    imageTag: imageTag
    location: location
    suffix: suffix
    tags: union(tags, { module: '01-prerequisites/resources.bicep' })
  }
}
