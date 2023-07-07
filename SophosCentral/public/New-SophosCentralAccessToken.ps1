function New-SophosCentralAccessToken {
    <#
    .SYNOPSIS
        Create access token for a tenant. Currently the only type is 'sophosLinuxSensor'
    .DESCRIPTION
        Create access token for a tenant. Currently the only type is 'sophosLinuxSensor'
    .EXAMPLE
        New-SophosCentralAccessToken
    .LINK
        https://developer.sophos.com/docs/accounts-v1/1/routes/access-tokens/post
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Label,

        [Parameter(Mandatory = $true)]
        [ValidateSet('sophosLinuxSensor')]
        [string]$Type,

        [datetime]$ExpiresAt
    )
    Test-SophosCentralConnected

    $body = @{
        label = $Label
        type  = $Type
    }
    if ($ExpiresAt) { $body.Add('expiresAt', $ExpiresAt) }

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.GlobalEndpoint + '/accounts/v1/access-tokens')
    Invoke-SophosCentralWebRequest -Uri $uri -Body $body -Method Post
}
