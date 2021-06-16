function Get-SophosCentralUser {
    <#
    .SYNOPSIS
        Get users listed in Sophos Central
    .DESCRIPTION
        Get users listed in Sophos Central
    .EXAMPLE
        Get-SophosCentralUser
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/directory/users/get
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralUsers')]
    param (
    )

    $uriChild = '/common/v1/directory/users'
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}