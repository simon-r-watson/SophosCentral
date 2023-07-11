function Clear-SophosCentralEndpointWebControlTLSDecryptionExcludedWebsite {
    <#
    .SYNOPSIS
        Clears the list of websites excluded from SSL/TLS decryption.
    .DESCRIPTION
        Clears the list of websites excluded from SSL/TLS decryption.
    .EXAMPLE
        Clear-SophosCentralEndpointWebControlTLSDecryptionExcludedWebsite
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/web-control/tls-decryption/excluded-websites/delete
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [switch]$Force
    )
    Test-SophosCentralConnected

    Write-Warning 'This will remove all TLS decryption excluded websites!'

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/web-control/tls-decryption/excluded-websites')

    if ($Force -or $PSCmdlet.ShouldProcess('Clear all TLS excluded website', ($null))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Delete
    }
}
