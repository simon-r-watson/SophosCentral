try {
    Get-AzSubscription | Out-Null
} catch {
    Connect-AzAccount
}

$clientID = Get-Secret 'SophosCentral-Partner-ClientID' -Vault AzKV -AsPlainText
$clientSecret = Get-Secret -Name 'SophosCentral-Partner-ClientSecret' -Vault AzKV

Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret