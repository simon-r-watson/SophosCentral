function Invoke-SophosCentralEndpointMigrationSend {
    <#
    .SYNOPSIS
        Start a migration job in the sending tenant.
    .DESCRIPTION
        Start a migration job in the sending tenant. This command will cause your session to connect to the source tenant.

        This is Step 2 of a migration.
    .PARAMETER EndpointID
        The ID of the Endpoints. Use Get-SophosCentralEndpoints to list them
    .PARAMETER SourceTenantID
        The ID of the source tenant. Use Get-SophosCentralCustomerTenant to list them
    .PARAMETER MigrationID
        id returned from Invoke-SophosCentralEndpointMigrationReceive
    .PARAMETER MigrationToken
        token returned from Invoke-SophosCentralEndpointMigrationReceive
    .EXAMPLE
        $jobDetails = Invoke-SophosCentralEndpointMigrationSend -EndpointID '6d41e78e-0360-4de3-8669-bb7b797ee515','245fe806-9ff8-4da1-b136-eea2a1d14812' -SourceTenantID 'c4ce7035-d6c1-44b9-9b11-b4a8b13e979b' -MigrationID 'bbc35a7e-860b-43bc-b668-d48b57cb38ed' -MigrationToken 'eyJ0b2tlbiI6ICJUaGlzIGlzIG9ubHkgYSBzYW1wbGUgdG9rZW4uIn0='
    .EXAMPLE
        $jobDetails = Invoke-SophosCentralEndpointMigrationSend -EndpointID (Get-SophosCentralEndpoint).ID -SourceTenantID 'c4ce7035-d6c1-44b9-9b11-b4a8b13e979b'

        With this example you would connect to the source tenant first, so that '(Get-SophosCentralEndpoint).ID' runs in its context
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/migrations/%7BmigrationJobId%7D/put
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
        [string]$MigrationID,

        [Parameter(Mandatory = $true)]
        [string]$MigrationToken,

        [switch]$Force
    )
    Test-SophosCentralConnected
        
    Show-UntestedWarning
    
    if ($SourceTenantID -ne $SCRIPT:SophosCentral.CustomerTenantID) {
        try {
            Write-Warning "Connecting to $($SourceTenantID), this connection will overwrite the tenant you were connected to previously ($($SCRIPT:SophosCentral.CustomerTenantName))"
            Connect-SophosCentralCustomerTenant -CustomerTenantID $SourceTenantID
        } catch {
            throw 'Unable to connect to the source tenant, check the ID is correct and you have the correct permissions to it'
        }
    }
    
    $body = @{
        'token'     = $MigrationToken
        'endpoints' = $EndpointID
    }

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/migrations/' + $MigrationID)
    if ($Force -or $PSCmdlet.ShouldProcess('Create Send Job', $SourceTenantID )) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Put -Body $body
    }
}