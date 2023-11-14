param location string
param project string
param tags {
  *: string
}

resource law 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'log-${project}'
  location: location
  tags: tags

  properties: {
    features: {
      immediatePurgeDataOn30Days: true
    }
    retentionInDays: 30
    sku: {
      name: 'PerGB2018'
    }
  }
}

output lawName string = law.name
