function Remove-SophosCentralFirewallUpdate {
    <#
    .SYNOPSIS
        Cancel a scheduled firewall update
    .DESCRIPTION
        Cancel a scheduled firewall update
    .PARAMETER FirewallID
        The ID of the firewall. Use Get-SophosCentralFirewall to list them
    .EXAMPLE
        Remove-SophosCentralFirewallUpdate -FirewallID 6fed0eb5-d8ff-44ee-9c37-df8a9924373d
    .LINK
        https://developer.sophos.com/docs/firewall-v1/1/routes/firewalls/actions/firmware-upgrade/delete
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [string[]]$FirewallID,

        [switch]$Force
    )
    Test-SophosCentralConnected
    
    foreach ($firewall in $FirewallID) {
        $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/firewall/v1/firewalls/actions/firmware-upgrade?ids=' + $firewall)
        if ($Force -or $PSCmdlet.ShouldProcess('Cancel update', $firewall )) {
            Invoke-SophosCentralWebRequest -Uri $uri -Method Delete
        }
    }
    
}