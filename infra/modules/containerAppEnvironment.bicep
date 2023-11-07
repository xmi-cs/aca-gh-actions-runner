param location string
param suffix string
param tags {
  *: string
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
