function Get-SophosCentralEndpointWebControlCategory {
    <#
    .SYNOPSIS
        Get all Web Control categories.
    .DESCRIPTION
        Get all Web Control categories.
    .EXAMPLE
        Get-SophosCentralEndpointWebControlCategory
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/web-control/categories/get
    #>
    [CmdletBinding()]
    param (
    )
    Test-SophosCentralConnected

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/web-control/categories')
    Invoke-SophosCentralWebRequest -Uri $uri -BuggyResponseNoItems
}
