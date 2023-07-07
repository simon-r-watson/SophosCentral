function Get-SophosCentralEndpointInstallerLink {
    <#
    .SYNOPSIS
        Get all the endpoint installer links for a tenant.
    .DESCRIPTION
        Get all the endpoint installer links for a tenant.
    .EXAMPLE
        Get-SophosCentralEndpointInstallerLink
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/downloads/get
    #>
    [CmdletBinding()]
    param (
    )
    Test-SophosCentralConnected

    $uriChild = '/endpoint/v1/downloads'
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}
