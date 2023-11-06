param location string
param suffix string
param tags {
  *: string
}
param imageTag string = ''
@allowed(['0.25', '0.5', '0.75', '1.0', '1.25', '1.5', '1.75', '2.0'])
param containerCpu string = '0.25'
@allowed(['0.5Gi', '1.0Gi', '1.5Gi', '2.0Gi', '2.5Gi', '3.0Gi', '3.5Gi', '4.0Gi'])
param containerMemory string = '0.5Gi'

var uniqueSuffix = uniqueString(subscription().id, location, suffix)
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: 'acr${replace(suffix, '-', '')}${uniqueSuffix}'
  location: location
  tags: tags
  sku: {
    name: 'Basic'
  }
}

resource acaEnv 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: 'cae-${suffix}'
  location: location
  tags: tags
  properties: {
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
  }
}

resource acaMsi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-${suffix}'
  location: location
}

var acrPullId = '7f951dda-4ed3-4680-a7ca-43fe172d538d'
resource acaAcrPull 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acaMsi.id, acr.id, acrPullId)
  scope: acr
  properties: {
    principalId: acaMsi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', acrPullId)
    principalType: 'ServicePrincipal'
  }
}

resource acaApp 'Microsoft.App/containerApps@2023-05-01' = {
  name: 'ca-${suffix}'
  location: location
  tags: tags
  properties: {
    managedEnvironmentId: acaEnv.id
    configuration: {
      activeRevisionsMode: 'Single'
      registries: [
        // {
        //   server: acr.properties.loginServer
        //   identity: acaMsi.id
        // }
      ]
    }
    template: {
      containers: [
        {
          name: 'github-runner'
          image: imageTag != '' ?  '${acr.properties.loginServer}/runners/github/linux:${imageTag}' : 'mcr.microsoft.com/azuredocs/containerapps-helloworld:latest'
          resources: {
            cpu: json(containerCpu)
            memory: containerMemory
          }
        }
      ]
    }
  }

  dependsOn: [
    acaAcrPull
  ]
}

output acr string = acr.properties.loginServer
