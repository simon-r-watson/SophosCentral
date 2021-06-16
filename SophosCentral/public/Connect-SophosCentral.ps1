function Connect-SophosCentral {
    <#
    .SYNOPSIS
        Connect to Sophos Central using your client ID and client secret, from you API credentials/service principal
    .DESCRIPTION
        Connect to Sophos Central using your client ID and client secret, from you API credentials/service principal

        Sophos customers can connect to their tenant using a client id/secret. Follow Step 1 here to create it
        https://developer.sophos.com/getting-started-tenant

        Sophos partners can use a partner client id/secret to connect to their customer tenants. Follow Step 1 here to create it
        https://developer.sophos.com/getting-started
    .PARAMETER ClientID
        The client ID from the Sophos Central API credential/service principal
    .PARAMETER ClientSecret
        The client secret from the Sophos Central API credential/service principal
    .PARAMETER SecretVault
        Login using a client ID and client secret retrieved from Secret Vault (Microsoft.PowerShell.SecretManagement).
        Setup example found in https://github.com/simon-r-watson/SophosCentral/wiki/AzureKeyVaultExample
    .PARAMETER AzKeyVault
        Use when the Secret Vault is stored in Azure Key Vault
        Uses the Microsoft.PowerShell.SecretManagement and Az.KeyVault modules for retrieving secrets
        Setup example found in https://github.com/simon-r-watson/SophosCentral/wiki/AzureKeyVaultExample
    .PARAMETER AccessTokenOnly
        Internal use (for this module) only. Used to generate a new access token when the current one expires
    .EXAMPLE
        Connect-SophosCentral -ClientID "asdkjsdfksjdf" -ClientSecret (Read-Host -AsSecureString -Prompt "Client Secret:")
    .EXAMPLE
        Connect-SophosCentral -SecretVaultAuth -AzKeyVault

        Connect using default values for Secret Key Vault name, Client ID name, and Client Secret name, with secret vault configured to use Azure Key Vault
    .EXAMPLE
        Connect-SophosCentral -SecretVaultAuth -AzKeyVault -SecretVaultName 'secrets' -SecretVaultClientIDName 'sophosclientid' -SecretVaultClientSecretName 'sophosclientsecret'

        Connect using custom Secret Vault name, Client ID Name, and Client Secret Name, with secret vault configured to use Azure Key Vault
    .EXAMPLE
        Connect-SophosCentral -SecretVaultAuth -SecretVaultName 'secrets' -SecretVaultClientIDName 'sophosclientid' -SecretVaultClientSecretName 'sophosclientsecret'

        Connect using custom Secret Vault name, Client ID Name, and Client Secret Name when using a locally stored Secret Vault (or another Microsoft.PowerShell.SecretManagement integration)
    .LINK
        https://developer.sophos.com/getting-started-tenant
    .LINK
        https://developer.sophos.com/getting-started
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'StdAuth')]
        [String]$ClientID,

        [Parameter(ParameterSetName = 'StdAuth')]
        [SecureString]$ClientSecret,
        
        [Parameter(ParameterSetName = 'StdAuth')]
        [Switch]$AccessTokenOnly,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'SecretVaultAuth')]
        [Switch]$SecretVault,

        [Parameter(ParameterSetName = 'SecretVaultAuth')]
        [Switch]$AzKeyVault,

        [Parameter(ParameterSetName = 'SecretVaultAuth')]
        [String]$SecretVaultName = 'AzKV',

        [Parameter(ParameterSetName = 'SecretVaultAuth')]
        [String]$SecretVaultClientIDName = 'SophosCentral-Partner-ClientID',

        [Parameter(ParameterSetName = 'SecretVaultAuth')]
        [String]$SecretVaultClientSecretName = 'SophosCentral-Partner-ClientSecret'
    )

    if ($PSVersionTable.PSVersion.Major -lt 7) {
        Write-Warning 'Unsupported version of PowerShell detected'
    }

    if ($PsCmdlet.ParameterSetName -eq 'StdAuth') {
        if ($null -eq $ClientSecret) {
            $ClientSecret = Read-Host -AsSecureString -Prompt 'Client Secret:'
        }

        $loginUri = [System.Uri]::new('https://id.sophos.com/api/v2/oauth2/token')

        $body = @{
            grant_type    = 'client_credentials'
            client_id     = $ClientID
            client_secret = Unprotect-Secret -Secret $ClientSecret
            scope         = 'token'
        }
        try {
            $response = Invoke-WebRequest -Uri $loginUri -Body $body -ContentType 'application/x-www-form-urlencoded' -Method Post -UseBasicParsing
        } catch {
            throw "Error requesting access token: $($_)"
        }
    
        if ($response.Content) {
            $authDetails = $response.Content | ConvertFrom-Json
            $expiresAt = (Get-Date).AddSeconds($authDetails.expires_in - 60)

            if ($AccessTokenOnly -eq $true) {
                $SCRIPT:SophosCentral.access_token = $authDetails.access_token | ConvertTo-SecureString -AsPlainText -Force
                $SCRIPT:SophosCentral.expires_at = $expiresAt
            } else {
                $authDetails | Add-Member -MemberType NoteProperty -Name expires_at -Value $expiresAt
                $authDetails.access_token = $authDetails.access_token | ConvertTo-SecureString -AsPlainText -Force
                $SCRIPT:SophosCentral = $authDetails

                $tenantInfo = Get-SophosCentralTenantInfo
                $SCRIPT:SophosCentral | Add-Member -MemberType NoteProperty -Name GlobalEndpoint -Value $tenantInfo.apiHosts.global
                $SCRIPT:SophosCentral | Add-Member -MemberType NoteProperty -Name RegionEndpoint -Value $tenantInfo.apiHosts.dataRegion
                $SCRIPT:SophosCentral | Add-Member -MemberType NoteProperty -Name TenantID -Value $tenantInfo.id
                $SCRIPT:SophosCentral | Add-Member -MemberType NoteProperty -Name IDType -Value $tenantInfo.idType

                $SCRIPT:SophosCentral | Add-Member -MemberType NoteProperty -Name client_id -Value $ClientID
                $SCRIPT:SophosCentral | Add-Member -MemberType NoteProperty -Name client_secret -Value $ClientSecret
            }
        }
    } elseif ($PsCmdlet.ParameterSetName -eq 'SecretVaultAuth') {
        #verify modules installed
        if ($AzKeyVault -eq $true) {
            $modules = 'Microsoft.PowerShell.SecretManagement', 'Az', 'Az.KeyVault'
        } else {
            $modules = 'Microsoft.PowerShell.SecretManagement'
        }
        foreach ($module in $modules) {
            if (-not(Get-Module $module -ListAvailable)) {
                throw "$module PowerShell Module is not installed"
            }
        }
        #verify secret vault exists
        try {
            $vault = Get-SecretVault -Name $SecretVaultName
        } catch {
            throw "$SecretVaultName is not registered as a Secret Vault in Microsoft.PowerShell.SecretManagement"
        }
        #connect to Azure if using Key Vault for the Secret Vault
        if ($AzKeyVault -eq $true) {
            try { 
                Connect-AzAccount 
            } catch {
                throw 'Error connecting to Azure PowerShell'
            }
        }
        #get secrets from vault
        try {
            #try twice, as sometimes the call silently fails
            $clientID = Get-Secret $SecretVaultClientIDName -Vault $SecretVaultName -AsPlainText
            $clientSecret = Get-Secret -Name $SecretVaultClientSecretName -Vault $SecretVaultName

            $clientID = Get-Secret $SecretVaultClientIDName -Vault $SecretVaultName -AsPlainText
            $clientSecret = Get-Secret -Name $SecretVaultClientSecretName -Vault $SecretVaultName
        } catch {
            throw "Error retrieving secrets from Azure Key Vault: $_"
        }
        #connect to Sophos Central
        Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret
    }
}