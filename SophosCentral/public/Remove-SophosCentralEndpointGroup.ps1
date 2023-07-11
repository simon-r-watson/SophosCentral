function Remove-SophosCentralEndpointGroup {
    <#
    .SYNOPSIS
        Delete endpoint group.
    .DESCRIPTION
        Delete endpoint group.
    .PARAMETER ID
        The ID of the group
    .EXAMPLE
        Remove-SophosCentralEndpointGroup -ID "12345678-1234-1234-1234-123456789012"
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoint-groups/%7BgroupId%7D/delete
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

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoint-groups/' + $ID)

    if ($Force -or $PSCmdlet.ShouldProcess($ID, ('Remove group'))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Delete -Body $body
    }
}
