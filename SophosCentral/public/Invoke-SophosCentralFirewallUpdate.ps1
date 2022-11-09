function Invoke-SophosCentralFirewallUpdate {
    <#
    .SYNOPSIS
        Trigger an update on an firewall in Sophos Central
    .DESCRIPTION
        Trigger an update on an firewall in Sophos Central
    .PARAMETER FirewallID
        The ID of the firewall. Use Get-SophosCentralFirewall to list them
    .PARAMETER UpgradeToVersion
        The version to upgrade to. Check available firmware updates using Get-SophosCentralFirewallUpdate
    .PARAMETER UpgradeAt
        The time to perform the update. If not specified it'll queue the update immediately
    .EXAMPLE
        Invoke-SophosCentralFirewallUpdate -FirewallID "6d41e78e-0360-4de3-8669-bb7b797ee515" -UpgradeToVersion 'some-version'
    .EXAMPLE
        Invoke-SophosCentralFirewallUpdate -EndpointID (Get-SophosCentralEndpoint).ID
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/update-checks/post
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [string[]]$FirewallID,

        [string]$UpgradeToVersion,

        [datetime]$UpgradeAt,

        [switch]$Force
    )
    begin {
        Test-SophosCentralConnected
    
        $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/firewall/v1/firewalls/actions/firmware-upgrade')
        $body = @{
            firewalls = @()
        }
    }
    process {
        foreach ($firewall in $FirewallID) {
            $firewallHash = @{
                id               = $firewall
                upgradeToVersion = $UpgradeToVersion
            }
            if ($UpgradeAt) { $firewallHash.Add('upgradeAt', $UpgradeAt) }
            $body['firewalls'] += $firewallHash
        }
        if ($Force -or $PSCmdlet.ShouldProcess('Update', ($FirewallID -join ', '))) {
            Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
        }
    }
}