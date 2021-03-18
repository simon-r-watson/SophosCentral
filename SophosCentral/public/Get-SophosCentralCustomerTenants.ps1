function Get-SophosCentralCustomerTenants {
    <#
    .SYNOPSIS
        List Sophos Central customer tenants that can be connected too (for Sophos partners only)
    .DESCRIPTION
        List Sophos Central customer tenants that can be connected too (for Sophos partners only)
        https://developer.sophos.com/getting-started
    #>
    $header = Get-SophosCentralAuthHeader -PartnerInitial
    $uri = [System.Uri]::New('https://api.central.sophos.com/partner/v1/tenants?pageTotal=true')
    Invoke-SophosCentralWebRequest -Uri $uri -CustomHeader $header
}