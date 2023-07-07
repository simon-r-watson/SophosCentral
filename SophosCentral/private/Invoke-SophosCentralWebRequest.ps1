function Invoke-SophosCentralWebRequest {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.URI]$Uri,

        [System.Collections.Hashtable]$CustomHeader,

        [ValidateSet('Get', 'Post', 'Put', 'Patch', 'Delete')]
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


    #inital request
    $webRequest = @{
        Uri             = $uri
        Headers         = $header
        UseBasicParsing = $true
        Method          = $Method
    }
    if (($null -eq $body) -and ($Method -in ('Post', 'Put'))) {
        #API endpoints that use a 'post'/'put' require a body. If no body is present it will give an error back, so supply an empty body
        $bodyTmp = @{} | ConvertTo-Json
        $webRequest.Add('Body', $bodyTmp)
    } elseif (($null -ne $Body) -and ($Method -eq 'Get')) {
        $webRequest.Add('Body', $Body)
    } elseif ($null -ne $Body) {
        $webRequest.Add('Body', ($Body | ConvertTo-Json -Depth 5))
    }

    if ($Method -notin ('Delete', 'Get')) {
        $webRequest.Add('ContentType', 'application/json')
    }

    #query api and return the first page
    $response = Invoke-RestMethod @webRequest
    if ($null -ne $response.items) {
        $response.items
    } else {
        $response
    }

    #pagination
    $finished = $false
    if ($response.pages.total -gt 1) {
        #enterprise/partner tenant pagination - based on total returned from the initial lookup
        #see here for details on pagination https://developer.sophos.com/getting-started > step 4
        #doco says the initial page is 1, so the following pages start at 2 onwards
        for ($i = 2; $i -le $response.pages.total; $i++) {
            $webRequest['Uri'] = $uri.AbsoluteUri.Replace('pageTotal=true', "page=$($i.ToString())")

            $responseLoop = Invoke-RestMethod @webRequest
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
                if ($uri.AbsoluteUri -like '*`?*') {
                    $webRequest['Uri'] = $uri.AbsoluteUri + '&pageFromKey=' + $response.pages.nextKey
                } else {
                    $webRequest['Uri'] = $uri.AbsoluteUri + '?pageFromKey=' + $response.pages.nextKey
                }
                $response = Invoke-RestMethod @webRequest
                $response.items
            } else {
                $finished = $true
            }
        } while ($finished -eq $false)
    }
}
