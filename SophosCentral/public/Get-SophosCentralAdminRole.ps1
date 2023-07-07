function Get-SophosCentralAdminRole {
    <#
    .SYNOPSIS
        Get admin roles in Sophos Central
    .DESCRIPTION
        Get admin roles listed in Sophos Central
    .EXAMPLE
        Get-SophosCentralAdminRole
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/roles/get
    #>
    [CmdletBinding()]
    param (
        [ValidateSet('predefined', 'custom')]
        [string]$Type,

        [ValidateSet('user', 'service')]
        [string]$PrincipalType
    )
    Test-SophosCentralConnected

    $uriChild = '/common/v1/roles'
    $uriTemp = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    $uri = New-UriWithQuery -Uri $uriTemp -OriginalPsBoundParameters $PsBoundParameters
    Invoke-SophosCentralWebRequest -Uri $uri
}
