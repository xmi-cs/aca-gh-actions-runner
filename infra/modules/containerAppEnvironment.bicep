param location string
param project string
param tags {
  *: string
}
param lawName string

resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: lawName
}

resource acaEnv 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: 'cae-${project}'
  location: location
  tags: tags
  properties: {
    workloadProfiles: [
      {
        name: 'Consumption'
        workloadProfileType: 'Consumption'
      }
    ]
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: law.properties.customerId
        sharedKey: law.listKeys().primarySharedKey
      }
    }
  }
}

output acaEnvName string = acaEnv.name
