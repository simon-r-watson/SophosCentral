function Get-SophosCentralEndpointGroup {
    <#
    .SYNOPSIS
        Get Endpoint groups in the directory
    .DESCRIPTION
        Get Endpoint groups in the directory
    .PARAMETER ID
        The ID of the group
    .PARAMETER Type
        The type of the group
    .EXAMPLE
        Get-SophosCentralEndpointGroup

        Get all groups
    .EXAMPLE
        Get-SophosCentralEndpointGroup -ID "12345678-1234-1234-1234-123456789012"

        Get the specified group
    .EXAMPLE
        Get-SophosCentralEndpointGroup -Type "computer"

        Get all computer groups
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoint-groups/get
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'ID')]
        [ValidateScript({
                if ($false -eq [System.Guid]::TryParse($_, $([ref][guid]::Empty))) {
                    throw 'Not a valid GUID'
                } else {
                    return $true
                }
            })]
        [string]$ID,

        [Parameter(Mandatory = $false, ParameterSetName = 'Type')]
        [ValidateSet('computer', 'server')]
        [string]$Type
    )
    Test-SophosCentralConnected

    $uriPath = '/endpoint/v1/endpoint-groups'
    if ($ID) {
        $uriPath = "$($uriPath)/$($ID)"
    }
    if ($Type) {
        $uriPath = "$($uriPath)/types/$($type)"
    }
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriPath)
    Invoke-SophosCentralWebRequest -Uri $uri
}
