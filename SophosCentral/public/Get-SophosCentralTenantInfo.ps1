function Get-SophosCentralTenantInfo {
    <#
    .SYNOPSIS
        Get information of the current tenant
    .DESCRIPTION
        Get information of the current tenant
    .EXAMPLE
        Get-SophosCentralTenantInfo
    .LINK
        https://developer.sophos.com/docs/whoami-v1/1/routes/get
    #>
    $uri = [System.Uri]::New('https://api.central.sophos.com/whoami/v1')
    $header = Get-SophosCentralAuthHeader -Initial
    Invoke-SophosCentralWebRequest -Uri $uri -CustomHeader $header
}