function New-UriWithQuery {
    [CmdletBinding()]
    [OutputType([System.Uri])]
    param (
        [Parameter(Mandatory = $true)]
        [System.Uri]$Uri,

        [Parameter(Mandatory = $true)]
        [hashtable]$OriginalPsBoundParameters,

        [Parameter(Mandatory = $false)]
        [Alias('filteredParmeters')]
        [array]$FilteredParameters
    )

    $uriBuilder = [System.UriBuilder]::New($Uri.AbsoluteUri)
    $blockedKeys = 'Verbose', 'Force', 'Debug', 'WhatIf' + $FilteredParameters
    $keys = $OriginalPsBoundParameters.Keys | Where-Object { $blockedKeys -notcontains $_ } 
    
    foreach ($param in $keys) {
        if (($null -ne $OriginalPsBoundParameters[$param]) -and ($null -ne $param)) {
            $paraCaseSensitive = $param.ToString()[0].ToString().ToLower() + $param.ToString().Substring(1)
            if ( $OriginalPsBoundParameters[$param] -is [array]) {
                $queryPart = $paraCaseSensitive + '=' + ($OriginalPsBoundParameters[$param] -join ',')
            } else {
                #convert time time to ISO 8601 Universal Format Specifier
                if ($OriginalPsBoundParameters[$param].GetType().Name -eq 'DateTime') {
                    $OriginalPsBoundParameters[$param] = $OriginalPsBoundParameters[$param].ToUniversalTime().ToString('u').Replace(' ', 'T')
                }
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
