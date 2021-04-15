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

## Example - Sophos Central Customer - Get Alerts

``` powershell
$clientID = "asdkjsdfksjdf"
$clientSecret = Read-Host -AsSecureString -Prompt "Client Secret:"

Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret

$alerts = Get-SophosCentralAlerts
```

## Example - Sophos Partner - Get All Customer Alerts

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

## Example - Sophos Partner - Clear ConnectWise Control Alerts

``` powershell
$clientID = "asdkjsdfksjdf"
$clientSecret = Read-Host -AsSecureString -Prompt "Client Secret:"
$controlCustomerAlerts = [System.Collections.Arraylist]::New()

Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret

$tenants = Get-SophosCentralCustomerTenants
foreach ($tenant in $tenants) {
    Connect-SophosCentralCustomerTenant -CustomerTenantID $tenant.id
    Get-SophosCentralAlerts | Where-Object {$_.Description -like "*ScreenConnect*"} | Foreach-Object {
        $result = Set-SophosCentralAlertAction -AlertID $_.id -Action $_.allowedActions[0]
        $_ | Add-Member -MemberType NoteProperty -Name result -Value $result.result
        $_ | Add-Member -MemberType NoteProperty -Name actionrequested -Value $result.action
        $_ | Add-Member -MemberType NoteProperty -Name requestedAt -Value $result.requestedAt
        $controlCustomerAlerts += $_
    }
}
```

## Saving Credentials

Please note that this method is not recommended. You should use a service such as Azure Key Vault to store the client secret instead. See [Azure Key Vault Example](./AzureKeyVaultExample.md) for further information

You can save the credential object using the following. The XML file generated will be encrypted, and will only be able to be decrypted by the user 
that created it on the same device that was used to generate it.

``` powershell
$GLOBAL:SophosCentral | Export-Clixml sophosauth.xml
```

And then import using the following. This will allow you to run commands without having to re-run Connect-SophosCentral

``` powershell
$GLOBAL:SophosCentral = Import-Clixml sophosauth.xml
```
