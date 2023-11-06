param location string
param suffix string
param tags {
  *: string
}

var uniqueSuffix = uniqueString(subscription().id, location, suffix)
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: 'acr${replace(suffix, '-', '')}${uniqueSuffix}'
  location: location
  tags: tags
  sku: {
    name: 'Basic'
  }
}
