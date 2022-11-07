function Get-SophosCentralLiveDiscoverQueryRun {
    <#
    .SYNOPSIS
        Get the list of query runs, or return the results of one run
    .DESCRIPTION
        Get the list of query runs, or return the results of one run
    .EXAMPLE
         Get-SophosCentralLiveDiscoverQueryRun
    .EXAMPLE
        Get-SophosCentralLiveDiscoverQueryRun -RunID 'a9a5c6a3-5467-4bf3-87b0-ebdd4022056a'
    .EXAMPLE
        Get-SophosCentralLiveDiscoverQueryRun-RunID 'a9a5c6a3-5467-4bf3-87b0-ebdd4022056a' -Results
    .LINK
        https://developer.sophos.com/docs/live-discover-v1/1/routes/queries/runs/get
    .LINK
        https://developer.sophos.com/docs/live-discover-v1/1/routes/queries/runs/%7BrunId%7D/get
    .LINK
        https://developer.sophos.com/docs/live-discover-v1/1/routes/queries/runs/%7BrunId%7D/results/get
    #>
    [CmdletBinding(DefaultParameterSetName='nullParam')]
    param (
        [Parameter(Mandatory = $false, ParameterSetName = 'Results')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Endpoints')]
        [Parameter(Mandatory = $false,  ParameterSetName = 'Default')]
        [array]$Sort,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [Parameter(Mandatory = $false, ParameterSetName = 'RunID')]
        [array]$Fields,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [string]$QueryId,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [string]$CategoryId,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [ValidateSet('pending', 'started', 'finished')]
        [array]$Status,

        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [ValidateSet('notAvailable', 'succeeded', 'failed', 'timedOut')]
        [array]$Result,
        
        [Parameter(Mandatory = $false, ParameterSetName = 'Default')]
        [ValidateSet('service', 'user')]
        [array]$createdByPrincipalType,

        [Parameter(Mandatory = $true, ParameterSetName = 'Results')]
        [Parameter(Mandatory = $true, ParameterSetName = 'Endpoints')]
        [Parameter(Mandatory = $true, ParameterSetName = 'RunID')]
        [string]$RunID,

        [Parameter(Mandatory = $true, ParameterSetName = 'Results')]
        [switch]$Results,

        [Parameter(Mandatory = $true, ParameterSetName = 'Endpoints')]
        [switch]$Endpoints
    )

    $uriChild = '/live-discover/v1/queries/runs'
    if ($null -ne $RunID) {
        $uriChild = $uriChild + '/' + $RunID
        if ($Results -eq $true) {
            $uriChild = $uriChild + '/results'
        }
        if ($endpoints -eq $true) {
            $uriChild = $uriChild + '/endpoints'
        }
    }
    $uriChild = $uriChild + '?pageTotal=true'
    
    $uriTemp = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    $filteredPsBoundParameters=$PsBoundParameters
    #filter out parameters not needed for Query
    $null=("Results","Endpoints","RunID")|foreach-object {$filteredPsBoundParameters.Remove($_)}
    $uri = New-UriWithQuery -Uri $uriTemp -OriginalPsBoundParameters $filteredPsBoundParameters
    Invoke-SophosCentralWebRequest -Uri $uri
}