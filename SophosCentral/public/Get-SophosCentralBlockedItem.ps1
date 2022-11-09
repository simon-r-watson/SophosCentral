function Get-SophosCentralBlockedItem {
    <#
    .SYNOPSIS
        Get Endpoint blocked Items
    .DESCRIPTION
        Get Endpoint blocked Items
    .EXAMPLE
        Get-SophosCentralBlockedItem
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/blocked-items/get
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralBlockedItems')]
    param (
    )
    Test-SophosCentralConnected
    
    $uriChild = '/endpoint/v1/settings/blocked-items'
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}