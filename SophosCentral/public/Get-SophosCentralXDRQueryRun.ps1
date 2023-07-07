function Get-SophosCentralXDRQueryRun {
    <#
    .SYNOPSIS
        Get the list of query runs, or return the results of one run
    .DESCRIPTION
        Get the list of query runs, or return the results of one run
    .EXAMPLE
        Get-SophosCentralXDRQueryRun
    .EXAMPLE
        Get-SophosCentralXDRQueryRun -RunID 'a9a5c6a3-5467-4bf3-87b0-ebdd4022056a'
    .EXAMPLE
        Get-SophosCentralXDRQueryRun -RunID 'a9a5c6a3-5467-4bf3-87b0-ebdd4022056a' -Results
    .LINK
        https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/runs/get
    .LINK
        https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/runs/%7BrunId%7D/get
    .LINK
        https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/runs/%7BrunId%7D/results/get
    #>
    [CmdletBinding(DefaultParameterSetName = 'nullParam')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Run ID')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Results')]
        [string]$RunID,

        [Parameter(Mandatory = $true, ParameterSetName = 'Results')]
        [switch]$Results
    )

    $uriChild = '/xdr-query/v1/queries/runs'
    if ($null -ne $RunID) {
        $uriChild = $uriChild + '/' + $RunID
        if ($Results -eq $true) {
            $uriChild = $uriChild + '/results'
        }
    }
    $uriChild = $uriChild + '?pageTotal=true'

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}
