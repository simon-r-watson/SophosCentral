function Test-SophosPartner {
    if ($SCRIPT:SophosCentral.IDType -ne 'partner') {
        return $false
    } else {
        Write-Verbose 'currently logged in using a Sophos Central Partner Service Principal'
        return $true
    }
}