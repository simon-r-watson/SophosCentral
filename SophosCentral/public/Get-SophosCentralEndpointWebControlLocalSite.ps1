function Get-SophosCentralEndpointWebControlLocalSite {
    <#
    .SYNOPSIS
        Get all local sites.
    .DESCRIPTION
        Get all local sites.
    .EXAMPLE
        Get-SophosCentralEndpointWebControlLocalSite
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/web-control/local-sites/get
    #>
    [CmdletBinding()]
    param (
    )
    Test-SophosCentralConnected

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/web-control/local-sites')
    Invoke-SophosCentralWebRequest -Uri $uri
}
