function Remove-SophosCentralEndpointWebControlTLSDecryptionExcludedWebsite {
    <#
    .SYNOPSIS
        Remove websites excluded from SSL/TLS decryption.
    .DESCRIPTION
        Remove websites excluded from SSL/TLS decryption.
    .EXAMPLE
        Remove-SophosCentralEndpointWebControlTLSDecryptionExcludedWebsite
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/web-control/tls-decryption/excluded-websites/patch
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({
                $regex = '^[-:0-9a-z./]{3,2048}$'
                if ($_ -match $regex) {
                    return $true
                } else {
                    throw "See 'Get-Help Add-SophosCentralEndpointWebControlTLSDecryptionExcludedWebsite -Examples' for some examples"
                }
            })]
        [string]$Website,

        [ValidateScript({
                $regex = "^[-\p{L}\p{Nl}\d ,.']{0,300}$"
                if ($_ -match $regex) {
                    return $true
                } else {
                    throw "See 'Get-Help Add-SophosCentralEndpointWebControlTLSDecryptionExcludedWebsite -Examples' for some examples"
                }
            })]
        [string]$Comment,

        [switch]$Force
    )
    Test-SophosCentralConnected
    $entry = @{
        value = $Website
    }
    if ($Comment) { $entry.Add('comment', $Comment ) }

    $body = @{
        remove = @($entry)
    }

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/web-control/tls-decryption/excluded-websites')

    if ($Force -or $PSCmdlet.ShouldProcess('Add TLS excluded website', ($Website))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Patch -Body $body
    }
}
