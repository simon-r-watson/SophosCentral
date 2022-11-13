#Requires -Module EFPosh

<#
    Functions
#>

function Add-SophosCentralTenantToDatabase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Tenant Class')]
        [Tenant]$Tenant,

        [Parameter(Mandatory = $true, ParameterSetName = 'Result from API')]
        [psobject[]]$TenantRaw,

        [Parameter(Mandatory = $true, ParameterSetName = 'Get from API')]
        [switch]$PerformLookup
    )

    if ($PerformLookup) {
        $TenantRaw = Get-SophosCentralCustomerTenant
    }
    if ($TenantRaw) {
        foreach ($tenantr in $TenantRaw) {
            $Tenant = [Tenant]::New()
            $Tenant.ID = $tenantr.ID
            $Tenant.Name = $tenantr.Name
            Add-SophosCentralTenantToDatabase -Tenant $Tenant
        }
    } elseif ($Tenant) {
        $db = Search-EFPosh -Entity $Tenant.GetType().Name -Expression { $_.id -eq $Tenant.id }
        if ($db) {
            Remove-EFPoshEntity -Entity $db -SaveChanges
        }
        Add-EFPoshEntity -Entity $Tenant -SaveChanges
    } 
}
function Add-SophosCentralEndpointToDatabase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Endpoint Class')]
        [Endpoint]$Endpoint,

        [Parameter(Mandatory = $true, ParameterSetName = 'Result from API')]
        [psobject[]]$EndpointRaw,

        [Parameter(Mandatory = $true, ParameterSetName = 'Get from API')]
        [switch]$PerformLookup
    )

    if ($PerformLookup) {
        if ((Test-SophosPartner) -or (Test-SophosEnterprise)) {
            $Tenants = Get-SophosCentralCustomerTenant
            foreach ($tenant in $Tenants) {
                Connect-SophosCentralCustomerTenant -CustomerTenantID $tenant.ID
                $endpointsTenant = Get-SophosCentralEndpoint
                if ($endpointsTenant) {
                    Add-SophosCentralEndpointToDatabase -EndpointRaw $endpointsTenant
                }
            }
        } else {
            $EndpointRaw = Get-SophosCentralEndpoint
        }
    }

    if ($EndpointRaw) {
        foreach ($endpointr in $EndpointRaw) {
            $Endpoint = [Endpoint]::New()
            $Endpoint.ID = $endpointr.ID
            $Endpoint.Hostname = $endpointr.Hostname
            $Endpoint.TenantID = $endpointr.tenant.id
            $Endpoint.TamperProtectionEnabled = $endpointr.tamperProtectionEnabled
            $Endpoint.IsolationStatus = $endpointr.isolation.status
            $Endpoint.IsolatedAdmin = $endpointr.isolation.adminIsolated
            $Endpoint.IsolatedSelf = $endpointr.isolation.selfIsolated
            $Endpoint.HealthOverall = $endpointr.health.overall
            $Endpoint.HealthThreats = $endpointr.health.threats.status
            $Endpoint.HealthThreatsRaw = $endpointr.health.threats | ConvertTo-Json -Compress
            $Endpoint.HealthServices = $endpointr.health.services.status
            $Endpoint.HealthServicesRaw = $endpointr.health.services | ConvertTo-Json -Compress
            Add-SophosCentralEndpointToDatabase -Endpoint $Endpoint
        }
    } elseif ($Endpoint) {
        $db = Search-EFPosh -Entity $Endpoint.GetType().Name -Expression { $_.id -eq $Endpoint.id }
        if ($db) {
            Remove-EFPoshEntity -Entity $db -SaveChanges
        }
        Add-EFPoshEntity -Entity $Endpoint -SaveChanges
    }
}

function Add-SophosCentralAccountHealthToDatabase {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'AccountHealth Class')]
        [AccountHealth]$AccountHealth,

        [Parameter(Mandatory = $true, ParameterSetName = 'Get from API')]
        [switch]$PerformLookup
    )

    if ($PerformLookup) {
        if ((Test-SophosPartner) -or (Test-SophosEnterprise)) {
            $Tenants = Get-SophosCentralCustomerTenant
            foreach ($tenant in $Tenants) {
                Connect-SophosCentralCustomerTenant -CustomerTenantID $tenant.ID
                $accountHealthTenant = Get-SophosCentralAccountHealthCheck
                if ($accountHealthTenant) {
                    $AccountHealth = [AccountHealth]::New()
                    $AccountHealth.ID = $tenant.ID
                    $AccountHealth.HealthRaw = $accountHealthTenant | ConvertTo-Json -Depth 6 -Compress
                    Add-SophosCentralAccountHealthToDatabase -AccountHealth $AccountHealth
                }
            }
        } else {
            $AccountHealthRaw = Get-SophosCentralAccountHealthCheck
            $AccountHealth = [AccountHealth]::New()
            $AccountHealth.ID = (Get-SophosCentralTenantInfo).id
            $AccountHealth.HealthRaw = $AccountHealthRaw | ConvertTo-Json -Depth 5 -Compress
        }
    }

    if ($AccountHealth) {
        $db = Search-EFPosh -Entity $AccountHealth.GetType().Name -Expression { $_.id -eq $AccountHealth.id }
        if ($db) {
            Remove-EFPoshEntity -Entity $db -SaveChanges
        }
        Add-EFPoshEntity -Entity $AccountHealth -SaveChanges
    }
}

<#
    Script Start
#>

Import-Module "$($PsScriptRoot)\Models.ps1"
Import-Module ($PsScriptRoot.Replace('.Reports', '\SophosCentral-Debug.psm1'))
Import-Module EFPosh

Connect-SophosCentral -SecretVault -AzKeyVault
$tenants = Get-SophosCentralCustomerTenant


$tables = @(
    ( New-EFPoshEntityDefinition -Type 'Tenant' ),
    ( New-EFPoshEntityDefinition -Type 'AccountHealth' ),
    ( New-EFPoshEntityDefinition -Type 'Endpoint' )
)

<#
Azure SQL/MS SQL Connection Example - using SQL Login
    MS SQL
        Will support Windows Auth and SQL Login
    Azure SQL
        SQL Login Only
        The Azure portal should give you the complete connection string for SQL Login option, however you will still need to update it with your password
        Azure SQL Serverless is a cost affective option for this, and can easily be integrated with Power BI
    
    Update the {database server}, {database}, {username}, and {password} variables
#>
#$connectionString = 'Server=tcp:{database server},1433;Initial Catalog={database};Persist Security Info=False;User ID={username};Password={password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
#$context = New-EFPoshContext -ConnectionString $connectionString -DBType MSSQL -Entities $tables -EnsureCreated

#SQLite Example
$sqlLiteDb = Join-Path -Path $PsScriptRoot -ChildPath 'sophos.sqlite'
$Context = New-EFPoshContext -SQLiteFile $sqlLiteDb -Entities $tables -EnsureCreated

#Add data to databases
Add-SophosCentralTenantToDatabase -TenantRaw $tenants
Add-SophosCentralAccountHealthToDatabase -PerformLookup
Add-SophosCentralEndpointToDatabase -PerformLookup
