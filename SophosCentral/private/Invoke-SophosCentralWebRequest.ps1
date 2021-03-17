function Invoke-SophosCentralWebRequest {
    [CmdletBinding()]
    param (
        [System.URI]$Uri,
        [System.Collections.Hashtable]$CustomHeader,

        [ValidateSet('Get','Set')]
        [string]$Method = 'Get',

        [System.Collections.Hashtable]$Body
    )

    if ($null -ne $CustomHeader) {
        $header = $CustomHeader
    }
    else {
        $header = Get-SophosCentralAuthHeader
    }
    $finished = $false

    if ($method -eq 'Get') {
        #query api and return the first page
        $response = Invoke-RestMethod -Uri $uri -Headers $header
        $response.items
        
        #loop through additional pages of results (if applicable)
        do {
            if ($response.pages.nextKey) {
                $nextUri = $uri.AbsoluteUri + '?pageFromKey=' + $response.pages.nextKey
                $response = Invoke-RestMethod -Uri $nextUri -Headers $header
                $response.items
            }
            else {
                $finished = $true
            }
        } while ($finished -eq $false)
    } elseif ($method -eq 'Post') {
        if ($null -eq $body) {
            $body = @{}
            $bodyJson = $body | Convertto-Json
        }
        Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $bodyJson -ContentType 'application/json'
    }
}