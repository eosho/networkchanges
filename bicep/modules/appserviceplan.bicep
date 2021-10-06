@description('The name of the app insights resource.')
param appServicePlanName string = 'asp${uniqueString(resourceGroup().id)}'

@description('The location of the app service plan.')
param location string

@description('Resource tagging metadata')
param resourceTags object = {}

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: appServicePlanName
  tags: resourceTags
  location: location
  sku: {
    name: 'F1'
    capacity: 1
  }
}

output name string = appServicePlan.name
output id string = appServicePlan.id
