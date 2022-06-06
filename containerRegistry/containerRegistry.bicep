param randomSuffix int
param acrName string = 'acrdemo${randomSuffix}'
param location string = resourceGroup().location
param anonymousPullEnabled bool = false
param adminUserEnabled bool = false

@allowed([
  'Basic'
  'Classic'
  'Standard'
  'Premium'
])
param acrSku string = 'Basic'

resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: acrSku
  }
  properties: {
    adminUserEnabled: adminUserEnabled
    anonymousPullEnabled: anonymousPullEnabled
  }
}

@description('Output the login server property for later use')
output loginServer string = acr.properties.loginServer
