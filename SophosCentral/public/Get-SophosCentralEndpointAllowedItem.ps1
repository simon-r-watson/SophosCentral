function Get-SophosCentralEndpointAllowedItem {
    <#
    .SYNOPSIS
        Get all allowed items.
    .DESCRIPTION
        Get all allowed items.
    .EXAMPLE
        Get-SophosCentralEndpointAllowedItem

        List all allowed items in the tenant
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/allowed-items/get
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralAllowedItem', 'Get-SophosCentralAllowedItems')]
    param (

    )
    Test-SophosCentralConnected

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/allowed-items?pageTotal=true')
    Invoke-SophosCentralWebRequest -Uri $uri
}
