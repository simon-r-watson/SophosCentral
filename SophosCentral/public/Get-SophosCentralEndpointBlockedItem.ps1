function Get-SophosCentralEndpointBlockedItem {
    <#
    .SYNOPSIS
        Get all blocked items.
    .DESCRIPTION
        Get all blocked items.
    .EXAMPLE
        Get-SophosCentralEndpointBlockedItem

        List all blocked items in the tenant
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/blocked-items/get
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralBlockedItem', 'Get-SophosCentralBlockedItems')]
    param (

    )
    Test-SophosCentralConnected

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/blocked-items?pageTotal=true')
    Invoke-SophosCentralWebRequest -Uri $uri
}
