@description('The location in which the Event Grid resources should be deployed.')
param location string

@description('The name of the function app storage account.')
param storageAccountName string = 'storg${uniqueString(resourceGroup().id)}'

@description('Resource tagging metadata')
param resourceTags object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  tags: resourceTags
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}

output name string = storageAccount.name
output id string = storageAccount.id
