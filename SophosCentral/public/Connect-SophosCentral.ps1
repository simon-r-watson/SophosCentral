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

        Sophos enterprise customers can connect to their tenants using a client/secret. Follow Step 1 here to create it
        <https://developer.sophos.com/getting-started-organization>
    .PARAMETER ClientID
        The client ID from the Sophos Central API credential/service principal
    .PARAMETER ClientSecret
        The client secret from the Sophos Central API credential/service principal
    .PARAMETER SecretVault
        Login using a client ID and client secret retrieved from Secret Vault (Microsoft.PowerShell.SecretManagement).
        Setup example found in https://github.com/simon-r-watson/SophosCentral/wiki/AzureKeyVaultExample
        This is not exclusive to using it with Azure Key Vault, you can use other providers supported by Microsoft.PowerShell.SecretManagement, such as a local one
    .PARAMETER AzKeyVault
        Calls Connect-AzAccount before retrieving the secrets from the secret vault, this can be skipped if you are already connected
        Uses the Microsoft.PowerShell.SecretManagement and Az.KeyVault modules for retrieving secrets
        Setup example found in https://github.com/simon-r-watson/SophosCentral/wiki/AzureKeyVaultExample
    .PARAMETER AccessTokenOnly
        Internal use (for this module) only. Used to generate a new access token when the current one expires
    .PARAMETER SecretVaultName
        Name of the secret vault, defaults to AzKV
    .PARAMETER SecretVaultClientIDName 
        Name of the secret containing the client ID in the vault
    .PARAMETER SecretVaultClientSecretName
        Name of the secret containing the client secret in the vault
    .EXAMPLE
        Connect-SophosCentral -ClientID "asdkjsdfksjdf" -ClientSecret (Read-Host -AsSecureString -Prompt "Client Secret:")
    .EXAMPLE
        Connect-SophosCentral -SecretVault -AzKeyVault

        Connect using default values for Secret Key Vault name, Client ID name, and Client Secret name, with secret vault configured to use Azure Key Vault
    .EXAMPLE
        Connect-SophosCentral -SecretVault -AzKeyVault -SecretVaultName 'secrets' -SecretVaultClientIDName 'sophosclientid' -SecretVaultClientSecretName 'sophosclientsecret'

        Connect using custom Secret Vault name, Client ID Name, and Client Secret Name, with secret vault configured to use Azure Key Vault
    .EXAMPLE
        Connect-SophosCentral -SecretVault -SecretVaultName 'secrets' -SecretVaultClientIDName 'sophosclientid' -SecretVaultClientSecretName 'sophosclientsecret'

        Connect using custom Secret Vault name, Client ID Name, and Client Secret Name when using a locally stored Secret Vault (or another Microsoft.PowerShell.SecretManagement integration)
    .LINK
        https://developer.sophos.com/getting-started-tenant
    .LINK
        https://developer.sophos.com/getting-started
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('AvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'SecureStrings main usage is to stop items from appearing in the console, and not encrypting memory', Scope = 'Function')]
    param (
        [Parameter(Mandatory = $true,
            ParameterSetName = 'StdAuth',
            HelpMessage = 'The client ID from the Sophos Central API credential/service principal')]
        [String]$ClientID,

        [Parameter(ParameterSetName = 'StdAuth',
            HelpMessage = 'The client secret from the Sophos Central API credential/service principal')]
        [SecureString]$ClientSecret,

        [Parameter(ParameterSetName = 'StdAuth',
            HelpMessage = 'Internal use (for this module) only. Used to generate a new access token when the current one expires')]
        [Switch]$AccessTokenOnly,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'SecretVaultAuth',
            HelpMessage = 'Enable secret vault auth using the Microsoft.PowerShell.SecretManagement module')]
        [Switch]$SecretVault,

        [Parameter(ParameterSetName = 'SecretVaultAuth',
            HelpMessage = 'Calls Connect-AzAccount before retrieving the secrets from the secret vault')]
        [Switch]$AzKeyVault,

        [Parameter(ParameterSetName = 'SecretVaultAuth',
            HelpMessage = 'Name of the secret vault, defaults to AzKV')]
        [String]$SecretVaultName = 'AzKV',

        [Parameter(ParameterSetName = 'SecretVaultAuth',
            HelpMessage = 'Name of the secret containing the client ID in the vault')]
        [String]$SecretVaultClientIDName = 'SophosCentral-Partner-ClientID',

        [Parameter(ParameterSetName = 'SecretVaultAuth',
            HelpMessage = 'Name of the secret containing the client secret in the vault')]
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
    } elseif ($PsCmdlet.ParameterSetName -eq 'SecretVaultAuth' -or $SecretVault) {
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
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('UseDeclaredVarsMoreThanAssignments', '', Justification = 'Only used for checking vault exists')]
            $vault = Get-SecretVault -Name $SecretVaultName
        } catch {
            throw "$SecretVaultName is not registered as a Secret Vault in Microsoft.PowerShell.SecretManagement"
        }
        #connect to Azure if using Key Vault for the Secret Vault
        if ($AzKeyVault -eq $true) {
            try {
                #check whether already logged into Azure
                $context = Get-AzContext
                if ($null -eq $context.Account) {
                    Connect-AzAccount | Out-Null
                }

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