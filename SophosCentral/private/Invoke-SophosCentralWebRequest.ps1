function Invoke-SophosCentralWebRequest {
    [CmdletBinding()]
    param (
        [System.URI]$Uri,
        [System.Collections.Hashtable]$CustomHeader,

        [ValidateSet('Get', 'Set')]
        [string]$Method = 'Get',

        [System.Collections.Hashtable]$Body
    )

    if ($null -ne $CustomHeader) {
        $header = $CustomHeader
    }
    else {
        try {
            $header = Get-SophosCentralAuthHeader
        }
        catch {
            throw $_
        }
    }
    $finished = $false

    if ($method -eq 'Get') {
        #query api and return the first page
        $response = Invoke-RestMethod -Uri $uri -Headers $header -UseBasicParsing
        if ($response.items) {
            $response.items
        }
        else {
            $response
        }
        
        #loop through additional pages of results (if applicable)
        do {
            if ($response.pages.nextKey) {
                $nextUri = $uri.AbsoluteUri + '?pageFromKey=' + $response.pages.nextKey
                $response = Invoke-RestMethod -Uri $nextUri -Headers $header -UseBasicParsing
                $response.items
            }
            else {
                $finished = $true
            }
        } while ($finished -eq $false)
    }
    elseif ($method -eq 'Post') {
        if ($null -eq $body) {
            #Some API endpoints that use a 'post' request require an empty body. If no body is present it will give an error back
            $body = @{}
        }
        $bodyJson = $body | ConvertTo-Json
        Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $bodyJson -ContentType 'application/json'
    }
}