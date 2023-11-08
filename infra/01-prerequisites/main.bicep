targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environment string

@minLength(1)
@description('Primary location for all resources')
param location string

var project = 'aca-gh-runners'
var suffix = '${environment}-${project}'

var tags = {
  environment: environment
  project: project
  repo: 'aca-gh-actions-runner'
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${suffix}'
  location: location
  tags: tags
}

module resources 'resources.bicep' = {
  scope: rg
  name: 'deploy-${suffix}-prerequisites-resources'

  params: {
    location: location
    tags: union(tags, { module: '01-prerequisites/resources.bicep' })
    suffix: suffix
  }
}
