function Get-SophosCentralFirewallGroup {
    <#
    .SYNOPSIS
        Get firewall groups in Sophos Central
    .DESCRIPTION
        Get firewall groups in Sophos Central
    .EXAMPLE
        Get-SophosCentralFirewallGroup
    .LINK
        https://developer.sophos.com/docs/firewall-v1/1/routes/firewall-groups/get
    #>
    [CmdletBinding()]
    param (
        [System.Boolean]$RecurseSubgroups,
        [string]$Search
    )
    Test-SophosCentralConnected
    
    $uriTemp = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/firewall/v1/firewall-groups')
    $uri = New-UriWithQuery -Uri $uriTemp -OriginalPsBoundParameters $PsBoundParameters

    Invoke-SophosCentralWebRequest -Uri $uri
}