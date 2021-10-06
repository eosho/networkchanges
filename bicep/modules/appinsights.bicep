@description('The name of the app insights resource.')
param appInsightsName string = 'appins${uniqueString(resourceGroup().id)}'

@description('The location of the app insights resource.')
param location string

@description('Resource tagging metadata')
param resourceTags object = {}

resource appInsightsComponents 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: location
  tags: resourceTags
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output name string = appInsightsComponents.name
output id string = appInsightsComponents.id
