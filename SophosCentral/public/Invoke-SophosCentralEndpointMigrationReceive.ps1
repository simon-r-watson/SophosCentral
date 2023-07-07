function Invoke-SophosCentralEndpointMigrationReceive {
    <#
    .SYNOPSIS
        Create a migration job in the receiving tenant.
    .DESCRIPTION
        Create a migration job in the receiving tenant. This command will cause your session to connect to the destination tenant.

        This is Step 1 of a migration.
    .PARAMETER EndpointID
        The ID of the Endpoints. Use Get-SophosCentralEndpoints to list them
    .PARAMETER SourceTenantID
        The ID of the source tenant. Use Get-SophosCentralCustomerTenant to list them
    .PARAMETER DestinationTenantID
        The ID of the destination tenant. Use Get-SophosCentralCustomerTenant to list them
    .EXAMPLE
        $jobDetails = Invoke-SophosCentralEndpointMigrationReceive -EndpointID '6d41e78e-0360-4de3-8669-bb7b797ee515' -SourceTenantID 'c4ce7035-d6c1-44b9-9b11-b4a8b13e979b' -DestinationTenantID 'c924009e-1fac-4174-aace-8ccbe4296f95'
    .EXAMPLE
        $jobDetails = Invoke-SophosCentralEndpointMigrationReceive -EndpointID (Get-SophosCentralEndpoint).ID -SourceTenantID 'c4ce7035-d6c1-44b9-9b11-b4a8b13e979b' -DestinationTenantID 'c924009e-1fac-4174-aace-8ccbe4296f95'

        With this example you would connect to the source tenant first, so that '(Get-SophosCentralEndpoint).ID' runs in its context
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/migrations/post
    .LINK
        https://developer.sophos.com/endpoint-migrations
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [string[]]$EndpointID,

        [Parameter(Mandatory = $true)]
        [string]$SourceTenantID,

        [Parameter(Mandatory = $true)]
        [string]$DestinationTenantID,

        [switch]$Force
    )
    begin {
        Test-SophosCentralConnected
    }

    process {
        if ($DestinationTenantID -ne $SCRIPT:SophosCentral.CustomerTenantID) {
            try {
                Write-Warning "Connecting to $($DestinationTenantID), this connection will overwrite the tenant you were connected to previously ($($SCRIPT:SophosCentral.CustomerTenantName))"
                Connect-SophosCentralCustomerTenant -CustomerTenantID $DestinationTenantId
            } catch {
                throw 'Unable to connect to the destination tenant, check the ID is correct and you have the correct permissions to it'
            }
        }

        $body = @{
            'fromTenant' = $SourceTenantID
            'endpoints'  = $EndpointID
        }

        $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/migrations')
        if ($Force -or $PSCmdlet.ShouldProcess('Create Receive Job', $DestinationTenantID )) {
            Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
        }
    }
    end { }
}
