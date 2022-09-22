function Get-SophosCentralFirewallUpdate {
    <#
    .SYNOPSIS
        Trigger an update on an Endpoint in Sophos Central
    .DESCRIPTION
        Trigger an update on an Endpoint in Sophos Central
    .PARAMETER EndpointID
        The ID of the Endpoint. Use Get-SophosCentralEndpoints to list them
    .EXAMPLE
        Get-SophosCentralFirewallUpdate -FirewallID "6d41e78e-0360-4de3-8669-bb7b797ee515"
    .EXAMPLE
        Get-SophosCentralFirewallUpdate -EndpointID (Get-SophosCentralEndpoint).ID
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