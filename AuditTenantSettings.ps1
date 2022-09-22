$clientID = Get-Secret 'SophosCentral-Partner-ClientID' -Vault AzKV -AsPlainText
$clientSecret = Get-Secret -Name 'SophosCentral-Partner-ClientSecret' -Vault AzKV

Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret

$tenants = Get-SophosCentralCustomerTenant
$types = @{
    'agent-updating'                   = @{
        Enabled = $true
    }
    'threat-protection'                = @{
        Enabled                                                                               = 'True'
        'endpoint.threat-protection.web-control.tls-decryption.enabled'                       = 'True'
        'endpoint.threat-protection.malware-protection.scheduled-scan.enabled'                = 'True'
        'endpoint.threat-protection.malware-protection.scheduled-scan.scan-all-files.enabled' = 'True'
        'endpoint.threat-protection.malware-protection.scheduled-scan.deep-scanning.enabled'  = 'True'
        'endpoint.threat-protection.network-protection.self-isolation.enabled'                = 'True'
        'endpoint.threat-protection.malware-protection.deep-learning.detection-level'         = 'default'
    }
    'web-control'                      = @{
        Enabled                                       = 'True'
        'endpoint.web-control.enabled'                = 'True'
        'endpoint.web-control.web-monitoring.enabled' = 'yes'
        'endpoint.web-control.categories.9.action'    = 'block' #criminal
        'endpoint.web-control.categories.37.action'   = 'block' #proxy and translators
        'endpoint.web-control.categories.31.action'   = 'block' #p2p
        'endpoint.web-control.categories.2.action'    = 'block' #ads
        'endpoint.web-control.categories.19.action'   = 'block' #hacking
        'endpoint.web-control.categories.1.action'    = 'block' #adult
        'endpoint.web-control.categories.0.action'    = 'warn'  #uncategorized


    }
    'server-agent-updating'            = @{
        Enabled = $true
    }
    'server-file-integrity-monitoring' = @{
        Enabled = $true
    }
    'server-lockdown'                  = @{
        Enabled = $true
    }
    'server-threat-protection'         = @{
        Enabled                                                                               = $true
        'endpoint.threat-protection.web-control.tls-decryption.enabled'                       = 'True'
        'endpoint.threat-protection.malware-protection.scheduled-scan.enabled'                = 'True'
        'endpoint.threat-protection.malware-protection.scheduled-scan.scan-all-files.enabled' = 'True'
        'endpoint.threat-protection.malware-protection.scheduled-scan.deep-scanning.enabled'  = 'True'
        'endpoint.threat-protection.network-protection.self-isolation.enabled'                = 'True'
        'endpoint.threat-protection.malware-protection.file-reputation.reputation-level'      = 'recommended'
        'endpoint.threat-protection.malware-protection.deep-learning.detection-level'         = 'default'
        'endpoint.threat-protection.journal-hashing.exclude-remote-files.enabled'             = 'False'
        'endpoint.threat-protection.exploit-mitigation.cpu-branch-tracing.enabled'            = 'True'
    }
    'server-web-control'               = @{
        Enabled                                       = $true
        'endpoint.web-control.web-filtering.enabled'  = 'True'
        'endpoint.web-control.web-monitoring.enabled' = 'yes'
        'endpoint.web-control.categories.9.action'    = 'block' #criminal
        'endpoint.web-control.categories.37.action'   = 'block' #proxy and translators
        'endpoint.web-control.categories.2.action'    = 'block' #ads
        'endpoint.web-control.categories.19.action'   = 'block' #hacking
        'endpoint.web-control.categories.1.action'    = 'block' #adult
    }
}

$results = foreach ($tenant in $tenants) {
    
    $connectionSuccessful = $true
    try {
        Connect-SophosCentralCustomerTenant -CustomerTenantID $tenant.id
    } catch {
        $connectionSuccessful = $false
    }
    
    if ($connectionSuccessful -eq $true) {
        $policies = Get-SophosCentralEndpointPolicy -All
        foreach ($type in $types.Keys) {
            $typePolicies = $policies | Where-Object { $_.type -eq $type }
    
            $typeProps = $types[$type]
    
            foreach ($prop in $typeProps.Keys) {
                if ($prop -notlike '*.*') {
                    foreach ($typePolicy in $typePolicies) {
                        if ($typePolicy."$prop" -ne $typeProps[$prop]) {
                            $result = [PSCustomObject]@{
                                ID         = $typePolicy.id
                                Name       = $typePolicy.name
                                Type       = $typePolicy.type
                                TenantID   = $typePolicy.tenant.id
                                TenantName = $tenant.name
                                Property   = $prop
                                Value      = $typePolicy."$prop" 
                            }
                            $result
                        }
                    }
                } else {
                    foreach ($typePolicy in $typePolicies) {
                        if ($typePolicy.settings."$prop".value -ne $typeProps[$prop]) {
                            $result = [PSCustomObject]@{
                                ID         = $typePolicy.id
                                Name       = $typePolicy.name
                                Type       = $typePolicy.type
                                TenantID   = $typePolicy.tenant.id
                                TenantName = $tenant.name
                                Property   = $prop
                                Value      = $typePolicy.settings."$prop".value 
                            }
                            $result
                        }
                    }
                }
            }
            foreach ($typePolicy in $typePolicies) {
                foreach ($setting in ($typePolicy.settings | Get-Member | Where-Object { $_.MemberType -eq 'NoteProperty' }).Name) {
                    if ($typePolicy.settings."$setting".recommendedValue) {
                        if ($typePolicy.settings."$setting".recommendedValue -ne $typePolicy.settings."$setting".value) {
                            $result = [PSCustomObject]@{
                                ID         = $typePolicy.id
                                Name       = $typePolicy.name
                                Type       = $typePolicy.type
                                TenantID   = $typePolicy.tenant.id
                                TenantName = $tenant.name
                                Property   = $setting
                                Value      = $typePolicy.settings."$setting".value
                            }
                            $result
                        }
                    }
                }      
            }
        }
    }
}

$filePath = "$($env:LOCALAPPDATA)\temp\$((New-Guid).guid).csv"
$results | Export-Csv -Path $filePath -NoTypeInformation
Start-Process $filePath