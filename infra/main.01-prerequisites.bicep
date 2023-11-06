targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

var project = 'aca-gh-runners'
var suffix = '${environmentName}-${project}'

var tags = {
  'azd-env-name': environmentName
  project: project
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${suffix}'
  location: location
  tags: tags
}



output rgName string = rg.name
