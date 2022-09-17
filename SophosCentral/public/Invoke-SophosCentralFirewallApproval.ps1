function Invoke-SophosCentralFirewallApproval {
    <#
    .SYNOPSIS
        Approve management of a firewall
    .DESCRIPTION
        Approve management of a firewall
    .PARAMETER FirewallID
        The ID of the firewall. Use Get-SophosCentralFirewall to list them
    .EXAMPLE
        Invoke-SophosCentralFirewallApproval -FirewallID "6d41e78e-0360-4de3-8669-bb7b797ee515"
    .LINK
        https://developer.sophos.com/docs/firewall-v1/1/routes/firewalls/%7BfirewallId%7D/action/post
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [string[]]$FirewallID,

        [switch]$Force
    )
    begin {
        $uriTemp = $SCRIPT:SophosCentral.RegionEndpoint + '/firewall/v1/firewalls/{0}/action '
        $body = @{
            action = 'approveManagement'
        }
    }
    process {
        foreach ($firewall in $FirewallID) {
            $uri = [System.Uri]::New($uriTemp -f $firewall)
            if ($Force -or $PSCmdlet.ShouldProcess('Approve', $firewall)) {
                Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
            }
        }
        
    }
}