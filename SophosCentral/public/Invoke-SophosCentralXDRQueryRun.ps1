function Invoke-SophosCentralXDRQueryRun {
    <#
    .SYNOPSIS
        Run a query against the Sophos Data Lake.
    .DESCRIPTION
        Run a query against the Sophos Data Lake.

        The values in the example bodies below may not be correct (such as the variables sub hashtables), but the structure of the hashtable should be correct
    .PARAMETER CustomBody
        The query to run as a hashtable, see this for query options - https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/runs/post
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
        $body = @{
            'savedQuery' = @{
                'queryId' = '4c966626-8dac-47a5-920e-2a31c7eeacba'
            }
        }
        $query = Invoke-SophosCentralXDRQueryRun -CustomBody $body
    .LINK
        https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/runs/post
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Custom Query')]
        [hashtable]$CustomBody
    )
    
   
    
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/xdr-query/v1/queries/runs')
    Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $CustomBody
}