function Get-SophosCentralEndpoints {
    <#
    .SYNOPSIS
        Get Endpoints in Sophos Central (Workstations, Servers)
    .DESCRIPTION
        Get Endpoints in Sophos Central (Workstations, Servers)
    .EXAMPLE
        Get-SophosCentralEndpoints
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/get
    #>
    $uriChild = '/endpoint/v1/endpoints'
    $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}