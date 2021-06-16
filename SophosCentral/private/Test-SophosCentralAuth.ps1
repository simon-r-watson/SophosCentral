function Test-SophosCentralAuth {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        
    )
    if ($SCRIPT:SophosCentral) {
        $date = Get-Date
        if ($SCRIPT:SophosCentral.expires_at -le $date) {
            Write-Verbose 'Access token has expired'
            #request new token
            try {
                Write-Verbose 'Attempting to obtain new access token'
                Connect-SophosCentral -ClientID $SCRIPT:SophosCentral.client_id -ClientSecret $SCRIPT:SophosCentral.client_secret -AccessTokenOnly
                Write-Verbose 'Testing new access token'
                Test-SophosCentralAuth
            } catch {
                Write-Error 'error requesting new token'
                return $false
            }           
        } else {
            return $true
        }
    } else {
        Write-Error "You must connect with 'Connect-SophosCentral' before running any commands"
        return $false
    }
}