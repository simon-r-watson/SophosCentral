function Get-SophosCentralXDRQueryCategory {
    <#
    .SYNOPSIS
        Fetch all categories, built-in as well as custom
    .DESCRIPTION
        Fetch all categories, built-in as well as custom
    .EXAMPLE
        Get-SophosCentralXDRQueryCategory
    .LINK
        https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/categories/get
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$CategoryID
    )

    Show-UntestedWarning

    $uriChild = '/xdr-query/v1/queries/categories'
    if ($null -ne $CategoryID) {
        $uriChild = $uriChild + '/' + $CategoryID
    }
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}
