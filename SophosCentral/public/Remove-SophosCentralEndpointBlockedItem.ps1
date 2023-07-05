function Remove-SophosCentralEndpointBlockedItem {
    <#
    .SYNOPSIS
        Deletes the specified blocked item.
    .DESCRIPTION
        Deletes the specified blocked item.
    .EXAMPLE
        Remove-SophosCentralEndpointBlockedItem -ID "6308b835-2131-4d46-975d-6f6efde366c5"

        List all blocked items in the tenant
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/blocked-items/%7BblockedItemId%7D/delete
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]

    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if ($false -eq [System.Guid]::TryParse($_, $([ref][guid]::Empty))) {
                    throw 'Not a valid GUID'
                } else {
                    return $true
                }
            })]
        [string]$ID,

        [switch]$Force
    )
    Test-SophosCentralConnected

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/blocked-items/' + $ID)

    if ($Force -or $PSCmdlet.ShouldProcess('Remove item', ($ID))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Delete
    }
}
