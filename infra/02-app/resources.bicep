param location string
param suffix string
param tags {
  *: string
}

param acrName string
param acaEnvName string
param imageTag string = 'latest'

module aca '../modules/containerApp.bicep' = {
  name: 'deploy-${suffix}-aca'
  params: {
    acaEnvironmentName: acaEnvName
    acrName: acrName
    imageTag: imageTag
    location: location
    suffix: suffix
    tags: union(tags, { module: '01-prerequisites/resources.bicep' })
  }
}
