function Get-SophosCentralEndpointGroup {
    <#
    .SYNOPSIS
        Get Endpoint groups in the directory
    .DESCRIPTION
        Get Endpoint groups in the directory
    .EXAMPLE
        Get-SophosCentralEndpointGroup
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoint-groups/get
    #>
    [CmdletBinding()]
    param (
    )
    Test-SophosCentralConnected
    
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoint-groups')
    Invoke-SophosCentralWebRequest -Uri $uri
}