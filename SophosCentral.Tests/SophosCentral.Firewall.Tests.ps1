<#
    .SYNOPSIS
        Manually run tests using pester
    .DESCRIPTION
        Manually run tests, long term these will be moved to a GitHub action

        To run these tests, first update testConfig.json with the your Azure Key Vault name, Azure Key Vault client id/secret name, 
        Azure subscription id, and the sub tenant to use for testing (it must have the name and ID, otherwise those tests will fail).

        These tests need the following modules
            Az.Accounts
            Az.KeyVault
            Pester

    .EXAMPLE
        Invoke-Pester .\SophosCentral.Firewall.Tests.ps1
#>

BeforeAll {
    $config = Get-Content "$($PSScriptRoot)\testConfig.json" | ConvertFrom-Json
    if (Get-Module 'SophosCentral-Debug') {
        Remove-Module 'SophosCentral-Debug'
    }
    $modulePath = $PSScriptRoot.Replace('.Tests', '\SophosCentral-Debug.psm1')
    Import-Module $modulePath

    try {
        $context = Get-AzContext
        if ($null -eq $context.Account) {
            Connect-AzAccount -Subscription $config.AzSubscriptionID
        }
        if ($context.Subscription -ne $config.AzSubscriptionID) {
            Set-AzContext -Subscription $config.AzSubscriptionID
        }
        
        $clientID = Get-AzKeyVaultSecret -VaultName $config.AzKeyVaultName -Name $config.AzKeyVaultClientIDName -AsPlainText
        $clientSecret = Get-AzKeyVaultSecret -VaultName $config.AzKeyVaultName -Name $config.AzKeyVaultClientSecretName -AsPlainText | ConvertTo-SecureString -AsPlainText -Force
    } catch {
        throw "error retrieving secrets from Azure Key Vault: $($_)"
    }

    try {
        Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret
    } catch {
        throw "error connecting to Sophos Central: $($_)"
    }

    try {
        if ((Test-SophosPartner) -or (Test-SophosEnterprise)) {
            Connect-SophosCentralCustomerTenant -CustomerTenantID $config.CustomerTenantID
        }
    } catch {
        throw "error connecting to Sophos Central test tenant: $($_)"
    }
}
Describe 'Get-SophosCentralFirewall' {
    It 'Given no parameters, it should not throw' {
        {
            Get-SophosCentralFirewall
        } | Should -Not -Throw
    }

    It 'Given search groupid as an invalid GUID, it should throw' {
        {
            Get-SophosCentralFirewall -GroupId 'asdasdasd'
        } | Should -Throw "Cannot validate argument on parameter 'GroupId'. Not a valid GUID"
    }

    It 'Given search groupid as a valid GUID, it should not throw' {
        {
            Get-SophosCentralFirewall -GroupId 'e25ec1f2-04f5-477e-a10d-71f2e039ebaf'
        } | Should -Not -Throw 
    }

    It 'Given search groupid as ungrouped, it should not throw' {
        {
            Get-SophosCentralFirewall -GroupId 'ungrouped'
        } | Should -Not -Throw 
    }
}

Describe 'Get-SophosCentralFirewallUpdate' {
    It 'Given a valid firewall, it does not return null' {
        $firewall = Get-SophosCentralFirewall
        if ($null -eq $firewall) {
            Set-ItResult -Skipped -Because 'No firewalls in tenant'
        } else {
            Get-SophosCentralFirewallUpdate -FirewallID $firewall[0].id | Should -Not -BeNullOrEmpty
        }
    }
}

Describe 'Get-SophosCentralFirewallGroup' {
    It 'Given no parameters, it should not throw' {
        {
            Get-SophosCentralFirewallGroup
        } | Should -Not -Throw
    }

    It 'Given search RecurseSubgroups, it should not throw' {
        {
            Get-SophosCentralFirewallGroup -RecurseSubgroups $true
        } | Should -Not -Throw 
    }

    It 'Given search Search, it should not throw' {
        {
            Get-SophosCentralFirewallGroup -Search 'test'
        } | Should -Not -Throw 
    }
}