function Invoke-SophosCentralLiveDiscoverQueryRun {
    <#
    .SYNOPSIS
        Run a saved EDR query or an ad hoc query on remote endpoints.
    .DESCRIPTION
        Run a saved EDR query or an ad hoc query on remote endpoints.

        The values in the example bodies below may not be correct (such as the variables sub hashtables), but the structure of the hashtable should be correct
    .PARAMETER CustomBody
        The query to run as a hashtable, see this for query options - https://developer.sophos.com/docs/live-discover-query-v1/1/routes/queries/runs/post
    .EXAMPLE
        $body = @{
            'matchEndpoints' = @{
                'filters' = @(
                    @{
                        'hostnameContains' = '17'
                    }
                )
            }
            'adHocQuery' = @{
                'template' = 'select * from file WHERE path = ''c:\windows\system32\drivers\etc\hosts'''
                'name' = 'HostFile'
            }
        }
        $query = Invoke-SophosCentralLiveDiscoverQueryRun -customBody $body
    .EXAMPLE
        Invoke-SophosCentralLiveDiscoverQueryRun -query "select * from file WHERE path = 'c:\windows\system32\drivers\etc\hosts'" -endpointFilters (@{hostnameContains="17"},@{type=@("computer")})
    .EXAMPLE
        Invoke-SophosCentralLiveDiscoverQueryRun -query "select * from file WHERE path = 'c:\windows\system32\drivers\etc\hosts'" -endpointFilters (@{hostnameContains="17"},@{type=@("computer")})
    .EXAMPLE
        Invoke-SophosCentralLiveDiscoverQueryRun -query "select * from file WHERE path = 'c:\windows\system32\drivers\etc\hosts'" -ipAddresses ("10.164.5.150") -hostnameContains "17"
    .EXAMPLE
         Invoke-SophosCentralLiveDiscoverQueryRun -query 'select * from file WHERE path = $$path$$' -ipAddresses ("10.164.5.150") -variables (@{name='path';dataType='text';value='c:\windows\system32\drivers\etc\host'}) -verbose
    .LINK
        https://developer.sophos.com/docs/Live-Discover-query-v1/1/routes/queries/runs/post
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [string]$categoryId,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'CannedQuery')]
        [string]$queryId,

        [Parameter(Mandatory = $true, ParameterSetName = 'CustomBody')]
        [hashtable]$customBody,

        [Parameter(Mandatory = $true, ParameterSetName = 'CustomQuery')]
        [string]$Query,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [string]$queryName="AdHoc",

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [array]$endpointFilters,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [array]$healthStatus,        
        
        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [array]$type,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [Boolean]$tamperProtectionEnabled,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [ValidateSet('creatingWhitelist','installing','locked','notInstalled','registering','starting','stopping','unavailable','uninstalled','unlocked')]
        [array]$lockdownStatus,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [array]$ids,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [string]$lastSeenBefore,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [string]$lastSeenAfter,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [string]$hostnameContains,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [string]$associatedPersonContains,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [string]$groupNameContains,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [string]$os,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [array]$ipAddresses,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [string]$search,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [array]$searchFields,        
        
        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [array]$variables
        

    )
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/live-discover/v1/queries/runs')
    if ($PSCmdlet.ParameterSetName -eq 'CustomBody') {
        Write-Verbose "Custom Body"
        $body=$customBody
    } else {
        if ($healthStatus) {
            $endpointFilters+=@{healthStatus=$healthStatus}
        }            
        if ($type) {
            $endpointFilters+=@{type=$type}
        }            
        
        if ($tamperProtectionEnabled) {
            $endpointFilters+=@{tamperProtectionEnabled=$tamperProtectionEnabled}
        }            
        if ($lockdownStatus) {
            $endpointFilters+=@{lockdownStatus=$lockdownStatus}
        }            
        
        if ($ids) {
            $endpointFilters+=@{ids=$ids}
        }            
        if ($lastSeenBefore) {
            $endpointFilters+=@{lastSeenBefore=$lastSeenBefore}
        }            
        
        if ($lastSeenAfter) {
            $endpointFilters+=@{lastSeenAfter=$lastSeenAfter}
        }

        if ($hostnameContains	
        ) {
            $endpointFilters+=@{hostnameContains=$hostnameContains}
        }
        
        if ($associatedPersonContains) {
            $endpointFilters+=@{associatedPersonContains=$associatedPersonContains}
        }
        
        if ($groupNameContains) {
            $endpointFilters+=@{groupNameContains=$groupNameContains}
        }
        
        if ($os) {
            $endpointFilters+=@{os=$os}
        }

        if ($ipAddresses) {
            $endpointFilters+=@{ipAddresses=$ipAddresses}
        }
        
        if ($search) {
            $endpointFilters+=@{search=$search}
        }
        
        if ($search) {
            $endpointFilters+=@{search=$search}
        }

        if ($endpointFilters) {
            $matchEndpoints=@{
                'filters' = $endpointFilters
            }
        } else {
            $matchEndpoints=@{
                'all' = 'true'
            }
        }
        if ($PSCmdlet.ParameterSetName -eq 'CustomQuery') {
            Write-Verbose "Custom Query"
            $body = @{
                'matchEndpoints' = $matchEndpoints
                'adHocQuery' = @{
                    'template' = $query
                    'name' = $queryName
                }
                'variables' = $variables
            }
        } else {
            Write-Verbose "Canned Query"
            $body = @{
                'matchEndpoints' = $matchEndpoints
                'SavedQuery' = @{
                    'queryId' = $queryId
                    'categoryId' = $categoryId
                }
                'variables' = $variables
            }
        }   
    }
    Write-Verbose ($body|ConvertTo-Json -Depth 5)
    Write-Verbose $uri
    Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body   
}