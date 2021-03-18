function Connect-SophosCentral {
    <#
    .SYNOPSIS
        Connect to a Sophos Central using your client ID and client secret
    .DESCRIPTION
        Connect to a Sophos Central using your client ID and client secret

    .EXAMPLE
        Connect-SophosCentral -ClientID "asdkjsdfksjdf" -ClientSecret (Read-Host -AsSecureString -Prompt "Client Secret:")
    #>
    [CmdletBinding()]
    param (
        [String]$ClientID,
        [SecureString]$ClientSecret = (Read-Host -AsSecureString -Prompt "Client Secret:")
    )

    $loginUri = [System.Uri]::new('https://id.sophos.com/api/v2/oauth2/token')

    $body = @{
        grant_type    = 'client_credentials'
        client_id     = $ClientID
        client_secret = Unprotect-Secret -Secret $ClientSecret
        scope         = 'token'
    }
    $response = Invoke-WebRequest -Uri $loginUri -Body $body -ContentType 'application/x-www-form-urlencoded' -Method Post
    if ($response.Content) {
        $authDetails = $response.Content | ConvertFrom-Json
        $expiresAt = (Get-Date).AddSeconds($authDetails.expires_in - 60)
        $authDetails | Add-Member -MemberType NoteProperty -Name expires_at -Value $expiresAt
        $authDetails.access_token = $authDetails.access_token | ConvertTo-SecureString -AsPlainText -Force
        $GLOBAL:SophosCentral = $authDetails

        $tenantInfo = Get-SophosCentralTenantInfo
        $GLOBAL:SophosCentral | Add-Member -MemberType NoteProperty -Name GlobalEndpoint -Value $tenantInfo.apiHosts.global
        $GLOBAL:SophosCentral | Add-Member -MemberType NoteProperty -Name RegionEndpoint -Value $tenantInfo.apiHosts.dataRegion
        $GLOBAL:SophosCentral | Add-Member -MemberType NoteProperty -Name TenantID -Value $tenantInfo.id
        $GLOBAL:SophosCentral | Add-Member -MemberType NoteProperty -Name IDType -Value $tenantInfo.idType
    }
}