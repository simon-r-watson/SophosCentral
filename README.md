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

This module is tested on PowerShell 7.1, it may work on Windows PowerShell 5. It will not work on Windows PowerShell 4 or earlier

## API Credentials/Service Principal

Sophos customers can connect to their tenant using a client id/secret. Follow Step 1 here to create it
<https://developer.sophos.com/getting-started-tenant>

Sophos partners can use a partner client id/secret to connect to their customer tenants. Follow Step 1 here to create it
<https://developer.sophos.com/getting-started>

## Saving Credentials

It is recommended to use a service such as Azure Key Vault to store the client id/secret. See [Azure Key Vault Example](./AzureKeyVaultExample.md) for an example implementation

## Importing the module

If your cloning this repo using Git, import the module using one of the *.psm1 files in .\SophosCentral\

```pwsh
Import-Module .\SophosCentral\SophosCentral.psm1
```

If your downloading the 'SophosCentral.zip' from the releases, you can use the .psd1

```pwsh
Import-Module .\SophosCentral.psd1
```

This is due to me being lazy and not updating the psd often enough in the repo. The copy in the releases zip files will have the correct entries in there, as it's automatically generated

## Example - Sophos Central Customer - Get Alerts

``` powershell
$clientID = "asdkjsdfksjdf"
$clientSecret = Read-Host -AsSecureString -Prompt "Client Secret:"

Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret

$alerts = Get-SophosCentralAlert
```

## Example - Sophos Partner - Get All Customer Alerts

``` powershell
$clientID = "asdkjsdfksjdf"
$clientSecret = Read-Host -AsSecureString -Prompt "Client Secret:"
$allCustomerAlerts = [System.Collections.Arraylist]::New()

Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret

$tenants = Get-SophosCentralCustomerTenant
foreach ($tenant in $tenants) {
    Connect-SophosCentralCustomerTenant -CustomerTenantID $tenant.id
    Get-SophosCentralAlert | `
        Foreach-Object {
            if ($null -ne $_.product) {
                $_ | Add-Member -MemberType NoteProperty -Name TenantName -Value $tenant.Name
                $_ | Add-Member -MemberType NoteProperty -Name TenantID -Value $tenant.ID
                $allCustomerAlerts += $_
            }
        }
}
```

## Example - Sophos Partner - Clear ConnectWise Control Alerts

Be very careful with this example. This should only be done when Sophos is blocking ConnectWise Control from updating.

``` powershell
$clientID = "asdkjsdfksjdf"
$clientSecret = Read-Host -AsSecureString -Prompt "Client Secret:"
$controlCustomerAlerts = [System.Collections.Arraylist]::New()

Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret

$tenants = Get-SophosCentralCustomerTenant
foreach ($tenant in $tenants) {
    Connect-SophosCentralCustomerTenant -CustomerTenantID $tenant.id
    Get-SophosCentralAlert | `
        Where-Object { $_.Description -like "*ScreenConnect*" } | `
            Foreach-Object {
                $result = Set-SophosCentralAlertAction -AlertID $_.id -Action $_.allowedActions[0]
                $_ | Add-Member -MemberType NoteProperty -Name result -Value $result.result
                $_ | Add-Member -MemberType NoteProperty -Name actionrequested -Value $result.action
                $_ | Add-Member -MemberType NoteProperty -Name requestedAt -Value $result.requestedAt
                $controlCustomerAlerts += $_
            }
}
```

## Example - Enable Tamper Protection

``` powershell
Get-SophosCentralEndpoint | `
    Where-Object {$_.tamperprotectionenabled -ne $true} | `
        ForEach-Object { 
            Set-SophosCentralEndpointTamperProtection -EndpointID $_.id -Enabled $true -Force
        }
```

## Example - Get Endpoints with Tamper Protection disabled

``` powershell
Get-SophosCentralEndpoint | `
    Where-Object {$_.tamperprotectionenabled -ne $true}
```

## Example - Review User Sync Source

``` powershell
$tenants = Get-SophosCentralCustomerTenant

$sources = foreach ($tenant in $tenants) {
    $connectionSuccessful = $true
    try {
        Connect-SophosCentralCustomerTenant -CustomerTenantID $tenant.id
    } catch {
        $connectionSuccessful = $false
    }
    
    if ($connectionSuccessful -eq $true) {
        $sourceHash = @{
            Tenant = $tenant.Name
        }
        $users = Get-SophosCentralUser | Where-Object { $_.source.type -eq 'activeDirectory' }
        foreach ($user in $users) {
            if ($sourceHash.keys -contains $user.source.type) {
                $sourceHash[$user.source.type] += 1
            } else {
                $sourceHash.Add($user.source.type, 1)
            }
        }
        [PSCustomObject]$sourceHash
    }
}
$sources | Format-List *
```

## Example - Audit Customer Tenant Settings

See [AuditTenantSettings.ps1](AuditTenantSettings.ps1)
