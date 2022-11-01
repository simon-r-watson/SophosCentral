function Get-SophosCentralCustomerTenant {
    <#
    .SYNOPSIS
        List Sophos Central customer/enterprise tenants that can be connected too (for Sophos partners/enterprise customers only)
    .DESCRIPTION
        List Sophos Central customer/enterprise tenants that can be connected too (for Sophos partners/enterprise customers only)
    .EXAMPLE
        Get-SophosCentralCustomerTenant
    .LINK
        https://developer.sophos.com/docs/partner-v1/1/routes/tenants/get
    .LINK
        https://developer.sophos.com/getting-started
    .LINK
        https://developer.sophos.com/getting-started-organization
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralCustomerTenants', 'Get-SophosCentralEnterpriseTenant')]
    param (
    )
    
    if (((Test-SophosPartner) -or (Test-SophosEnterprise)) -eq $false) {
        throw 'You are not currently logged in using a Sophos Central Partner/Enterprise Service Principal'
    }

    try {
        $header = Get-SophosCentralAuthHeader -PartnerInitial
    } catch {
        throw $_
    }
    switch ($SCRIPT:SophosCentral.IDType) {
        'partner' {
            $uri = [System.Uri]::New('https://api.central.sophos.com/partner/v1/tenants?pageTotal=true')
        }
        'organization' {
            $uri = [System.Uri]::New('https://api.central.sophos.com/organization/v1/tenants?pageTotal=true')
        }
    }
    
    Invoke-SophosCentralWebRequest -Uri $uri -CustomHeader $header
}