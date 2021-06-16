function Get-SophosCentralUserGroup {
    <#
    .SYNOPSIS
        Get User Groups listed in Sophos Central
    .DESCRIPTION
        Get User Groups listed in Sophos Central
    .EXAMPLE
        Get-SophosCentralUserGroup
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/directory/user-groups/get
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralUserGroups')]
    param (
    )
    
    $uriChild = '/common/v1/directory/user-groups'
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}