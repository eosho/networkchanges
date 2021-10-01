@description('The name of the function app.')
param functionAppName string = 'func${uniqueString(resourceGroup().id)}'

@description('The location in which the Event Grid resources should be deployed.')
param location string

@description('The name of the function app storage account.')
param storageAccountName string = 'storg${uniqueString(resourceGroup().id)}'

@description('The resource Id for your app service plan.')
param appServicePlanId string

@description('The resource Id for application insights.')
param appInsightsComponentsId string

@description('Resource tagging metadata')
param resourceTags object = {}

resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: storageAccountName
}

resource azureFunction 'Microsoft.Web/sites@2021-01-15' = {
  name: functionAppName
  location: location
  tags: resourceTags
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsDashboard'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys('${storageaccount.id}', '2019-06-01').key1}'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys('${storageaccount.id}', '2019-06-01').key1}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${listKeys('${storageaccount.id}', '2019-06-01').key1}'
        }
        {
          name: 'EventHubConnection'
          value: ''
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower('${storageAccountName}')
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference('${appInsightsComponentsId}', '2015-05-01').InstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'powershell'
        }
      ]
    }
  }
}

output name string = azureFunction.name
output id string = azureFunction.id
