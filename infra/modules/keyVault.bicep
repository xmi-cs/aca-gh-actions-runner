param location string
param project string
param tags {
  *: string
}
@minLength(10)
param uniqueSuffix string

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: take('kv-${project}-${uniqueSuffix}', 24)
  location: location
  tags: tags
  properties: {
    enableRbacAuthorization: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId    
  }
}

output name string = kv.name
