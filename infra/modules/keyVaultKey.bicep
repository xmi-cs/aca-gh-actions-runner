param location string
param project string
param tags {
  *: string
}
param vaultName string
param keyName string
@secure()
param keyValue string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: vaultName
}

resource msi 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'id-${project}-depscript'
  location: location
  tags: tags
}

var keyVaultCryptoOfficerRoleId = '14b46e9e-c2b7-41b4-b07b-48a6ebf60603'
resource keyVaultCryptoOfficeAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  scope: kv
  name: guid(msi.id, keyVaultCryptoOfficerRoleId, kv.id)
  properties: {
    principalId: msi.properties.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', keyVaultCryptoOfficerRoleId)
  }
}

resource importKeyScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'depscript-${project}-import-key'
  location: location
  tags: tags
  kind: 'AzureCLI'

  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${msi.id}': {}
    }
  }

  dependsOn: [ keyVaultCryptoOfficeAssignment ]

  properties: {
    azCliVersion: '2.54.0'
    retentionInterval: 'PT1H'

    environmentVariables: [
      {
        name: 'KV_NAME'
        value: kv.name
      }
      {
        name: 'KEY_NAME'
        value: keyName
      }
      {
        name: 'KEY_PEM_VALUE'
        secureValue: keyValue
      }
    ]

    scriptContent: '''
az keyvault key import --vault-name "$KV_NAME" -n "$KEY_NAME" --pem-string "$KEY_PEM_VALUE" 
'''
  }
}
