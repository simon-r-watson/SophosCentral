function Remove-SophosCentralFirewallGroup {
    <#
    .SYNOPSIS
        Remove a firewall group
    .DESCRIPTION
        Remove a firewall group
    .PARAMETER GroupID
        The ID of the group. Use Get-SophosCentralFirewallGroup to list them
    .EXAMPLE
        Remove-SophosCentralFirewallGroup -GroupID 6fed0eb5-d8ff-44ee-9c37-df8a9924373d
    .LINK
        https://developer.sophos.com/docs/firewall-v1/1/routes/firewall-groups/%7BgroupId%7D/delete
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [string[]]$GroupID,

        [switch]$Force
    )

    begin {
        Test-SophosCentralConnected
    }

    process {
        foreach ($group in $GroupID) {
            $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/firewall/v1/firewall-groups/' + $group)
            if ($Force -or $PSCmdlet.ShouldProcess('Remove', $group )) {
                Invoke-SophosCentralWebRequest -Uri $uri -Method Delete
            }
        }
    }

    end { }
}
