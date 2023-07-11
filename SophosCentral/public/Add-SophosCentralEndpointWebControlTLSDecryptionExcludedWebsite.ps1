function Add-SophosCentralEndpointWebControlTLSDecryptionExcludedWebsite {
    <#
    .SYNOPSIS
        Add websites excluded from SSL/TLS decryption.
    .DESCRIPTION
        Add websites excluded from SSL/TLS decryption.
    .EXAMPLE
        Add-SophosCentralEndpointWebControlTLSDecryptionExcludedWebsite
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/web-control/tls-decryption/excluded-websites/patch
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
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
        add = @($entry)
    }

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/web-control/tls-decryption/excluded-websites')

    if ($Force -or $PSCmdlet.ShouldProcess('Add TLS excluded website', ($Website))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Patch -Body $body
    }
}
