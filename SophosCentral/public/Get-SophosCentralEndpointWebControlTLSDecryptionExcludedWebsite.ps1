function Get-SophosCentralEndpointWebControlTLSDecryptionExcludedWebsite {
    <#
    .SYNOPSIS
        List of websites excluded from SSL/TLS decryption.
    .DESCRIPTION
        List of websites excluded from SSL/TLS decryption.
    .EXAMPLE
        Get-SophosCentralEndpointWebControlTLSDecryptionExcludedWebsite
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/web-control/tls-decryption/excluded-websites/get
    #>
    [CmdletBinding()]
    param (
    )
    Test-SophosCentralConnected

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/web-control/tls-decryption/excluded-websites')
    Invoke-SophosCentralWebRequest -Uri $uri
}
