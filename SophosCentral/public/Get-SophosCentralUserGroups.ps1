function Get-SophosCentralUserGroups {
    <#
    .SYNOPSIS
        Get User Groups listed in Sophos Central
    .DESCRIPTION
        Get User Groups listed in Sophos Central
    .EXAMPLE
        Get-SophosCentralUserGroups
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/directory/user-groups/get
    #>
    $uriChild = '/common/v1/directory/user-groups'
    $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}