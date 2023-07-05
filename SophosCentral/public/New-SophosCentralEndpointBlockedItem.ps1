function New-SophosCentralEndpointBlockedItem {
    <#
    .SYNOPSIS
        Request to block an item. Items can only be blocked by their SHA256 checksums at this time.
    .DESCRIPTION
        Request to block an item. Items can only be blocked by their SHA256 checksums at this time.
    .EXAMPLE
        New-SophosCentralEndpointBlockedItem -SHA256Hash "7555E413C51F1113C7EF8E7B5F80855A8E7554B9A8C069360AB3713294B63072"

        List all blocked items in the tenant
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/blocked-items/post
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]

    param (
        [Parameter(Mandatory = $true)]
        [string]$SHA256Hash,

        [string]$FileName,

        [string]$Path,

        [Parameter(Mandatory = $true)]
        [string]$Comment,

        [string]$CertificateSigner,

        [switch]$Force
    )
    Test-SophosCentralConnected

    $body = @{
        type       = 'sha256'
        properties = @{
            sha256 = $SHA256Hash
        }
    }
    if ($FileName) { $body['properties'].Add('fileName', $FileName) }
    if ($Path) { $body['properties'].Add('path', $Path) }
    if ($Comment) { $body.Add('comment', $Comment) }
    if ($CertificateSigner) { $body['properties'].Add('certificateSigner', $CertificateSigner) }

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/blocked-items')

    if ($Force -or $PSCmdlet.ShouldProcess('Block item', ($SHA256Hash))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
    }
}
