function Remove-SophosCentralAccessToken {
    <#
    .SYNOPSIS
        Revoke access token for a tenant.
    .DESCRIPTION
        Revoke access token for a tenant.
    .EXAMPLE
        Remove-SophosCentralAccessToken
    .LINK
        https://developer.sophos.com/docs/accounts-v1/1/routes/access-tokens/%7BtokenId%7D/delete
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory = $true)]
        [Alias('ID')]
        [string[]]$TokenID
    )
    Test-SophosCentralConnected

    foreach ($token in $TokenID) {
        $uri = [System.Uri]::New("$($SCRIPT:SophosCentral.GlobalEndpoint)/accounts/v1/access-tokens/$($token)")
        if ($Force -or $PSCmdlet.ShouldProcess('Remove access token', $token)) {
            Invoke-SophosCentralWebRequest -Uri $uri -Method Delete
        }
    }
}
