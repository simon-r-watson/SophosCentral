function Get-SophosCentralEndpoint {
    <#
    .SYNOPSIS
        Get Endpoints in Sophos Central (Workstations, Servers)
    .DESCRIPTION
        Get Endpoints in Sophos Central (Workstations, Servers)
    .EXAMPLE
        Get-SophosCentralEndpoint
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/get
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralEndpoints')]
    param (
    )

    $uriChild = '/endpoint/v1/endpoints'
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}