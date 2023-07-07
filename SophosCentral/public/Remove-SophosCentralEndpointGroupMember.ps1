function Remove-SophosCentralEndpointGroupMember {
    <#
    .SYNOPSIS
        Remove endpoints from a group.
    .DESCRIPTION
        Remove endpoints from a group.
    .PARAMETER ID
        The ID of the group
    .PARAMETER EndpointID
        The ID of the endpoint(s) to remove
    .EXAMPLE
        Remove-SophosCentralEndpointGroupMember -ID "14912b3f-d052-49c4-8367-495a72d8013f" -EndpointID "12345678-1234-1234-1234-123456789012"
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoint-groups/%7BgroupId%7D/endpoints/delete
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

        [ValidateScript({
                foreach ($id in $_) {
                    if ($false -eq [System.Guid]::TryParse($id, $([ref][guid]::Empty))) {
                        throw 'Not a valid GUID'
                    }
                }
                if ($_.Count -ge 1000) {
                    throw 'Too many endpoints specified, please specify less than 1000'
                }
                if ($_.Count -ne ($_ | Select-Object -Unique).Count) {
                    throw 'Duplicate endpoints specified, please specify each endpoint only once'
                }

                return $true
            })]
        [string[]]$EndpointID,

        [switch]$Force
    )
    Test-SophosCentralConnected

    $body = @{
        ids = $EndpointID
    }

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoint-groups/' + $ID + '/endpoints')

    if ($Force -or $PSCmdlet.ShouldProcess('Remove group members', ($ID))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Delete -Body $body
    }
}
