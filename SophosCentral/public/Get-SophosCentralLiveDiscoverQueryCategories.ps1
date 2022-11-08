function Get-SophosCentralLiveDiscoverQueryCategories {
    <#
    .SYNOPSIS
        Get queries matching the given filters.
    .DESCRIPTION
        Get queries matching the given filters.
    .EXAMPLE
       Get-SophosCentralLiveDiscoverQueryCategories
    .LINK
        https://developer.sophos.com/docs/live-discover-v1/1/routes/queries/get
    #>
    [CmdletBinding()]
    param (  
        [Parameter(Mandatory = $false)]
        [array]$Fields,

        [Parameter(Mandatory = $false)]
        [string]$CategoryID
    )

    $uriChild = '/live-discover/v1/queries/categories'
    if ($null -ne $categoryID) {
        $uriChild = $uriChild + '/' + $categoryID
    }
    $uriChild = $uriChild + '?pageTotal=true'
    $uriTemp = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    $uri = New-UriWithQuery -Uri $uriTemp -OriginalPsBoundParameters $PsBoundParameters
    
    Invoke-SophosCentralWebRequest -Uri $uri
    
}