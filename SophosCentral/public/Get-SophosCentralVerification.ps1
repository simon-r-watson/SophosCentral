function Get-SophosCentralVerification {
    <#
    .SYNOPSIS
        Get the results of a verification/attestation.
    .DESCRIPTION
        Get the results of a verification/attestation.
    .PARAMETER ID
        Id of verification/attestation
    .EXAMPLE
        $response = New-SophosCentralVerification -UserId "57e7f67f-6c1a-4580-a031-65f38a229732" -Title "Security question" -Question "Did you sign in to your account recently"
        Get-SophosCentralVerification -Id $response.id
    .LINK
        https://developer.sophos.com/docs/user-activity-verification-v1/1/routes/attestations/%7BattestationId%7D/get
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if ($false -eq [System.Guid]::TryParse($_, $([ref][guid]::Empty))) {
                    throw 'Not a valid GUID'
                } else {
                    return $true
                }
            })]
        [string]$ID
    )
    Test-SophosCentralConnected
    Show-UntestedWarning

    $uriChild = '/user-activity-verification/v1/attestations/' + $ID
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)

    Invoke-SophosCentralWebRequest -Uri $uri
}
