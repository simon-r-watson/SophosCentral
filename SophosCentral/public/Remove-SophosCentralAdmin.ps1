function Remove-SophosCentralAdmin {
    <#
    .SYNOPSIS
        Remove an admin by ID.
    .DESCRIPTION
        Remove an admin by ID.
    .EXAMPLE
        Remove-SophosCentralAdmin -UserID 8a823dcd-5f09-463b-a5f3-e019cf280d79
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/admins/%7BadminId%7D/delete
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('ID')]
        [string[]]$UserID
    )
    Test-SophosCentralConnected
    
    foreach ($idTmp in $UserID) {
        $uri = [System.Uri]::New("$($SCRIPT:SophosCentral.RegionEndpoint)/common/v1/admins/$($idTmp)")
        if ($Force -or $PSCmdlet.ShouldProcess('Remove admin', $idTmp)) {
            Invoke-SophosCentralWebRequest -Uri $uri -Method Delete
        }
    }
}