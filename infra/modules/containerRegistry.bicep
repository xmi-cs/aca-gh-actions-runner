param location string
param project string
param tags {
  *: string
}
@minLength(10)
param uniqueSuffix string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: 'acr${replace(project, '-', '')}${uniqueSuffix}'
  location: location
  tags: tags
  sku: {
    name: 'Basic'
  }
}

output acrName string = acr.name
