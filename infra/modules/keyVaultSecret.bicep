param tags {
  *: string
}
param vaultName string
param secretName string
@secure()
param secretValue string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: vaultName
}

resource kvSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  name: secretName
  parent: kv
  tags: tags
  properties: {
    value: secretValue
  }
}

output uri string = kvSecret.properties.secretUri
