function Get-SophosCentralTenantInfo {
    [CmdletBinding()]
    param (
        
    )

    $uri = [System.Uri]::New('https://api.central.sophos.com/whoami/v1')
    $header = Get-SophosCentralAuthHeader -Initial
    Invoke-SophosCentralWebRequest -Uri $uri -CustomHeader $header
}