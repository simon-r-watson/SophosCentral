function Test-SophosCentralConnected {
    [CmdletBinding()]
    param (
        
    )
    if ($null -eq $SCRIPT:SophosCentral.access_token) {
        throw "You must connect with 'Connect-SophosCentral' before running any commands"
    } 
}