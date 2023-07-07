function Get-SophosCentralXDRQuery {
    <#
    .SYNOPSIS
        Get the details of a query.
    .DESCRIPTION
        Get the details of a query.
    .EXAMPLE
        Get-SophosCentralXDRQuery
    .LINK
        https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/%7BqueryId%7D/get
    .LINK
        https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/get
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$QueryID
    )

    Show-UntestedWarning

    $uriChild = '/xdr-query/v1/queries'
    if ($null -ne $QueryID) {
        $uriChild = $uriChild + '/' + $QueryID
    }
    $uriChild = $uriChild + '?pageTotal=true'

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}
