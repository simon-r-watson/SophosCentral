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

Sophos Enterprise customers can connect to their tenants using a client/secret. Follow Step 1 here to create it
<https://developer.sophos.com/getting-started-organization>

## Saving Credentials

It is recommended to use a service such as Azure Key Vault to store the client id/secret. See [Azure Key Vault Example](./Examples/Azure%20Key%20Vault%20Example.md) for an example implementation

## Importing the module

If your cloning this repo using Git, import the module using one of the *.psm1 files in .\SophosCentral\, instead of using the psd1 file

```pwsh
Import-Module .\SophosCentral\SophosCentral.psm1
```

If your downloading the 'SophosCentral.zip' file from the releases, you can use the .psd1

```pwsh
Import-Module .\SophosCentral.psd1
```

This is due to me not updating the psd1 often enough in the repo. The copy in the releases zip files will have the correct entries in there, as it's automatically generated.

## Function Documentation

See <https://github.com/simon-r-watson/SophosCentral/wiki>. This is automatically updated after each release. Due to this, it may not be up to date for newly added or modified functions in the main branch of this repo.

## Examples

See [Examples](./Examples/) for further examples

### Connect to Sophos Central

* The Client Secret is set to a secure string, to make it harder for people to accidentally enter the secret into the PowerShell console in plain text (which ends up on disk in plain text due to the command history feature, and also in the transcription logging if that is enabled)

``` powershell
$ClientID = Read-Host -Prompt 'Client ID'
$ClientSecret = Read-Host -AsSecureString -Prompt 'Client Secret'
Connect-SophosCentral -ClientID $ClientID -ClientSecret $ClientSecret
```

### Connect to a customer tenant (partners) or sub estate (enterprise)

``` powershell
Connect-SophosCentralCustomerTenant -CustomerNameSearch "Contoso*"
```

### Get Alerts

``` powershell
$alerts = Get-SophosCentralAlert
```

### Get Account Health Check

``` powershell
$health = Get-SophosCentralAccountHealthCheck
#servers/workstations status
$health.endpoint.protection
#endpoint policies
$health.endpoint.policy.computer
#server polices
$health.endpoint.policy.server
#exclusions
$health.endpoint.exclusions
#tamper protection
$health.endpoint.tamperProtection
```

### Get Endpoints install links

``` powershell
$installers = Get-SophosCentralEndpointInstallerLink
$installers.installers
```

### Get Endpoints with status that needs investigating

``` powershell
Get-SophosCentralEndpoint -HealthStatus 'bad', 'suspicious', 'unknown'
```


### Enable Tamper Protection on all endpoints

*  You should also enable Globally in the tenant too

``` powershell
Get-SophosCentralEndpoint -TamperProtectionEnabled $false | Set-SophosCentralEndpointTamperProtection -Enabled $true
```

### Get Endpoints with Tamper Protection disabled

``` powershell
Get-SophosCentralEndpoint -TamperProtectionEnabled $false
```

### Get Endpoint not seen in over 90 days

``` powershell
Get-SophosCentralEndpoint -LastSeenBefore '-P90D'
```

### Trigger a scan of all endpoints

``` powershell
Get-SophosCentralEndpoint | Invoke-SophosCentralEndpointScan
```

### Trigger a scan of bad/suspicious endpoints

``` powershell
Get-SophosCentralEndpoint -HealthStatus 'bad', 'suspicious' | Invoke-SophosCentralEndpointScan
```

### Audit Customer Tenant Settings

See [AuditTenantSettings.ps1](./Examples/AuditTenantSettings.ps1)
