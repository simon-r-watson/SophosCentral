function Get-SophosCentralUserGroups {
    <#
    .SYNOPSIS
        Get User Groups listed in Sophos Central
    .DESCRIPTION
        Get User Groups listed in Sophos Central
        https://developer.sophos.com/docs/common-v1/1/routes/directory/user-groups/get
    .EXAMPLE
        Get-SophosCentralUserGroups
    #>
    $uriChild = '/common/v1/directory/user-groups'
    $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}