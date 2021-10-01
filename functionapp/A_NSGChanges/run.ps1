<#
  .SYNOPSIS
  A_NSGChanges is an activity function that handles network security group changes

  .DESCRIPTION
  A_NSGChanges is an activity function that handles network security group changes

  .PARAMETER QueueItem
  The incoming Queue Item

  .PARAMETER TriggerMetadata
  The TriggerMetadata with the Queue Item

  .EXAMPLE
  .\run.ps1
#>

param (
  [Parameter()]
  $QueueItem,

  [Parameter()]
  $TriggerMetadata
)

Write-Information -MessageData "Received request to record network security group changes"

# initialize storage context for the operations storage table
Write-Information -MessageData "Setting Azure Storage context"
$stContext = New-AzStorageContext -ConnectionString $env:AzureWebJobsStorage
Write-Information -MessageData "Connected to storage account '$($stContext.StorageAccountName)'"

# change history dates - set to look at the last 60 minutes
# there is no clean way to collect this info. They could be a lot of changes on a resource within the same threshold

# could use correlationId to query activity log api to also get resource changes
$startDate = $(Get-Date).AddMinutes(-600).ToUniversalTime().ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'")
$endDate = $(Get-Date).ToUniversalTime().ToString("yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'fff'Z'")

$queueItemData = ($QueueItem.data | ConvertTo-Json | ConvertFrom-Json)
$subscriptionId = $queueItemData.subscriptionId
$resourceUri = $queueItemData.resourceUri
$resourceType = $queueItemData.authorization.action
$changedBy = $queueItemData.claims."http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"

# Hack to construct resource Id to change history api
if ($resourceUri -match "/subscriptions/(.+)/resourceGroups/(.+)/providers"){
  $prefix = "/subscriptions/$($matches[1])/resourceGroups/$($matches[2])"
  $resourceProvider = "/providers/$($resourceUri.Split('/')[6])/$($resourceUri.Split('/')[7])"
  $resourceName = "/$($resourceUri.Split('/')[8])"
  $resourceId = $prefix + $resourceProvider + $resourceName
}

# construct change history api payload
$changeHistoryPayload = @"
{
  "resourceId": "$($resourceId)",
  "interval": {
      "start": "$($startDate)",
      "end": "$($endDate)"
  },
  "fetchPropertyChanges": true
}
"@

# construct change history REST API url
$url = 'https://management.azure.com/providers/Microsoft.ResourceGraph/resourceChanges?api-version=2018-09-01-preview'

$result = Invoke-AzNetworkRestMethod -Method 'POST' -Uri $url -Body $changeHistoryPayload
$changes = $result.InvokeResult.changes

# NOT clean
# filter out changes with etag related data - these results are not useful
# we only care about property changes on a resource
# maybe create a pscustomobject for this data and convert to json for storing in table

# also filter out system changes
foreach ($change in $changes) {
  if ($change.propertyChanges.changeCategory -ne "System") {
    foreach ($property in $change.propertyChanges) {
      if ($property.propertyName -notlike "*.etag") { # there could be additional properties to filter out
        $changedProperty = $property.propertyName
        $beforeValue = $property.beforeValue
        $afterValue = $property.afterValue
        $propertyChangeType = $property.propertyChangeType
      }
    }
  } else {
    "This is a system change- do we care?? hmmmm"
  }
}

# push all outputs to a table storage for web app consumption
Write-Information -MessageData "Creating output binding to storage table"
Push-OutputBinding -Name TableBinding -Value @{
  PartitionKey    = 'networkchanges'
  RowKey          = "$($QueueItem.id)"
  Subscription    = $subscriptionId
  ResourceId      = $resourceUri
  ResourceType    = $resourceType
  ChangedProperty = $changedProperty
  ChangedBy       = $changedBy
  BeforeValue     = $beforeValue
  AfterValue      = $afterValue
  ChangeType      = $propertyChangeType
  RawPayload      = "$($QueueItem.data | ConvertTo-Json)"
  Operation       = "nsgchange"
}
