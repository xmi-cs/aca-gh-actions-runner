param location string
param project string
param tags {
  *: string
}

var uniqueSuffix = uniqueString(subscription().id, location, project)
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: 'acr${replace(project, '-', '')}${uniqueSuffix}'
  location: location
  tags: tags
  sku: {
    name: 'Basic'
  }
}

output acrName string = acr.name
