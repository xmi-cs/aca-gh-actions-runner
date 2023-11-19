targetScope = 'subscription'

@minLength(1)
@description('Primary location for all resources')
param location string

var project = 'aca-gh-runners'

var tags = {
  project: project
  repo: 'aca-gh-actions-runner'
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${project}'
  location: location
  tags: tags
}

module resources 'resources.bicep' = {
  scope: rg
  name: 'deploy-${project}-prerequisites-resources'

  params: {
    location: location
    tags: union(tags, { module: '01-prerequisites/resources.bicep' })
    project: project
  }
}

output project string = project
output acrName string = resources.outputs.acrName
output acaEnvName string = resources.outputs.acaEnvName
output rgName string = rg.name
