function Get-SophosCentralEndpointWebControlTLSDecryption {
    <#
    .SYNOPSIS
        Get settings for SSL/TLS decryption of HTTPS websites.
    .DESCRIPTION
        Get settings for SSL/TLS decryption of HTTPS websites.
    .EXAMPLE
        Get-SophosCentralEndpointWebControlTLSDecryption
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/web-control/tls-decryption/get
    #>
    [CmdletBinding()]
    param (
    )
    Test-SophosCentralConnected

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/web-control/tls-decryption')
    Invoke-SophosCentralWebRequest -Uri $uri
}
