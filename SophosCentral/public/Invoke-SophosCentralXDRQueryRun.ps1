function Invoke-SophosCentralXDRQueryRun {
    <#
    .SYNOPSIS
        Run a query against the Sophos Data Lake.
    .DESCRIPTION
        Run a query against the Sophos Data Lake.

        The values in the example bodies below may not be correct (such as the variables sub hashtables), but the structure of the hashtable should be correct
    .PARAMETER CustomBody
        The query to run as a hashtable, see this for query options - https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/runs/post
    
    .PARAMETER categoryId	
        Query category ID.

    .PARAMETER queryId (required)	
        Saved query ID.

    .PARAMETER adHocQuery	
        Ad hoc query to run. Required if a saved query isn't supplied.

    .PARAMETER name	
        Name for the ad hoc query.

    .PARAMETER template (required)	
        SQL statement for the query. This can contain replacement variables wrapped in $$ (double dollar sign) delimiters.

    .PARAMETER variables	
        Values of variables to be replaced in the template SQL. Array of hashes each containg the following keys:
            name        Variable name
            dataType    Data types supported for EDR Data Lake queries. 
                        The following values are allowed:
                            double, integer, text, dateTime, boolean
            value	    String value of the variable.
            pivotType	The meaning of an input parameter of a query.
                        The following values are allowed:
                            deviceId, deviceName, sophosPid, ipAddress, username, sha256, filePath, registryKey, url

    .PARAMETER ids	
        array
        Find endpoints with the specified IDs. Must contain from 1 to 1000 items. If not specfied then all endpoints are queried
    .PARAMETER from	
        Start of time range that is applied when running the query (inclusive). It can be in ISO duration format, full UTC timestamp or date only.
    .PARAMETER to	
        End of time range that is applied when running the query (inclusive). It can be in ISO duration format, full UTC timestamp or date only.       
    .EXAMPLE
        $body = @{
            'adHocQuery' = @{
                'template' = 'select * from \"xdr_data\" limit 10'
                'name' = 'test search'
            }
            'from' = '2022-01-01T12:02:01.000Z'
            'to' = '2022-01-21T12:02:01.700Z'
        }
        $query = Invoke-SophosCentralXDRQueryRun -CustomBody $body
    .EXAMPLE
        $body = @{
            'adHocQuery' = @{
                'template' = 'select * from \"xdr_data\" limit 10'
                'name' = 'test search'
            }
            'from' = '2022-01-01T12:02:01.000Z'
            'to' = '2022-01-21T12:02:01.700Z'
            'variables' = @{
                    'name' = 'var1'
                    'dataType' = 'text'
                    'value' = 'asdfwsdfsdf'
                    'pivotType' = 'deviceId'
                }, @{
                    'name' = 'var2'
                    'dataType' = 'double'
                    'value' = 'asdfwsdfsdf'
                    'pivotType' = 'sha256'
                }
            'matchEndpoints' = @{
                'filters' = @(
                    @{
                        'ids' = @(
                            '7076e453-662f-40b9-bac6-5589691bd6de',
                            '7edf66a6-325f-40a3-bcb6-3b63ecbcba74'
                        )
                    }
                )
            }
        }
        $query = Invoke-SophosCentralXDRQueryRun -CustomBody $body
    .EXAMPLE
        $query = Invoke-SophosCentralXDRQueryRun -Query "SELECT name, meta_hostname FROM xdr_data WHERE query_name = 'windows_startup_items'  AND name = 'someSVC'" -From (Get-Date).AddDays(-7) -to get-date
    .EXAMPLE
        $query = Invoke-SophosCentralXDRQueryRun -Query "SELECT name, meta_hostname FROM xdr_data WHERE query_name = 'windows_startup_items'  AND name = 'imDmsSvc'" -From (Get-Date).AddDays(-7) -to get-date
    .LINK
        https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/runs/post
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'SavedQuery')]
        [string]$categoryId,
        
        [Parameter(Mandatory = $true, ParameterSetName = 'SavedQuery')]
        [string]$queryId,

        [Parameter(Mandatory = $true, ParameterSetName = 'CustomBody')]
        [hashtable]$customBody,

        [Parameter(Mandatory = $true, ParameterSetName = 'CustomQuery')]
        [string]$Query,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'SavedQuery')]
        [ValidateScript({
                if ($_.GetType().Name -eq 'DateTime') {
                    return $true
                } else {
                    #match this duration format https://en.wikipedia.org/wiki/ISO_8601#Durations
                    $regex = '^[-+]?P(?!$)(([-+]?\d+Y)|([-+]?\d+\.\d+Y$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?(([-+]?\d+W)|([-+]?\d+\.\d+W$))?(([-+]?\d+D)|([-+]?\d+\.\d+D$))?(T(?=[\d+-])(([-+]?\d+H)|([-+]?\d+\.\d+H$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?([-+]?\d+(\.\d+)?S)?)??$'
                    if ($_ -match $regex) {
                        return $true
                    } else {
                        throw 'Invaid From time - should be either a [datetime] or a ISO_8601 duration'
                    }
                }
            })]
        $From,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'SavedQuery')]
        [ValidateScript({
                if ($_.GetType().Name -eq 'DateTime') {
                    return $true
                } else {
                    #match this duration format https://en.wikipedia.org/wiki/ISO_8601#Durations
                    $regex = '^[-+]?P(?!$)(([-+]?\d+Y)|([-+]?\d+\.\d+Y$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?(([-+]?\d+W)|([-+]?\d+\.\d+W$))?(([-+]?\d+D)|([-+]?\d+\.\d+D$))?(T(?=[\d+-])(([-+]?\d+H)|([-+]?\d+\.\d+H$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?([-+]?\d+(\.\d+)?S)?)??$'
                    if ($_ -match $regex) {
                        return $true
                    } else {
                        throw 'Invaid To time - should be either a [datetime] or a ISO_8601 duration'
                    }
                }
            })]
        $To,

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [string]$queryName = 'AdHoc',

        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'SavedQuery')]
        [array]$ids,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'CustomQuery')]
        [Parameter(Mandatory = $false, ParameterSetName = 'SavedQuery')]
        [array]$variables
    )
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/xdr-query/v1/queries/runs')
    if ($PSCmdlet.ParameterSetName -eq 'CustomBody') {
        Write-Verbose 'Custom Body'
        $body = $customBody
    } else {
        $body = @{}
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
        }
        $body.variables = $variables
        if ($From) {
            if ($From.GetType().name -eq 'DateTime') {
                $body.from = $From | Get-Date -AsUTC -Format 'yyyy-MM-dd"t"hh:mm:ssZ'
            } else {
                $body.from = $From
            }
        }
        if ($To) {
            if ($To.GetType().name -eq 'DateTime') {
                $body.to = $To | Get-Date -AsUTC -Format 'yyyy-MM-dd"t"hh:mm:ssZ'
            } else {
                $body.to = $To
            }
        }
        if ($ids) {
            $endpointFilters += @{ids = $ids }
        }   
        if ($endpointFilters) {
            $body.matchEndpoints = @{
                'filters' = @(
                    @{
                        'ids' = $ids
                    }
                )
            }
        }
        if ($PSCmdlet.ParameterSetName -eq 'CustomQuery') {
            Write-Verbose 'Custom Query'
            $body.adHocQuery = @{
                'template' = $query
                'name'     = $queryName
            }
        } else {     
            Write-Verbose 'Canned Query'
            $body.savedQuery = @{
                'queryId'    = $queryId
                'categoryId' = $categoryId
            }
            if ($variables) {
                $body.variables = $variables
            }
        }
    }
    Write-Verbose ($body | ConvertTo-Json -Depth 5)
    Write-Verbose $uri
    Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $Body
}