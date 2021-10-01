<#
  .SYNOPSIS
  O_Process EventGrid is an orchestrator function that receives incoming EventGrid events and process them

  .DESCRIPTION
  O_Process EventGrid is an orchestrator function that receives incoming EventGrid events and process them

  .PARAMETER EventGridEvent
  The incoming EventGrid event

  .PARAMETER TriggerMetadata
  The TriggerMetadata with the EventGrid event

  .EXAMPLE
  .\run.ps1
#>

param (
  [Parameter()]
  $EventGridEvent,

  [Parameter()]
  $TriggerMetadata
)

Write-Information -MessageData "Received event '$($EventGridEvent.id)' for request: $($EventGridEvent.data | Out-String)"

Write-Information -MessageData "Setting Azure Storage context"
$stContext = New-AzStorageContext -ConnectionString $env:AzureWebJobsStorage
Write-Information -MessageData "Connected to storage account '$($stContext.StorageAccountName)'"

# route events based on operation to the appropriate queue for processing
if ($EventGridEvent.data.operationName -in @("Microsoft.Network/networkSecurityGroups/securityRules/write", "Microsoft.Network/networkSecurityGroups/securityRules/delete")) {
  Write-Information -MessageData "Creating output binding to storage queue 'networkchanges'"
  Push-OutputBinding -Name "networkchanges" -Value $EventGridEvent
}
