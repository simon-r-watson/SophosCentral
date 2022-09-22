function Get-SophosCentralFirewall {
    <#
    .SYNOPSIS
        Get firewalls in Sophos Central
    .DESCRIPTION
        Get firewalls in Sophos Central
    .EXAMPLE
        Get-SophosCentralFirewall
    .LINK
        https://developer.sophos.com/docs/firewall-v1/1/routes/firewalls/get
    #>
    [CmdletBinding()]
    param (
    )

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/firewall/v1/firewalls')
    Invoke-SophosCentralWebRequest -Uri $uri
}