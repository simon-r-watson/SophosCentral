function New-UriWithQuery {
    [CmdletBinding()]
    [OutputType([System.Uri])]
    param (
        [Parameter(Mandatory = $true)]
        [System.Uri]$Uri,

        [Parameter(Mandatory = $true)]
        [hashtable]$OriginalPsBoundParameters
    )

    $uriBuilder = [System.UriBuilder]::New($Uri.AbsoluteUri)
    
    $blockedKeys = 'Verbose', 'Force', 'Debug', 'WhatIf'
    $keys = $OriginalPsBoundParameters.Keys | Where-Object { $blockedKeys -notcontains $_ } 
    
    foreach ($param in $keys) {
        if (($null -ne $OriginalPsBoundParameters[$param]) -and ($null -ne $param)) {
            $paraCaseSensitive = $param.ToString()[0].ToString().ToLower() + $param.ToString().Substring(1)
            if ( $OriginalPsBoundParameters[$param] -is [array]) {
                $queryPart = $paraCaseSensitive + '=' + ($OriginalPsBoundParameters[$param] -join ",")
            } else {
                $queryPart = $paraCaseSensitive + '=' + $OriginalPsBoundParameters[$param]
            }
            if (($null -eq $uriBuilder.Query) -or ($uriBuilder.Query.Length -le 1 )) {
                $uriBuilder.Query = $queryPart
            } else {
                $uriBuilder.Query = $uriBuilder.Query.Substring(1) + '&' + $queryPart
            }
        }
    }

    [System.Uri]::New($uriBuilder.Uri)
}
