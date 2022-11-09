function Get-SophosCentralAdmin {
    <#
    .SYNOPSIS
        Get admins listed in Sophos Central
    .DESCRIPTION
        Get admins listed in Sophos Central
    .EXAMPLE
        Get-SophosCentralAdmin
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/admins/get
    #>
    [CmdletBinding()]
    param (
    )
    Test-SophosCentralConnected
    
    $uriChild = '/common/v1/admins'
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}