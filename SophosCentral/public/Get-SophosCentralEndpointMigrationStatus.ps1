function Get-SophosCentralEndpointMigrationStatus {
    <#
    .SYNOPSIS
        Gets the status of endpoints that are being migrated.
    .DESCRIPTION
        Gets the status of endpoints that are being migrated. This should be able to be run in either tenant.
    .EXAMPLE
        Get-SophosCentralEndpointMigrationStatus
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/migrations/%7BmigrationJobId%7D/endpoints/get
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$MigrationID
    )
    
    Show-UntestedWarning
    
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + "/endpoint/v1/migrations/$($MigrationID)/endpoints?pageTotal=true")
    Invoke-SophosCentralWebRequest -Uri $uri
}