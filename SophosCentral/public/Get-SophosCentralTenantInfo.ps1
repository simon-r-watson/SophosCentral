function Get-SophosCentralTenantInfo {
    <#
    .SYNOPSIS
        Get information of the tenant the service principal resides in
    .DESCRIPTION
        Get information of the tenant the service principal resides in
    .EXAMPLE
        Get-SophosCentralTenantInfo
    .LINK
        https://developer.sophos.com/docs/whoami-v1/1/routes/get
    #>
    Test-SophosCentralConnected
    
    $uri = [System.Uri]::New('https://api.central.sophos.com/whoami/v1')
    $header = Get-SophosCentralAuthHeader -Initial
    Invoke-SophosCentralWebRequest -Uri $uri -CustomHeader $header
}