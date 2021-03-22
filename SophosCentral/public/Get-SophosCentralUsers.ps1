function Get-SophosCentralUsers {
    <#
    .SYNOPSIS
        Get users listed in Sophos Central
    .DESCRIPTION
        Get users listed in Sophos Central
        https://developer.sophos.com/docs/common-v1/1/routes/directory/users/get
    .EXAMPLE
        Get-SophosCentralUsers
    #>
    $uriChild = '/common/v1/directory/users'
    $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}