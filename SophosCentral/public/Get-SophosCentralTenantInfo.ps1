function Get-SophosCentralTenantInfo {
    <#
    .SYNOPSIS
        Get information of the current tenant
    .DESCRIPTION
        Get information of the current tenant
    .EXAMPLE
        Get-SophosCentralTenantInfo
    #>
    $uri = [System.Uri]::New('https://api.central.sophos.com/whoami/v1')
    $header = Get-SophosCentralAuthHeader -Initial
    Invoke-SophosCentralWebRequest -Uri $uri -CustomHeader $header
}