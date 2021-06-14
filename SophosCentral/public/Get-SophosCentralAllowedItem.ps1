function Get-SophosCentralAllowedItem {
    <#
    .SYNOPSIS
        Get Endpoint allowed Items
    .DESCRIPTION
        Get Endpoint allowed Items
    .EXAMPLE
        Get-SophosCentralAllowedItems
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/allowed-items/get
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralAllowedItems')]
    param (
    )
    
    $uriChild = '/endpoint/v1/settings/allowed-items'
    $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}