# Sophos Central PowerShell Module

This is a collection on functions for working with the Sophos Central API.

It currently supports:

* Logging in using a Sophos Partner Service Principal and accessing customer tenants
* Logging in using a Service Principal created within a tenant itself (for Sophos Central Customers)
* Retrieving a list of Endpoints and their current status
* Invoking a scan on an Endpoint (or list of Endpoints)
* Retrieving a list of Alerts
* Action a list of Alerts
* Create a new user

This module is tested on PowerShell 7.1, it should work down to Windows PowerShell 5.

## Example - Sophos Central Customer

``` powershell
$clientID = "asdkjsdfksjdf"
$clientSecret = Read-Host -AsSecureString -Prompt "Client Secret:"

Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret

$alerts = Get-SophosCentralAlerts
```

## Example - Sophos Partner

``` powershell
$clientID = "asdkjsdfksjdf"
$clientSecret = Read-Host -AsSecureString -Prompt "Client Secret:"
$allCustomerAlerts = [System.Collections.Arraylist]::New()

Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret

$tenants = Get-SophosCentralCustomerTenants
foreach ($tenant in $tenants) {
    Connect-SophosCentralCustomerTenant -CustomerTenantID $tenant.id
    Get-SophosCentralAlerts | Foreach-Object {
        if ($null -ne $_.product) {
            $_ | Add-Member -MemberType NoteProperty -Name TenantName -Value $tenant.Name
            $_ | Add-Member -MemberType NoteProperty -Name TenantID -Value $tenant.ID
            $allCustomerAlerts += $_
        }
    }
}
```
