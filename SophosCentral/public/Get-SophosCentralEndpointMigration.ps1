function Get-SophosCentralEndpointMigration {
    <#
    .SYNOPSIS
        Gets all migration jobs for the tenant.
    .DESCRIPTION
        Gets all migration jobs for the tenant.
    .EXAMPLE
        Get-SophosCentralEndpointMigration
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/migrations/get
    #>
    [CmdletBinding()]
    param (
    )
    Test-SophosCentralConnected
    
    Show-UntestedWarning
    
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/migrations')
    Invoke-SophosCentralWebRequest -Uri $uri
}