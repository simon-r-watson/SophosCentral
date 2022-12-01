function Invoke-SophosCentralLiveDiscoverQueryRun {
    <#
    .SYNOPSIS
        Run a saved EDR query or an ad hoc query on remote endpoints.
    .DESCRIPTION
        Run a saved EDR query or an ad hoc query on remote endpoints.

    .PARAMETER CustomBody
        The query to run as a hashtable, see this for query options - https://developer.sophos.com/docs/live-discover-query-v1/1/routes/queries/runs/post
        The values in the example bodies below may not be correct (such as the variables sub hash tables), but the structure of the hashtable should be correct

    .PARAMETER categoryId
        string (uuid)
        Query category ID.

    .PARAMETER 	queryId
        string (uuid)
        Saved query ID.

    .PARAMETER queryName
        string
        Name for the ad hoc query. 1 ≤ length ≤ 300.
    .PARAMETER query
        string
        SQL statement for the query. This can contain replacement variables wrapped in $$ (double dollar sign) delimiters. 15 ≤ length ≤ 50000

    .PARAMETER variables
        Values of variables to be replaced in the template SQL. Array of hashes each contains the following keys:
            name        Variable name
            dataType    Data types supported for EDR Data Lake queries.
                        The following values are allowed:
                            double, integer, text, dateTime, boolean
            value	    String value of the variable.
            pivotType	The meaning of an input parameter of a query.
                        The following values are allowed:
                            deviceId, deviceName, sophosPid, ipAddress, username, sha256, filePath, registryKey, url

     Filter parameters - up to 5 may be specified - if no filter parameter are specified the matchEndpoints=all is added

    .PARAMETER healthStatus
        array
        Find endpoints by health status.

    .PARAMETER type
        array
        Find endpoints by type.

    .PARAMETER tamperProtectionEnabled
        boolean
        Find endpoints by whether Tamper Protection is turned on.

    .PARAMETER lockdownStatus
        array
        Find endpoints by lockdown status.

    .PARAMETER ids
        array
        Find endpoints with the specified IDs. Must contain from 1 to 1000 items.

    .PARAMETER lastSeenBefore
        string
        Find endpoints that were last seen before the given date and time (UTC) or a duration relative to the current date and time (exclusive).

    .PARAMETER lastSeenAfter
        string
        Find endpoints that were last seen after the given date and time (UTC) or a duration relative to the current date and time (inclusive).

    .PARAMETER hostnameContains
        string
        Find endpoints where the hostname contains the given string.

    .PARAMETER associatedPersonContains
        string
        Find endpoints where the name of the person associated with the endpoint contains the given string.

    .PARAMETER groupNameContains
        string
        Find endpoints where the name of the group the endpoint is in contains the given string.

    .PARAMETER os
        array
        Matches endpoints with any of the supplied operating system versions.

    .PARAMETER ipAddresses
        array
        Find endpoints by IP addresses.

    .PARAMETER search
        string
        Term to search for in the specified search fields.

    .PARAMETER searchFields
        array
        List of search fields for finding the given search term. Defaults to all applicable fields.

    .EXAMPLE
        Full custom body:

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
        Custom query with filters:
        Invoke-SophosCentralLiveDiscoverQueryRun -query "select * from file WHERE path = 'c:\windows\system32\drivers\etc\hosts'" -endpointFilters (@{hostnameContains="17"},@{type=@("computer")})
    .EXAMPLE
        Invoke-SophosCentralLiveDiscoverQueryRun -query "select * from file WHERE path = 'c:\windows\system32\drivers\etc\hosts'" -ipAddresses ("192.168.0.1") -hostnameContains "cthulu"
    .EXAMPLE
        Custom query with variables:
        Invoke-SophosCentralLiveDiscoverQueryRun -query 'select * from file WHERE path = $$path$$' -ipAddresses ("192.168.0.1") -variables (@{name='path';dataType='text';value='c:\windows\system32\drivers\etc\host'})
    .EXAMPLE
        Canned query with variables and filter:
        Variables are an array of hashes!:
        Invoke-SophosCentralLiveDiscoverQueryRun -queryID c2942032-fecc-4b04-b3e8-f0485bc3f40a -variables @(
            @{name='start_time';dataType='dateTime';value=(get-date).addDays(-5)},
            @{name='ip_address';dataType='text';value='8.8.8.8'},
            @{name='end_time';dataType='dateTime';value=get-date}) -ipAddresses ("192.168.0.1")

    .LINK
        https://developer.sophos.com/docs/Live-Discover-query-v1/1/routes/queries/runs/post
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'CustomBody')]
        [hashtable]$customBody,

        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [string]$categoryId,

        [Parameter(Mandatory = $true, ParameterSetName = 'CannedQuery')]
        [string]$queryId,

        [Parameter(Mandatory = $true, ParameterSetName = 'CustomQuery')]
        [string]$query,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [string]$queryName = 'AdHoc',

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [ValidateSet('good', 'suspicious', 'bad', 'unknown')]
        [array]$healthStatus,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [ValidateSet('computer', 'server', 'securityVm')]
        [array]$type,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [Boolean]$tamperProtectionEnabled,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [ValidateSet('creatingWhitelist', 'installing', 'locked', 'notInstalled', 'registering', 'starting', 'stopping', 'unavailable', 'uninstalled', 'unlocked')]
        [array]$lockdownStatus,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [array]$ids,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [ValidateScript({
                if ($_.GetType().Name -eq 'DateTime') {
                    return $true
                } else {
                    #match this duration format https://en.wikipedia.org/wiki/ISO_8601#Durations
                    $regex = '^[-+]?P(?!$)(([-+]?\d+Y)|([-+]?\d+\.\d+Y$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?(([-+]?\d+W)|([-+]?\d+\.\d+W$))?(([-+]?\d+D)|([-+]?\d+\.\d+D$))?(T(?=[\d+-])(([-+]?\d+H)|([-+]?\d+\.\d+H$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?([-+]?\d+(\.\d+)?S)?)??$'
                    if ($_ -match $regex) {
                        return $true
                    } else {
                        try {
                            $_ | Get-Date -ErrorAction stop
                        } catch {
                            throw 'lastSeenBefore should be [datetime] or ISO_8601 or something get-date recognises'
                        }

                    }
                }
            })]
        [string]$lastSeenBefore,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [ValidateScript({
                if ($_.GetType().Name -eq 'DateTime') {
                    return $true
                } else {
                    #match this duration format https://en.wikipedia.org/wiki/ISO_8601#Durations
                    $regex = '^[-+]?P(?!$)(([-+]?\d+Y)|([-+]?\d+\.\d+Y$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?(([-+]?\d+W)|([-+]?\d+\.\d+W$))?(([-+]?\d+D)|([-+]?\d+\.\d+D$))?(T(?=[\d+-])(([-+]?\d+H)|([-+]?\d+\.\d+H$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?([-+]?\d+(\.\d+)?S)?)??$'
                    if ($_ -match $regex) {
                        return $true
                    } else {
                        try {
                            $_ | Get-Date -ErrorAction stop
                        } catch {
                            throw 'lastSeen After should be [datetime] or ISO_8601 or something get-date recognises'
                        }

                    }
                }
            })]
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
        [array]$os,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [array]$ipAddresses,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [string]$search,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [ValidateSet('hostname', 'groupName', 'associatedPersonName', 'ipAddresses', 'osName')]
        [array]$searchFields,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CannedQuery')]
        [array]$variables


    )
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/live-discover/v1/queries/runs')
    if ($PSCmdlet.ParameterSetName -eq 'CustomBody') {
        Write-Verbose 'Custom Body'
        $body = $customBody
    } else {
        $body = @{}
        $endpointFilters = @{}
        if ($healthStatus) {
            $endpointFilters.healthStatus = $healthStatus
        }
        if ($type) {
            $endpointFilters.type = $type
        }

        if ($tamperProtectionEnabled) {
            $endpointFilters.tamperProtectionEnabled = $tamperProtectionEnabled
        }
        if ($lockdownStatus) {
            $endpointFilters.lockdownStatus = $lockdownStatus
        }

        if ($ids) {
            $endpointFilters.ids = $ids
        }
        if ($lastSeenBefore) {
            try {
                $lastSeenBeforeTemp = $lastSeenBefore | Get-Date -AsUTC -Format 'yyyy-MM-dd"t"hh:mm:ssZ' -ErrorAction Stop
            } catch {
                $lastSeenBeforeTemp = $lastSeenBefore
            }
            $endpointFilters.lastSeenBefore = $lastSeenBeforeTemp
        }

        if ($lastSeenAfter) {
            try {
                $lastSeenAfterTemp = $lastSeenAfter | Get-Date -AsUTC -Format 'yyyy-MM-dd"t"hh:mm:ssZ' -ErrorAction Stop
            } catch {
                $lastSeenAfterTemp = $lastSeenAfter
            }
            $endpointFilters.lastSeenAfter = $lastSeenAfterTemp
        }

        if ($hostnameContains) {
            $endpointFilters.hostnameContains = $hostnameContains
        }

        if ($associatedPersonContains) {
            $endpointFilters.associatedPersonContains = $associatedPersonContains
        }

        if ($groupNameContains) {
            $endpointFilters.groupNameContains = $groupNameContains
        }

        if ($os) {
            $endpointFilters.os = $os
        }

        if ($ipAddresses) {
            $endpointFilters.ipAddresses = $ipAddresses
        }

        if ($search) {
            $endpointFilters.search = $search
        }

        if ($searchFields) {
            $endpointFilters.searchFields = $searchFields
        }

        if ($endpointFilters) {
            $body.matchEndpoints = @{
                'filters' = @($endpointFilters)
            }
        } else {
            $body.matchEndpoints = @{
                'all' = 'true'
            }
        }
        # force times into format acceptable to Sophos
        if ($variables) {
            foreach ($var in $variables) {
                if ($var.dataType -eq 'datetime') {
                    try {
                        $var.value = $var.value | Get-Date -AsUTC -Format 'yyyy-MM-dd"t"hh:mm:ssZ' -ErrorAction Stop
                    } catch {
                        throw "Invalid dateTime variable format for variable $($var.name)"
                    }
                }
            }
            $body.variables = $variables
        }
        if ($PSCmdlet.ParameterSetName -eq 'CustomQuery') {
            Write-Verbose 'Custom Query'
            $body.'adHocQuery' = @{
                'template' = $query
                'name'     = $queryName
            }
        } else {
            Write-Verbose 'Canned Query'
            $body.savedQuery = @{
                'queryId'    = $queryId
                'categoryId' = $categoryId
            }
        }
    }
    Write-Verbose ($body | ConvertTo-Json -Depth 5)
    Write-Verbose $uri
    Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
}
