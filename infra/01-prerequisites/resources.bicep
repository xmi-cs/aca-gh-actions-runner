param location string
param suffix string
param tags {
  *: string
}

module acr '../modules/containerRegistry.bicep' = {
  name: 'deploy-${suffix}-acr'
  params: {
    location: location
    suffix: suffix
    tags: union(tags, { module: 'containerRegistry.bicep' })
  }
}
