@description('The name of the Event Grid custom topic.')
param topicName string = 'topic${uniqueString(resourceGroup().id)}'

@description('The Guid of your Azure subscription.')
param subscriptionId string

@description('The name of the Event Grid custom topic\'s subscription.')
param subscriptionName string = 'networksecuritygroups'

@description('Specify the storage account used for event grid')
param storageAccountResourceId string

@description('Specify the Event Types to include, defaults to All')
param includedEventTypes array

@description('When subject filtering is required, specify where it should begin with')
param subjectBeginsWith string = ''

@description('When subject filtering is required, specify where it should end with')
param subjectEndsWith string = ''

@description('When subject filtering is required, specify if the subject matching should be case sensitive (insensitive by default)')
param isSubjectCaseSensitive bool = false

@description('Resource tagging metadata')
param resourceTags object = {}

@description('Specify an array of advanced filter objects. See https://docs.microsoft.com/en-us/azure/templates/microsoft.eventgrid/2019-01-01/eventsubscriptions#advancedfiltersproperties-object')
param advancedFilters array = []

resource topic 'Microsoft.EventGrid/systemTopics@2021-06-01-preview' = {
  name: topicName
  tags: resourceTags
  location: 'global'
  properties: {
    source: subscriptionId
    topicType: 'Microsoft.Resources.Subscriptions'
  }
}

resource subscription 'Microsoft.EventGrid/systemTopics/eventSubscriptions@2021-06-01-preview' = {
  parent: topic
  name: subscriptionName
  properties: {
    destination: {
      endpointType: 'StorageQueue'
      properties: {
        queueName: 'eventgrid'
        resourceId: storageAccountResourceId
      }
    }
    filter: {
      subjectBeginsWith: subjectBeginsWith
      subjectEndsWith: subjectEndsWith
      isSubjectCaseSensitive: isSubjectCaseSensitive
      includedEventTypes: includedEventTypes
      advancedFilters: advancedFilters
      eventDeliverySchema: 'EventGridSchema'
    }
  }
}
