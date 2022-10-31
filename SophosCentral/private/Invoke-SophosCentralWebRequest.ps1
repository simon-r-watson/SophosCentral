function Invoke-SophosCentralWebRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.URI]$Uri,
        
        [System.Collections.Hashtable]$CustomHeader,

        [ValidateSet('Get', 'Post', 'Put', 'Delete')]
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
        
        if ($response.pages.total -gt 1) {
            #enterprise/partner tenant pagination - based on total returned from the initial lookup
            #see here for details on pagination https://developer.sophos.com/getting-started > step 4
            #doco says the initial page is 1, so the following pages start at 2 onwards
            for ($i = 2; $i -lt $response.pages.total; $i++) {
                $nextUri = $uri.AbsoluteUri.Replace('pageTotal=true', 'page=') + $i.ToString()
                $responseLoop = Invoke-RestMethod -Uri $nextUri -Headers $header -UseBasicParsing
                if ($null -ne $response.items) {
                    $responseLoop.items
                } else {
                    $responseLoop
                }
            }
        } else {
            #standard pagination - based on nextKey value returned from the previous lookup
            do {
                if ($response.pages.nextKey) {
                    if ($uri.AbsoluteUri -like '*``?*') {
                        $nextUri = $uri.AbsoluteUri + '&pageFromKey=' + $response.pages.nextKey
                    } else {
                        $nextUri = $uri.AbsoluteUri + '?pageFromKey=' + $response.pages.nextKey
                    }
                    $response = Invoke-RestMethod -Uri $nextUri -Headers $header -UseBasicParsing
                    $response.items
                } else {
                    $finished = $true
                }
            } while ($finished -eq $false)
        }
        
    }

    #Post/Put request
    if ($method -in ('Post', 'Put')) {
        #API endpoints that use a 'post'/'put' require a body. If no body is present it will give an error back, so supply an empty body
        if ($null -eq $body) {
            $body = @{}
        }
        $bodyJson = $body | ConvertTo-Json
        
        #query api and return the first page
        $response = Invoke-RestMethod -Uri $uri -Headers $header -Method $method -Body $bodyJson -ContentType 'application/json' -UseBasicParsing 
        if ($null -ne $response.items) {
            $response.items
        } else {
            $response
        }
        #loop through additional pages of results (if applicable)
        do {
            if ($response.pages.nextKey) {
                $nextUri = $uri.AbsoluteUri + '?pageFromKey=' + $response.pages.nextKey
                $response = Invoke-RestMethod -Uri $nextUri -Headers $header -Method $method -Body $bodyJson -ContentType 'application/json' -UseBasicParsing 
                $response.items
            } else {
                $finished = $true
            }
        } while ($finished -eq $false)
    }

    #Delete request
    if ($method -eq 'Delete') {        
        #query api and return the first page
        $response = Invoke-RestMethod -Uri $uri -Headers $header -Method Delete -ContentType 'application/json' -UseBasicParsing 
        if ($null -ne $response.items) {
            $response.items
        } else {
            $response
        }
        #loop through additional pages of results (if applicable)
        do {
            if ($response.pages.nextKey) {
                $nextUri = $uri.AbsoluteUri + '?pageFromKey=' + $response.pages.nextKey
                $response = Invoke-RestMethod -Uri $nextUri -Headers $header -Method Delete -ContentType 'application/json' -UseBasicParsing 
                $response.items
            } else {
                $finished = $true
            }
        } while ($finished -eq $false)
    }
}