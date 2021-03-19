function Test-SophosCentralAuth {
    if ($GLOBAL:SophosCentral) {
        $date = Get-Date
        if ($GLOBAL:SophosCentral.expires_at -le $date) {
            Write-Verbose "Access token has expired"
            #request new token
            try {
                Write-Verbose "Attempting to obtain new access token"
                Connect-SophosCentral -ClientID $GLOBAL:SophosCentral.client_id -ClientSecret -ClientID $GLOBAL:SophosCentral.client_secret -AccessTokenOnly
                Write-Verbose "Testing new access token"
                Test-SophosCentralAuth
            }
            catch {
                throw "error requesting new token"
                return $false
            }           
        }
        else {
            return $true
        }
    }
    else {
        throw "You must connect with 'Connect-SophosCentral' before running any commands"
        return $false
    }
}