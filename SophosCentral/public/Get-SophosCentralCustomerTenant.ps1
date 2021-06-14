function Get-SophosCentralCustomerTenant {
    <#
    .SYNOPSIS
        List Sophos Central customer tenants that can be connected too (for Sophos partners only)
    .DESCRIPTION
        List Sophos Central customer tenants that can be connected too (for Sophos partners only)
    .EXAMPLE
        Get-SophosCentralCustomerTenant
    .LINK
        https://developer.sophos.com/docs/partner-v1/1/routes/tenants/get
    .LINK
        https://developer.sophos.com/getting-started
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralCustomerTenants')]
    param (
    )
    if ($global:SophosCentral.IDType -ne 'partner') {
        throw 'You are not currently logged in using a Sophos Central Partner Service Principal'
    } else {
        Write-Verbose 'currently logged in using a Sophos Central Partner Service Principal'
    }

    try {
        $header = Get-SophosCentralAuthHeader -PartnerInitial
    } catch {
        throw $_
    }
    $uri = [System.Uri]::New('https://api.central.sophos.com/partner/v1/tenants?pageTotal=true')
    Invoke-SophosCentralWebRequest -Uri $uri -CustomHeader $header
}