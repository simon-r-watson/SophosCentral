function Invoke-SophosCentralWebRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.URI]$Uri,
        
        [System.Collections.Hashtable]$CustomHeader,

        [ValidateSet('Get', 'Post')]
        [string]$Method = 'Get',

        [System.Collections.Hashtable]$Body
    )

    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Warning 'Unsupported version of PowerShell detected'
    }
    
    if ($null -ne $CustomHeader) {
        $header = $CustomHeader
    } else {
        try {
            $header = Get-SophosCentralAuthHeader
        } catch {
            throw $_
        }
    }
    $finished = $false

    #Get request
    if ($method -eq 'Get') {
        #query api and return the first page
        $response = Invoke-RestMethod -Uri $uri -Headers $header -UseBasicParsing
        if ($null -ne $response.items) {
            $response.items
        } else {
            $response
        }
        
        #loop through additional pages of results (if applicable)
        do {
            if ($response.pages.nextKey) {
                $nextUri = $uri.AbsoluteUri + '?pageFromKey=' + $response.pages.nextKey
                $response = Invoke-RestMethod -Uri $nextUri -Headers $header -UseBasicParsing
                $response.items
            } else {
                $finished = $true
            }
        } while ($finished -eq $false)
        
    }

    #Post request
    if ($method -eq 'Post') {
        #API endpoints that use a 'post' require a body. If no body is present it will give an error back, so supply an empty body
        if ($null -eq $body) {
            $body = @{}
        }
        $bodyJson = $body | ConvertTo-Json
        
        #query api and return the first page
        $response = Invoke-RestMethod -Uri $uri -Headers $header -Method Post -Body $bodyJson -ContentType 'application/json' -UseBasicParsing 
        if ($null -ne $response.items) {
            $response.items
        } else {
            $response
        }
        #loop through additional pages of results (if applicable)
        do {
            if ($response.pages.nextKey) {
                $nextUri = $uri.AbsoluteUri + '?pageFromKey=' + $response.pages.nextKey
                $response = Invoke-RestMethod -Uri $nextUri -Headers $header -Method Post -Body $bodyJson -ContentType 'application/json' -UseBasicParsing 
                $response.items
            } else {
                $finished = $true
            }
        } while ($finished -eq $false)
    }
}