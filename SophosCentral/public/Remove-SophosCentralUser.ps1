function Remove-SophosCentralUser {
    <#
    .SYNOPSIS
        Revoke access token for a tenant.
    .DESCRIPTION
        Revoke access token for a tenant.
    .EXAMPLE
        Remove-SophosCentralUser -ID 8a823dcd-5f09-463b-a5f3-e019cf280d79
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/directory/users/%7BuserId%7D/delete
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('UserID')]
        [string[]]$ID
    )

    foreach ($idTmp in $ID) {
        $uri = [System.Uri]::New("$($SCRIPT:SophosCentral.RegionEndpoint)/common/v1/directory/users/$($idTmp)")
        if ($Force -or $PSCmdlet.ShouldProcess('Remove user', $idTmp)) {
            Invoke-SophosCentralWebRequest -Uri $uri -Method Delete
        }
    }
}