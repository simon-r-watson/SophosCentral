function Get-SophosCentralEndpointGroupMember {
    <#
    .SYNOPSIS
        Endpoints in your specified group.
    .DESCRIPTION
        Endpoints in your specified group.
    .PARAMETER ID
        The ID of the group
    .EXAMPLE
        Get-SophosCentralEndpointGroupMember -ID "12345678-1234-1234-1234-123456789012"
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoint-groups/%7BgroupId%7D/endpoints/get
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if ($false -eq [System.Guid]::TryParse($_, $([ref][guid]::Empty))) {
                    throw 'Not a valid GUID'
                } else {
                    return $true
                }
            })]
        [string]$ID
    )
    Test-SophosCentralConnected

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoint-groups/' + $ID + '/endpoints')
    Invoke-SophosCentralWebRequest -Uri $uri
}
