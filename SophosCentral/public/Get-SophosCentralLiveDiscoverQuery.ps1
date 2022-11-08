function Get-SophosCentralLiveDiscoverQuery {
    <#
    .SYNOPSIS
        Get queries matching the given filters.
    .DESCRIPTION
        Get queries matching the given filters.
    .EXAMPLE
        Get-SophosCentralLiveDiscoverQuery
    .LINK
        https://developer.sophos.com/docs/live-discover-v1/1/routes/queries/get
    .LINK
        https://developer.sophos.com/docs/live-discover-v1/1/routes/queries/%7BqueryId%7D/get
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$categoryId,

        [Parameter(Mandatory = $false)]
        [string]$search,

        [Parameter(Mandatory = $false)]
        [array]$searchFields,        
        
        [Parameter(Mandatory = $false)]
        [ValidateSet('categories', 'code', 'createdAt', 'dataSource', 'description', 'id', 'name', 'performance', 'supportedOSes', 'template', 'type', 'variables')]
        [array]$Fields,

        [Parameter(Mandatory = $false)]
        [string]$QueryID
    )

    $uriChild = '/live-discover/v1/queries'
    if ($null -ne $QueryID) {
        $uriChild = $uriChild + '/' + $QueryID
    }
    $uriChild = $uriChild + '?pageTotal=true'
    
    $uriTemp = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    $uri = New-UriWithQuery -Uri $uriTemp -OriginalPsBoundParameters $PsBoundParameters
    Invoke-SophosCentralWebRequest -Uri $uri
}