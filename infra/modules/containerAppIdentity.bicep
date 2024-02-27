param location string
param project string

param acrName string
param kvName string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName
}

resource acaMsi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-${project}'
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

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: kvName
}

var secretUserRoleId = '4633458b-17de-408a-b874-0445c86b69e6'
resource kvSecretUser 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(acaMsi.id, kv.id, secretUserRoleId)
  scope: kv
  properties: {
    principalId: acaMsi.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', secretUserRoleId)
    principalType: 'ServicePrincipal'
  }
}

output msiName string = acaMsi.name
