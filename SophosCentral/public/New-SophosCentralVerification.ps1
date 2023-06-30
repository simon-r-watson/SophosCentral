function New-SophosCentralVerification {
    <#
    .SYNOPSIS
        Create a new verification/attestation for the given user.
    .DESCRIPTION
        Create a new verification/attestation for the given user.
    .PARAMETER UserId
        Id of the user in Sophos Central
    .PARAMETER Title
        Title of the verification/attestation
    .PARAMETER Question
        Question to ask the user
    .EXAMPLE
        $response = New-SophosCentralVerification -UserId "57e7f67f-6c1a-4580-a031-65f38a229732" -Title "Security question" -Question "Did you sign in to your account recently"
    .LINK
        https://developer.sophos.com/docs/user-activity-verification-v1/1/routes/attestations/post
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
        [string]$UserId,

        [Parameter(Mandatory = $true)]
        [string]$Title,

        [Parameter(Mandatory = $true)]
        [string]$Question
    )
    Test-SophosCentralConnected
    Show-UntestedWarning

    $uriChild = '/user-activity-verification/v1/attestations'
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)

    $body = @{
        userId   = $UserId
        title    = @{
            text = $Title
        }
        question = @{
            text = $Question
        }
    }


    if ($Force -or $PSCmdlet.ShouldProcess('New verification/attestation', ($Name))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
    }
}
