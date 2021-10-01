#requires -module @{ModuleName = 'Az.Compute'; ModuleVersion = '1.6.0'}
#requires -version 6.2

<#
  .SYNOPSIS
  Get a Token to work against Azure ARM API

  .DESCRIPTION
  Get a Token to work against Azure ARM API. When MSI is detected, a token will be resolved
  using MSI endpoint and secret, if no MSI is detected, the Az.Accounts context will be tried.

  .EXAMPLE
  Get-AzNetworkToken
#>
function Get-AzNetworkToken {
  Write-Information -MessageData "Fetching access token to execute Azure Resource Manager REST API request"
  if ($env:MSI_SECRET) {
    # when run on azure web app / function
    $msiArgs = @{
      Method          = 'Get'
      Headers         = @{
        'Secret' = $env:MSI_SECRET
      }
      Uri             = $env:MSI_ENDPOINT + '?resource=https://management.azure.com/&api-version=2017-09-01'
      UseBasicParsing = $true
      ErrorAction     = 'Stop'
    }
    Write-Debug -Message "Processing HTTP GET request to '$($msiArgs.Uri)' with the following information: $($msiArgs | ConvertTo-Json)" -Debug
    $token = Invoke-RestMethod @msiArgs

    [pscustomobject]@{
      AccessToken = $token.access_token
      ExpiresOn   = [DateTimeOffset] $token.expires_on
    }
  } else {
    #when run locally, assume already and request using az.accounts module
    Write-Information -MessageData "Obtaining authentication metadata from local PowerShell session"
    $currentAzureContext = Get-AzContext
    if ($null -eq $currentAzureContext.Subscription.TenantId) {
      Write-Error "No Azure context found. Use 'Connect-AzAccount' to create a context or 'Set-AzContext' to select subscription" -ErrorAction Stop
    }
    $azureRmProfile = [Microsoft.Azure.Commands.Common.Authentication.Abstractions.AzureRmProfileProvider]::Instance.Profile
    $profileClient = [Microsoft.Azure.Commands.ResourceManager.Common.RMProfileClient]::new($azureRmProfile)
    $token = $profileClient.AcquireAccessToken($currentAzureContext.Subscription.TenantId)
    Write-Information -MessageData "Fetched access token with expiration at '$($token.ExpiresOn)'"

    [pscustomobject]@{
      AccessToken = $token.AccessToken
      ExpiresOn   = $token.ExpiresOn
    }
  }
}

<#
  .SYNOPSIS
  Get a Token to work against Azure Key Vault API

  .DESCRIPTION
  Get a Token to work against Azure Key Vault API. When MSI is detected, a token will be resolved
  using MSI endpoint and secret, if no MSI is detected, an error is generated.

  .EXAMPLE
  Get-AzNetworkKeyVaultToken

    .NOTES
  Documentation - How to use managed identities for App Service and Azure Functions:
  https://docs.microsoft.com/nl-nl/azure/app-service/overview-managed-identity
#>
function Get-AzNetworkKeyVaultToken {
  if (!$env:MSI_SECRET) {
    Write-Error -Message "Managed identity secret could not be found as an environment variable" -ErrorAction Stop
  }

  # when run on azure web app / function
  $msiArgs = @{
    Method          = 'GET'
    Headers         = @{
      'Secret' = $env:MSI_SECRET
    }
    Uri             = $env:MSI_ENDPOINT + '?resource=https://vault.azure.net&api-version=2017-09-01'
    UseBasicParsing = $true
    ErrorAction     = 'Stop'
  }
  $token = Invoke-RestMethod @msiArgs

  [pscustomobject]@{
    AccessToken = $token.access_token
    ExpiresOn   = [DateTimeOffset] $token.expires_on
  }
}

<#
  .SYNOPSIS
  Invokes a Rest call to azure and adds the token to header parameter

  .DESCRIPTION
  Invokes a Rest call to azure and adds the token to header parameter

  .PARAMETER Method
  The method of the rest call

  .PARAMETER Uri
  The uri of the rest call

  .PARAMETER Body
  The body of the rest call as a json string

  .EXAMPLE
  Invoke-AzNetworkRestMethod -Body $body -Method 'Put' -Uri $uri -Headers $header

  .NOTES
  The function returns a pscustombject with the keys InvokeResult, OperationId, CorrelationId
#>
function Invoke-AzNetworkRestMethod {
  [CmdLetBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Method,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string] $Uri,

    [Parameter()]
    [ValidateNotNull()]
    [string] $Body
  )
  if ($Uri -match 'vault.azure.net') {
    $token = Get-AzNetworkKeyVaultToken
  } else {
    $token = Get-AzNetworkToken
  }

  $irmArgs = @{
    Headers                 = @{
      Authorization = 'Bearer {0}' -f $token.AccessToken
    }
    ErrorAction             = 'Continue'
    Method                  = $Method
    UseBasicParsing         = $true
    ResponseHeadersVariable = 'respHeader'
    Uri                     = $Uri
  }

  if ($PSBoundParameters.ContainsKey('Body')) {
    [void] $irmArgs.Add('ContentType', 'application/json')
    [void] $irmArgs.Add('Body', $Body)
  }

  try {
    Write-Information -MessageData "Sending HTTP $($irmArgs.Method.ToUpper()) request to $($irmArgs.Uri)"
    $invokeResult = Invoke-RestMethod @irmArgs
  } catch {
    $errorMessage = $_.ErrorDetails.Message
    Write-Error -ErrorRecord $_ -ErrorAction Continue
  }

  $operationId = $null
  if ($null -ne $respheader.'x-ms-request-id') {
    Write-Information -MessageData "Response contains 'OperationId' '$($respheader.'x-ms-request-id'[0])'"
    $operationId = $respheader.'x-ms-request-id'[0]
  }

  $correlationId = $null
  if ($null -ne $respheader.'x-ms-correlation-request-id') {
    Write-Information -MessageData "Response contains 'CorrelationId' '$($respheader.'x-ms-correlation-request-id'[0])'"
    $correlationId = $respheader.'x-ms-correlation-request-id'[0]
  }

  [pscustomobject]@{
    InvokeResult   = $invokeResult
    ResponseHeader = $respheader
    OperationId    = $operationId
    CorrelationId  = $correlationId
    StatusMessage  = $errorMessage
  }
}

Export-ModuleMember -Function *-AzNetwork*
