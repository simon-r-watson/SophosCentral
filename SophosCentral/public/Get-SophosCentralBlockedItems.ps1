function Get-SophosCentralBlockedItems {
    <#
    .SYNOPSIS
        Get Endpoint blocked Items
    .DESCRIPTION
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/blocked-items/get
    .EXAMPLE
        Get-SophosCentralBlockedItems
    #>
    $uriChild = '/endpoint/v1/settings/blocked-items'
    $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}