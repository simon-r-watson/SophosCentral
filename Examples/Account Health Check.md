# Account Health Check

## Single Tenant

``` powershell
$health = Get-SophosCentralAccountHealthCheck
$report = [PSCustomObject]@{
    ComputerNotFullyProtected = $health.endpoint.protection.computer.notFullyProtected
    ServerNotFullyProtected = $health.endpoint.protection.server.notFullyProtected
    ExclusionsNumberOfSecurityRisks = $health.endpoint.exclusions.global.numberOfSecurityRisks
    ScanningExclusions = $health.endpoint.exclusions.global.scanningExclusions
    ComputerPoliciesNotOnRecommended = $health.endpoint.policy.computer.'threat-protection'.notOnRecommended
    ComputerPolicies = $health.endpoint.policy.computer.'threat-protection'.policies
    ServerPoliciesNotOnRecommended = $health.endpoint.policy.server.'server-threat-protection'.notOnRecommended
    ServerPolicies = $health.endpoint.policy.server.'server-threat-protection'.policies
    ComputersTamperProtectionDisabled = $health.endpoint.tamperProtection.computer.disabled
    ServersTamperProtectionDisabled = $health.endpoint.tamperProtection.server.disabled
}
$report

```

## Partner/Enterprise All Sub Tenants

``` powershell

$tenants = Get-SophosCentralCustomerTenant

$tenantReport = foreach ($tenant in $tenants) {
    $connectionSuccessful = $true
    try {
        Connect-SophosCentralCustomerTenant -CustomerTenantID $tenant.id
    } catch {
        $connectionSuccessful = $false
    }
    
    if ($connectionSuccessful -eq $true) {
        $health = Get-SophosCentralAccountHealthCheck
        $report = [PSCustomObject]@{
            Tenant = $tenant.Name
            ComputerNotFullyProtected = $health.endpoint.protection.computer.notFullyProtected
            ServerNotFullyProtected = $health.endpoint.protection.server.notFullyProtected
            ExclusionsNumberOfSecurityRisks = $health.endpoint.exclusions.global.numberOfSecurityRisks
            ScanningExclusions = $health.endpoint.exclusions.global.scanningExclusions
            ComputerPoliciesNotOnRecommended = $health.endpoint.policy.computer.'threat-protection'.notOnRecommended
            ComputerPolicies = $health.endpoint.policy.computer.'threat-protection'.policies
            ServerPoliciesNotOnRecommended = $health.endpoint.policy.server.'server-threat-protection'.notOnRecommended
            ServerPolicies = $health.endpoint.policy.server.'server-threat-protection'.policies
            ComputersTamperProtectionDisabled = $health.endpoint.tamperProtection.computer.disabled
            ServersTamperProtectionDisabled = $health.endpoint.tamperProtection.server.disabled
        }
        $report 
    }
}
$tenantReport

```
