<#
    .SYNOPSIS
        Manually run tests using pester
    .DESCRIPTION
        Manually run tests, long term these will be moved to a GitHub action

    .EXAMPLE
        Invoke-Pester .\SophosCentral.Tests.ps1
#>

#set config

BeforeAll {
    $config = Get-Content "$($PSScriptRoot)\testConfig.json" | ConvertFrom-Json
    $modulePath = $PSScriptRoot.Replace('.Tests', '\SophosCentral-Debug.psm1')
    Import-Module $modulePath

    try {
        Connect-AzAccount
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
}

Describe 'Connect-SophosCentralCustomerTenant' {
    It 'Successfully connects to a valid customer by tenant ID, return null' {
        $connection = Connect-SophosCentralCustomerTenant -CustomerTenantID $config.CustomerTenantID
        $connection | Should -BeNullOrEmpty
    }

    It 'Successfully connects to a valid customer by tenant name search, return null' {
        $connection = Connect-SophosCentralCustomerTenant -CustomerNameSearch $config.CustomerTenantName
        $connection | Should -BeNullOrEmpty
    }

    It 'Fails to connect to a invalid customer by tenant ID, error' {
        {
            $connection = Connect-SophosCentralCustomerTenant -CustomerTenantID '3ca9b8e4-6d9a-407f-9c3d-186408a145be'
            $connection 
        } | Should -Throw
    }

    It 'Fails to connect to a invalid customer by tenant name search, error' {
        {
            $connection = Connect-SophosCentralCustomerTenant -CustomerNameSearch '3ca9b8e4-6d9a-407f-9c3d-186408a145be'
            $connection
        } | Should -Throw
    }

    It 'Fails to connect when more than one customer match the name search, error' {
        { 
            $connection = Connect-SophosCentralCustomerTenant -CustomerNameSearch 'e'
            $connection
        } | Should -Throw
    }
}

Describe 'Get-SophosCentralEndpoint' {
    It 'Given no parameters, it lists more than 50 endpoints' {
        Connect-SophosCentralCustomerTenant -CustomerTenantID $config.CustomerTenantID
        $endpoint = Get-SophosCentralEndpoint
        $endpoint.count | Should -BeGreaterThan 50
    }

    It 'Given HealthStatus is sus, it lists less than total the endpoints' {
        Connect-SophosCentralCustomerTenant -CustomerTenantID $config.CustomerTenantID
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -HealthStatus suspicious
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given HealthStatus is bad, it lists less than total the endpoints' {
        Connect-SophosCentralCustomerTenant -CustomerTenantID $config.CustomerTenantID
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -HealthStatus bad
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given Type is server, it lists less than total the endpoints' {
        Connect-SophosCentralCustomerTenant -CustomerTenantID $config.CustomerTenantID
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -Type server
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given TamperProtection is $false, it lists less than the total endpoints' {
        Connect-SophosCentralCustomerTenant -CustomerTenantID $config.CustomerTenantID
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -TamperProtectionEnabled $false
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }
}

