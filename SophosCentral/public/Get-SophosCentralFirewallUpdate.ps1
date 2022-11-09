function Get-SophosCentralFirewallUpdate {
    <#
    .SYNOPSIS
        Get firmware updates available on a firewall
    .DESCRIPTION
        Get firmware updates available on a firewall
    .PARAMETER FirewallID
        The ID of the firewall. Use Get-SophosCentralFirewall to list them
    .EXAMPLE
        Get-SophosCentralFirewallUpdate -FirewallID "6d41e78e-0360-4de3-8669-bb7b797ee515"
    .LINK
        https://developer.sophos.com/docs/firewall-v1/1/routes/firewalls/actions/firmware-upgrade-check/post
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [string[]]$FirewallID
    )
    begin {
        Test-SophosCentralConnected
    
        $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/firewall/v1/firewalls/actions/firmware-upgrade-check')
        $body = @{
            firewalls = @()
        }
    }
    process {
        foreach ($firewall in $FirewallID) {
            $body['firewalls'] += $firewall
        }
        Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
    }
}