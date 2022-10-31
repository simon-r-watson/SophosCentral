function Test-SophosEnterprise {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        
    )
    if ($SCRIPT:SophosCentral.IDType -ne 'organization') {
        return $false
    } else {
        Write-Verbose 'currently logged in using a Sophos Central Partner Service Principal'
        return $true
    }
}