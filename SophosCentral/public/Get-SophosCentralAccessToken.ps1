function Get-SophosCentralAccessToken {
    <#
    .SYNOPSIS
        Get all access tokens for a tenant. Currently the only type is 'sophosLinuxSensor'
    .DESCRIPTION
        Get all access tokens for a tenant. Currently the only type is 'sophosLinuxSensor'
    .EXAMPLE
        Get-SophosCentralAccessToken
    .LINK
        https://developer.sophos.com/docs/accounts-v1/1/routes/access-tokens/get
    #>
    [CmdletBinding()]
    param (
    )
    
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.GlobalEndpoint + '/accounts/v1/access-tokens')
    Invoke-SophosCentralWebRequest -Uri $uri
}