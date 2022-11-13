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
        Invoke-Pester .\SophosCentral.Tests.ps1
#>

BeforeAll {
    $config = Get-Content "$($PSScriptRoot)\testConfig.json" | ConvertFrom-Json
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

Describe 'Connect-SophosCentralCustomerTenant' {
    It 'Successfully connects to a valid customer by tenant ID, return null' {
        if ((Test-SophosPartner) -or (Test-SophosEnterprise)) {
            $connection = Connect-SophosCentralCustomerTenant -CustomerTenantID $config.CustomerTenantID
            $connection | Should -BeNullOrEmpty
        } else {
            Set-ItResult -Skipped -Because 'Not a partner/enterprise tenant'
        }
    }

    It 'Successfully connects to a valid customer by tenant name search, return null' {
        if ((Test-SophosPartner) -or (Test-SophosEnterprise)) {
            $connection = Connect-SophosCentralCustomerTenant -CustomerNameSearch $config.CustomerTenantName
            $connection | Should -BeNullOrEmpty
        } else {
            Set-ItResult -Skipped -Because 'Not a partner/enterprise tenant'
        }
    }

    It 'Fails to connect to a invalid customer by tenant ID, error' {
        if ((Test-SophosPartner) -or (Test-SophosEnterprise)) {
            {
                $connection = Connect-SophosCentralCustomerTenant -CustomerTenantID '3ca9b8e4-6d9a-407f-9c3d-186408a145be'
                $connection 
            } | Should -Throw
        } else {
            Set-ItResult -Skipped -Because 'Not a partner/enterprise tenant'
        }
    }

    It 'Fails to connect to a invalid customer by tenant name search, error' {
        if ((Test-SophosPartner) -or (Test-SophosEnterprise)) {
            {
                $connection = Connect-SophosCentralCustomerTenant -CustomerNameSearch '3ca9b8e4-6d9a-407f-9c3d-186408a145be'
                $connection
            } | Should -Throw
        } else {
            Set-ItResult -Skipped -Because 'Not a partner/enterprise tenant'
        }
    }

    It 'Fails to connect when more than one customer match the name search, error' {
        if ((Test-SophosPartner) -or (Test-SophosEnterprise)) {
            { 
                $connection = Connect-SophosCentralCustomerTenant -CustomerNameSearch 'e'
                $connection
            } | Should -Throw
        
        } else {
            Set-ItResult -Skipped -Because 'Not a partner/enterprise tenant'
        }
    }
}

Describe 'Get-SophosCentralAuthHeader' {
    It 'Given no parameters, it should return a header with X-Tenant-ID and Authorization' {
        $header = Get-SophosCentralAuthHeader
        $header.keys | Should -Contain 'X-Tenant-ID'
        $header.keys | Should -Contain 'Authorization'
    }

    It 'Given Partner Initial it should return a header with X-Partner-ID/X-Organization-ID and Authorization' {
        if ((Test-SophosPartner) -or (Test-SophosEnterprise)) {
            $header = Get-SophosCentralAuthHeader -PartnerInitial
            if (Test-SophosPartner) {
                $header.keys | Should -Contain 'X-Partner-ID'
            } elseif (Test-SophosEnterprise) {
                $header.keys | Should -Contain 'X-Organization-ID'
            }
            $header.keys | Should -Contain 'Authorization'
        } else {
            Set-ItResult -Skipped -Because 'Not a partner/enterprise tenant'
        }
    }
}

Describe 'Get-SophosCentralEndpoint' {
    It 'Given no parameters, it does not return null' {
        $endpoint = Get-SophosCentralEndpoint
        $endpoint.count | Should -Not -BeNullOrEmpty
    }

    It 'Given no parameters, it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }

    #Health
    It 'Given HealthStatus is sus, it lists less than total the endpoints' {
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -HealthStatus suspicious
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given HealthStatus is sus, it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint -HealthStatus suspicious
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }

    It 'Given HealthStatus is bad, it lists less than total the endpoints' {
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -HealthStatus bad
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given HealthStatus is bad, it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint -HealthStatus bad
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }

    It 'Given HealthStatus is bad and sus, it lists less than total the endpoints' {
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -HealthStatus bad, suspicious
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given HealthStatus is bad and sus, it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint -HealthStatus bad, suspicious
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }
    #Type
    It 'Given Type is server, it lists less than total the endpoints' {
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -Type server
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given Type is server, it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint -Type server
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }

    It 'Given Type is server and securityVM, it lists less than total the endpoints' {
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -Type server, securityVm
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given Type is server and securityVM, it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint -Type server, securityVm
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }

    #Tamper Protection
    It 'Given TamperProtection is $false, it lists less than the total endpoints' {
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -TamperProtectionEnabled $false
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given TamperProtection is $false , it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint -TamperProtectionEnabled $false
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }

    #Last Seen After
    It 'Given LastSeenAfter is "-P1D", it lists less than the total endpoints' {
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -LastSeenAfter '-P1D'
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given LastSeenAfter is "-P1D", it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint -LastSeenAfter '-P1D'
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }

    It 'Given LastSeenAfter is "(Get-Date).AddDays(-1)", it lists less than the total endpoints' {
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -LastSeenAfter (Get-Date).AddDays(-1)
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given LastSeenAfter is "(Get-Date).AddDays(-1)", it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint -LastSeenAfter (Get-Date).AddDays(-1)
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }

    It 'Given LastSeenAfter as "(Get-Date).AddDays(-1)" and "-P1D", it returns the same amount of endpoints' {
        $endpointsDateTime = Get-SophosCentralEndpoint -LastSeenAfter (Get-Date).AddDays(-1)
        $endpoints = Get-SophosCentralEndpoint -LastSeenAfter '-P1D'
        $endpoints.count | Should -BeExactly $endpointsDateTime.count
    }

    #Last Seen Before
    It 'Given LastSeenBefore is "-P90D", it lists less than the total endpoints' {
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -LastSeenBefore '-P90D'
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given LastSeenBefore is "-P90D", it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint -LastSeenBefore '-P90D'
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }

    It 'Given LastSeenBefore is "(Get-Date).AddDays(-90)", it lists less than the total endpoints' {
        $endpointsTotal = Get-SophosCentralEndpoint
        $endpoints = Get-SophosCentralEndpoint -LastSeenBefore (Get-Date).AddDays(-90)
        $endpoints.count | Should -BeLessThan $endpointsTotal.count
    }

    It 'Given LastSeenBefore is "(Get-Date).AddDays(-90)", it does not return duplicate endpoints' {
        $endpoints = Get-SophosCentralEndpoint -LastSeenBefore (Get-Date).AddDays(-90)
        $endpointsUnique = $endpoints | Select-Object id -Unique
        $endpointsUnique.count | Should -BeExactly $endpoints.count
    }

    It 'Given LastSeenBefore as "(Get-Date).AddDays(-90)" and "-P90D", it returns the same amount of endpoints' {
        $endpointsDateTime = Get-SophosCentralEndpoint -LastSeenBefore (Get-Date).AddDays(-90)
        $endpoints = Get-SophosCentralEndpoint -LastSeenBefore '-P90D'
        $endpoints.count | Should -BeExactly $endpointsDateTime.count
    }
}

Describe 'Get-SophosCentralAccountHealthCheck' {
    It 'Given no parameters, it does not return null' {
        Get-SophosCentralAccountHealthCheck | Should -Not -BeNullOrEmpty
    }
}

Describe 'Get-SophosCentralAdmin' {
    It 'Given no parameters, it does not return null' {
        Get-SophosCentralAdmin | Should -Not -BeNullOrEmpty
    }
}

Describe 'Get-SophosCentralUser' {
    It 'Given no parameters, it does not return null' {
        Get-SophosCentralUser | Should -Not -BeNullOrEmpty
    }

    It 'Given no parameters, it does not return duplicate users' {
        $users = Get-SophosCentralUser
        $usersUnique = $users | Select-Object id -Unique
        $usersUnique.count | Should -BeExactly $users.count
    }

    It 'Given search is "e" and the field is exchangeLogin, it lists less than total the users' {
        $usersTotal = Get-SophosCentralUser
        $users = Get-SophosCentralUser -Search 'e' -SearchField exchangeLogin
        $users.count | Should -BeLessThan $usersTotal.count
    }

    It 'Given search is "e" and the field is exchangeLogin, it does not have any entries with exchangeLogin containing "e"' {
        $users = Get-SophosCentralUser -Search 'e' -SearchField exchangeLogin
        $users | Where-Object { $_.exchangeLogin -notlike '*e*' } | Should -BeNullOrEmpty
    }

    It 'Given search is "@" and the field is email, it lists less than/equal to total the users' {
        $usersTotal = Get-SophosCentralUser
        $users = Get-SophosCentralUser -Search '@' -SearchField email
        $users.count | Should -BeLessOrEqual $usersTotal.count
    }

    #AD
    It 'Given source type is "activeDirectory", it lists less than/equal to total the users' {
        $usersTotal = Get-SophosCentralUser
        $users = Get-SophosCentralUser -SourceType activeDirectory
        $users.count | Should -BeLessOrEqual $usersTotal.count
    }

    It 'Given source type is "activeDirectory", all users have activeDirectory as the source' {
        $source = 'activeDirectory'
        $users = Get-SophosCentralUser -SourceType $source
        $sourceCount = 0
        foreach ($user in $users) {
            if ($user.source.type -ne $source ) {
                $sourceCount += 1
            }
        }
        $sourceCount | Should -BeExactly 0
    }

    It 'Given source type is "activeDirectory", there are no duplicate entries returned' {
        $source = 'activeDirectory'
        $users = Get-SophosCentralUser -SourceType $source
        $usersUnique = $users | Select-Object id -Unique
        $usersUnique.count | Should -BeExactly $users.count
    }
    #AAD
    It 'Given source type is "azureActiveDirectory", it lists less than/equal to total the users' {
        $usersTotal = Get-SophosCentralUser
        $users = Get-SophosCentralUser -SourceType azureActiveDirectory
        $users.count | Should -BeLessOrEqual $usersTotal.count
    }

    It 'Given source type is "azureActiveDirectory", all users have azureActiveDirectory as the source' {
        $source = 'azureActiveDirectory'
        $users = Get-SophosCentralUser -SourceType $source
        $sourceCount = 0
        foreach ($user in $users) {
            if ($user.source.type -ne $source ) {
                $sourceCount += 1
            }
        }
        $sourceCount | Should -BeExactly 0
    }

    It 'Given source type is "azureActiveDirectory", there are no duplicate entries returned' {
        $source = 'azureActiveDirectory'
        $users = Get-SophosCentralUser -SourceType $source
        $usersUnique = $users | Select-Object id -Unique
        $usersUnique.count | Should -BeExactly $users.count
    }
    #Custom/Sophos Portal
    It 'Given source type is "custom", it lists less than/equal to total the users' {
        $usersTotal = Get-SophosCentralUser
        $users = Get-SophosCentralUser -SourceType custom
        $users.count | Should -BeLessOrEqual $usersTotal.count
    }

    It 'Given source type is "custom", all users have custom as the source' {
        $source = 'custom'
        $users = Get-SophosCentralUser -SourceType $source
        $sourceCount = 0
        foreach ($user in $users) {
            if ($user.source.type -ne $source ) {
                $sourceCount += 1
            }
        }
        $sourceCount | Should -BeExactly 0
    }

    It 'Given source type is "custom", there are no duplicate entries returned' {
        $source = 'custom'
        $users = Get-SophosCentralUser -SourceType $source
        $usersUnique = $users | Select-Object id -Unique
        $usersUnique.count | Should -BeExactly $users.count
    }
}

Describe 'Get-SophosCentralCustomerTenant' {
    It 'Given no parameters, it does not return null' {
        if ((Test-SophosPartner) -or (Test-SophosEnterprise)) {
            Get-SophosCentralCustomerTenant | Should -Not -BeNullOrEmpty
        } else {
            Set-ItResult -Skipped -Because 'Not a partner/enterprise tenant'
        }
    }
}

Describe 'Get-SophosCentralPartnerAdmin' {
    <#
        For Partner tenants only
    #>
    It 'Given no parameters, it does not return null' {
        if (Test-SophosPartner) {
            Get-SophosCentralPartnerAdmin | Should -Not -BeNullOrEmpty
        } else {
            Set-ItResult -Skipped -Because 'Not a partner tenant'
        }
    }
}

Describe 'Get-SophosCentralAlert' {
    <#
        These searches with parameters also indirectly test Posts in Invoke-SophosCentralWebRequest
        This uses throw, as the API can return null/empty responses if there's no alerts
    #>
    It 'Given no parameters, it does not throw an exception' {
        {
            Get-SophosCentralAlert
        } | Should -Not -Throw
    }

    It 'Given severity high, it does not throw an exception' {
        {
            Get-SophosCentralAlert -Severity high
        } | Should -Not -Throw
    }

    It 'Given severity high, and product endpoint it does not throw an exception' {
        {
            Get-SophosCentralAlert -Product endpoint -Severity high
        } | Should -Not -Throw
    }

    It 'Given severity high, category general, and product email gateway it does not throw an exception' {
        {
            Get-SophosCentralAlert -Product emailGateway -Severity high -Category general
        } | Should -Not -Throw
    }
}

Describe 'Unprotect-Secret' {
    It 'Should convert known secret to a string' {
        $text = (New-Guid).Guid
        $secret = $text | ConvertTo-SecureString -AsPlainText -Force
        Unprotect-Secret -Secret $secret | Should -BeExactly $text
    }
}

Describe 'New-UriWithQuery' {
    It 'Given valid hash table, returns expected uri' {
        $uri = 'https://example.com'
        $uriExpected = 'https://example.com/?aaa=zzz'
        $hash = @{
            aaa = 'zzz'
        }
        $uriTest = New-UriWithQuery -OriginalPsBoundParameters $hash -Uri $uri
        $uriTest.AbsoluteUri.ToString() | Should -BeExactly $uriExpected
    }
}