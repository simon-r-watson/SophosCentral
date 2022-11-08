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
        $query = Invoke-SophosCentralLiveDiscoverQueryRun -Query $body -verbose
   
    .LINK
        https://developer.sophos.com/docs/Live-Discover-query-v1/1/routes/queries/runs/post
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'Custom Query')]
        [hashtable]$Query
    )
    
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/live-discover/v1/queries/runs')
    Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $Query
}