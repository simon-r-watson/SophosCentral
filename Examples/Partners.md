# Sophos Central Partner Examples

## Block an exe by file hash across all tenants

Save the $log variable to a csv/json/etc, in case you need to easily bulk remove them later.

``` powershell
$fileHash = '3337e3875b05e0bfba69ab926532e3f179e8cfbf162ebb60ce58a0281437a7ef'  #sha256 hash of the file
$comment =  'This is a comment about the blocked item'
$log = [System.Collections.Arraylist]::New()
$tenants = Get-SophosCentralCustomerTenant
foreach ($tenant in $tenants) {
    Connect-SophosCentralCustomerTenant -CustomerTenantID $tenant.id
    $item = New-SophosCentralEndpointBlockedItem -SHA256Hash $fileHash -Comment $comment -Force
    if ($null -ne $item ) {
        $_ | Add-Member -MemberType NoteProperty -Name TenantName -Value $tenant.Name
        $_ | Add-Member -MemberType NoteProperty -Name TenantID -Value $tenant.ID
        $log += $_
    }
}
$log
```

## Get All Customer Alerts

``` powershell
$allCustomerAlerts = [System.Collections.Arraylist]::New()
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
