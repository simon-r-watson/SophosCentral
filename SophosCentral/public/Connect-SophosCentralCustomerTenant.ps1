function Connect-SophosCentralCustomerTenant {
    <#
    .SYNOPSIS
        Connect to a Customer tenant (for Sophos partners/enterprise customers only)
    .DESCRIPTION
        Connect to a Customer tenant (for Sophos partners/enterprise customers only). You must connect with "Connect-SophosCentral" first using a partners/enterprise service principal

        To find the customer tenant ID, use the "Get-SophosCentralCustomerTenant" function.

        Enterprise customers must have the following set within the sub estates/tenants your connecting to - https://support.sophos.com/support/s/article/KB-000036994?language=en_US
        Partners should follow similar instructions in the customer tenants - this is enabled by default for trials/new accounts created from the Partner Dashboard
    .PARAMETER CustomerTenantID
        The Customers tenant ID
    .PARAMETER CustomerNameSearch
        Search the tenants you have access to by their name in Sophos Central, use "*" as a wildcard. For example, if you want to connect to "Contoso Legal" `
        you could enter "Contoso*" here.
    .PARAMETER PerformConnectionTest
        Setting this will perform a connection test to the tenant. The connection test currently works by doing a test call to the alerts API, as all Sophos Central tenants should have this feature enabled.
    .EXAMPLE
        Connect-SophosCentralCustomerTenant -CustomerTenantID "7d565595-e281-4128-9711-c97eb1d202c5"

        Connect to the tenant with an ID of "7d565595-e281-4128-9711-c97eb1d202c5"
    .EXAMPLE
        Connect-SophosCentralCustomerTenant -CustomerNameSearch "Contoso*"

        Connect to Contoso
    .EXAMPLE
        Connect-SophosCentralCustomerTenant -CustomerNameSearch "Contoso*" -PerformConnectionTest

        Connect to Contoso and perform connection test
    .EXAMPLE
        Connect-SophosCentralCustomerTenant -CustomerNameSearch "Contoso*" 

        Connect to Contoso whilst refreshing the cache of tenants stored in memory
    .LINK
        https://developer.sophos.com/getting-started
    #>
    [CmdletBinding()]
    [Alias('Select-SophosCentralCustomerTenant', 'Select-SophosCentralEnterpriseTenant', 'Connect-SophosCentralEnterpriseTenant')]
    param (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'ByID'
        )]
        [string]$CustomerTenantID,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'BySearchString'
        )]
        [string]$CustomerNameSearch,

        [switch]$SkipConnectionTest,

        [switch]$PerformConnectionTest,

        [switch]$ForceTenantRefresh
    )
    Test-SophosCentralConnected
    
    if (((Test-SophosPartner) -or (Test-SophosEnterprise)) -eq $false) {
        throw 'You are not currently logged in using a Sophos Central Partner/Enterprise Service Principal'
    } else {
        Write-Verbose 'currently logged in using a Sophos Central Partner/Enterprise  Service Principal'
    }

    if ((-not($SCRIPT:SophosCentralCustomerTenants)) -or ($ForceTenantRefresh -eq $true)) {
        try {
            $SCRIPT:SophosCentralCustomerTenants = Get-SophosCentralCustomerTenant
        } catch {
            throw 'Unable to retrieve customer/enterprise tenants using Get-SophosCentralCustomerTenant'
        }
    }

    if (-not($CustomerTenantID)) {
        $tenantInfo = $SCRIPT:SophosCentralCustomerTenants | Where-Object {
            $_.Name -like $CustomerNameSearch
        }
        switch ($tenantInfo.count) {
            { $PSItem -eq 1 } { Write-Verbose "1 customer tenants returned: $($tenantInfo.Name)" }
            { $PSItem -gt 1 } { throw "$PSItem customer tenants returned: " + (($tenantInfo).name -join ';') }
            { $PSItem -lt 1 } { throw "$PSItem customer tenants returned" }
        }
    } else {
        $tenantInfo = $SCRIPT:SophosCentralCustomerTenants | Where-Object {
            $_.ID -eq $CustomerTenantID
        }
    }

    if ($null -ne $tenantInfo) {
        $SCRIPT:SophosCentral.RegionEndpoint = $tenantInfo.apiHost
        if ($SCRIPT:SophosCentral.CustomerTenantID) {
            $SCRIPT:SophosCentral.CustomerTenantID = $tenantInfo.id
        } else {
            $SCRIPT:SophosCentral | Add-Member -MemberType NoteProperty -Name CustomerTenantID -Value $tenantInfo.id
        }
        if ($SCRIPT:SophosCentral.CustomerTenantName) {
            $SCRIPT:SophosCentral.CustomerTenantName = $tenantInfo.Name
        } else {
            $SCRIPT:SophosCentral | Add-Member -MemberType NoteProperty -Name CustomerTenantName -Value $tenantInfo.Name
        }

        if (($PerformConnectionTest -eq $true) -and ($SkipConnectionTest -eq $false)) {
            try {
                [Diagnostics.CodeAnalysis.SuppressMessageAttribute('UseDeclaredVarsMoreThanAssignments', '', Justification = 'Used for checking permissions to the tenant')]
                $alertTest = Get-SophosCentralAlert
            } catch {
                throw "Unable to connect to the tenant, you may not have permissions to the tenant.`n`n $($_)"
            }
        }
        
    } else {
        throw 'Tenant does not exist'
    }
}