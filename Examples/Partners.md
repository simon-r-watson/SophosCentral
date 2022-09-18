# Sophos Central Partner Examples

## Get All Customer Alerts

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

## Review User Sync Source

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
# Format-Table may not show all columns
$sources | Format-List *
```
