param location string = resourceGroup().location
param project string

param acrName string
param acaEnvName string
param imageTag string

@secure()
param gitHubAccessToken string
param gitHubOrganization string

param useJobs bool = true

module acj '../modules/containerAppJob.bicep' = if (useJobs) {
  name: 'deploy-${project}-acj'
  params: {
    acaEnvironmentName: acaEnvName
    acrName: acrName
    gitHubAccessToken: gitHubAccessToken
    gitHubOrganization: gitHubOrganization
    imageTag: imageTag
    location: location
    project: project
    tags: union(resourceGroup().tags, { module: 'containerAppJob.bicep' })
  }
}

module aca '../modules/containerApp.bicep' = if (!useJobs) {
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
