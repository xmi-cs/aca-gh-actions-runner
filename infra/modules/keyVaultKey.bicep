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

// TODO: Use a deployment script to import the key

