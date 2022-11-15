function Remove-SophosCentralUser {
    <#
    .SYNOPSIS
        Delete a user by ID
    .DESCRIPTION
        Delete a user by ID
    .EXAMPLE
        Remove-SophosCentralUser -UserID 8a823dcd-5f09-463b-a5f3-e019cf280d79
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/directory/users/%7BuserId%7D/delete
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('ID')]
        [string[]]$UserID
    )
    Test-SophosCentralConnected
    
    foreach ($idTmp in $UserID) {
        $uri = [System.Uri]::New("$($SCRIPT:SophosCentral.RegionEndpoint)/common/v1/directory/users/$($idTmp)")
        if ($Force -or $PSCmdlet.ShouldProcess('Remove user', $idTmp)) {
            Invoke-SophosCentralWebRequest -Uri $uri -Method Delete
        }
    }
}