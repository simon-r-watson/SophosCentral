# Example - Storing Secrets in Azure Key Vault

This makes use of [PowerShell SecretStore module](https://github.com/PowerShell/SecretStore) and its integration into [Azure Key Vault](https://azure.microsoft.com/en-au/services/key-vault/)

## Setup Azure Key Vault and Secret Store

1. Setup a new Azure Key Vault. Note down it's name, and the ID of the subscription it resides in. [PowerShell](https://docs.microsoft.com/en-au/azure/key-vault/general/quick-create-powershell) instructions. [Azure Portal](https://docs.microsoft.com/en-au/azure/key-vault/general/quick-create-portal) instructions.
2. Assign permissions to the Key Vault, so that your user account can read/write to it
3. Run the following on your workstation. This will install the required modules and setup the Secret Vault. You will need to update the 'vaultName' and 'subID' variables

``` powershell
#Install/Update the required modules
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
```

## Store the Secrets in Azure Key Vault

1. Login to Azure, if you haven't already

``` powershell
Connect-AzAccount
```

2. Get the secrets and store them

``` powershell
$clientID = Read-Host -Prompt 'Client ID:'
$clientSecret = Read-Host -Prompt 'Client Secret:' -AsSecureString
Set-Secret -Name 'SophosCentral-Partner-ClientSecret' -Secret $clientSecret -Vault AzKV
Set-Secret -Name 'SophosCentral-Partner-ClientID' -Secret $clientID -Vault AzKV
```

## Retrieve the Secrets and Connect to Sophos Central

1. Login to Azure, if you haven't already

``` powershell
Connect-AzAccount
```

2. Retrieve the secrets and connect to Sophos Central

``` powershell
$clientID = Get-Secret 'SophosCentral-Partner-ClientID' -Vault AzKV -AsPlainText
$clientSecret = Get-Secret -Name 'SophosCentral-Partner-ClientSecret' -Vault AzKV
Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret
```
