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
    
    if ($SCRIPT:SophosCentral.IDType -ne 'partner') {
        throw 'You are not currently logged in using a Sophos Central Partner Service Principal'
    } else {
        Write-Verbose 'currently logged in using a Sophos Central Partner Service Principal'
    }

    $header = Get-SophosCentralAuthHeader -PartnerInitial
    $uri = [System.Uri]::New('https://api.central.sophos.com/partner/v1/admins')
    Invoke-SophosCentralWebRequest -Uri $uri -CustomHeader $header
}