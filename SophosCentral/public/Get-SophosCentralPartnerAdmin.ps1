function Get-SophosCentralPartnerAdmin {
    <#
    .SYNOPSIS
        List all partner admins.
    .DESCRIPTION
        List all partner admins.
    .EXAMPLE
        Get-SophosCentralPartnerAdmin
    .LINK
        https://developer.sophos.com/docs/partner-v1/1/routes/admins/get
    #>
    [CmdletBinding()]
    param (
    )
    Test-SophosCentralConnected

    if ((Test-SophosPartner) -eq $false) {
        throw 'You are not currently logged in using a Sophos Central Partner Service Principal'
    }

    try {
        $header = Get-SophosCentralAuthHeader -PartnerInitial
    } catch {
        throw $_
    }

    $uri = [System.Uri]::New('https://api.central.sophos.com/partner/v1/admins')
    Invoke-SophosCentralWebRequest -Uri $uri -CustomHeader $header
}
