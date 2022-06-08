param location string = 'uksouth'
param zoneRedundant bool = false
param appName string = 'petsapp'
param acr string = 'acrdemo49577068.azurecr.io'

@allowed([
  'CapacityReservation'
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard'
])
param lawSku string = 'PerGB2018'

resource appEnv 'Microsoft.App/managedEnvironments@2022-03-01' = {
  name: 'env-${appName}'
  location: location
  properties: {
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: law.properties.customerId
        sharedKey: law.listKeys().primarySharedKey
      }
    }
    zoneRedundant: zoneRedundant
  }
}

resource law 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: 'law-${appName}'
  location: location
  properties: any({
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: lawSku
    }
  })
}

resource app 'Microsoft.App/containerApps@2022-03-01' = {
  name: 'app-${appName}'
  location: location
  identity: {
    type: 'None'
  }
  properties: {
    managedEnvironmentId: appEnv.id
    configuration: {
      activeRevisionsMode: 'multiple'
      ingress: {
        external: true
        targetPort: 80
        transport: 'auto'
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
        allowInsecure: false
      }
    }
    template: {
      revisionSuffix: 'v1'
      containers: [
        {
          image: '${acr}/apps/containerapp:v1'
          name: appName
          resources: {
            cpu: 1
            memory: '2Gi'
          }
        }
      ]
      scale: {
        maxReplicas: 10
      }
    }
  }
}
