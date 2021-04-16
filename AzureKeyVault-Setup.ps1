#Initial Setup
$modules = 'Microsoft.PowerShell.SecretManagement', 'Microsoft.PowerShell.SecretStore', 'Az', 'Az.KeyVault'
foreach ($module in $modules) {
    if (-not(Get-Module $module -ListAvailable)) {
        Install-Module $module -Scope CurrentUser -Force
    } else {
        Update-Module $module -Force
    }
}

#Update this to match the name of a Azure KeyVault you've already created
$vaultName = 'SECRETS'
#Update this to match the ID of your Azure subscription
$subID = '23993d24-af33-4002-8451-a348d906cadc'

#Register the secret vault
Register-SecretVault -Module Az.KeyVault -Name AzKV -VaultParameters @{ AZKVaultName = $vaultName; SubscriptionId = $subID }

#Store the secrets
Connect-AzAccount
$clientID = Read-Host -Prompt 'Client ID:'
$clientSecret = Read-Host -Prompt 'Client Secret:' -AsSecureString

Set-Secret -Name 'SophosCentral-Partner-ClientSecret' -Secret $clientSecret -Vault AzKV
Set-Secret -Name 'SophosCentral-Partner-ClientID' -Secret $clientID -Vault AzKV

#Retrieve secrets and login to Sophos Central
Connect-AzAccount
$clientID = Get-Secret 'SophosCentral-Partner-ClientID' -Vault AzKV -AsPlainText
$clientSecret = Get-Secret -Name 'SophosCentral-Partner-ClientSecret' -Vault AzKV
Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret