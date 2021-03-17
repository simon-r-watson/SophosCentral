function Unprotect-Secret {
    <#
    .SYNOPSIS
        Convert a [SecureString] to a [String]
    .EXAMPLE
        $plaintextsecret = Unprotect-Secret -Secret $clientsecret
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = "The Secure String to convert to plain text")]
        [SecureString]$Secret
    )
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret)
    [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
}