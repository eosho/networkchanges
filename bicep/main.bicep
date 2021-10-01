@description('The name of the Event Grid custom topic.')
param topicName string = 'topic${uniqueString(resourceGroup().id)}'

@description('The Guid of your Azure subscription.')
param subscriptionId string = subscription().id

@description('The name of the function app storage account.')
param storageAccountName string = 'storg${uniqueString(resourceGroup().id)}'

@description('The name of the function app.')
param functionAppName string = 'func${uniqueString(resourceGroup().id)}'

@description('The name of the app insights resource.')
param appServicePlanName string = 'asp${uniqueString(resourceGroup().id)}'

@description('The name of the app insights resource.')
param appInsightsName string = 'appins${uniqueString(resourceGroup().id)}'

@description('The name of the Event Grid custom topic\'s subscription.')
param subscriptionName string = 'networksecuritygroups'

@description('The location in which the Event Grid resources should be deployed.')
param location string = resourceGroup().location

@description('Specify the Event Types to include, defaults to All')
param includedEventTypes array

@description('Resource tagging metadata')
param resourceTags object = {}

@description('Specify an array of advanced filter objects. See https://docs.microsoft.com/en-us/azure/templates/microsoft.eventgrid/2019-01-01/eventsubscriptions#advancedfiltersproperties-object')
param advancedFilters array = []

module appInsights 'modules/appinsights.bicep' = {
  name: appInsightsName
  params: {
    location: location
    resourceTags: resourceTags
  }
}

module storage 'modules/storageaccount.bicep' = {
  name: storageAccountName
  params: {
    location: location
    resourceTags: resourceTags
  }
}

module asp 'modules/appserviceplan.bicep' = {
  name: appServicePlanName
  params: {
    location: location
    resourceTags: resourceTags
  }
}

module eventgrid 'modules/eventgrid-subscription.bicep' = {
  name: topicName
  params: {
    resourceTags: resourceTags
    includedEventTypes: includedEventTypes
    storageAccountResourceId: storage.outputs.id
    subscriptionName: subscriptionName
    subscriptionId: subscriptionId
    advancedFilters: advancedFilters
  }
}

module functionapp 'modules/functionapp.bicep' = {
  name: functionAppName
  params: {
    resourceTags: resourceTags
    appInsightsComponentsId: appInsights.outputs.id
    appServicePlanId: asp.outputs.id
    location: location
  }
}
