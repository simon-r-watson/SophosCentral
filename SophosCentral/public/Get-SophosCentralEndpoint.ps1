function Get-SophosCentralEndpoint {
    <#
    .SYNOPSIS
        Get Endpoints in Sophos Central (Workstations, Servers)
    .DESCRIPTION
        Get Endpoints in Sophos Central (Workstations, Servers)
    .PARAMETER HealthStatus
        Find endpoints by health status. The following values are allowed: bad, good, suspicious, unknown
    .PARAMETER Type
        Find endpoints by type. The following values are allowed: computer, server, securityVm
    .PARAMETER TamperProtectionEnabled
        Find endpoints by whether Tamper Protection is turned on.
    .PARAMETER LockdownStatus
        Find endpoints by lockdown status.
    .PARAMETER IsolationStatus
        Find endpoints by isolation status.
    .PARAMETER HostnameContains
        Find endpoints where the hostname contains the given string. Only the first 10 characters of the given string are matched.
    .PARAMETER IpAddresses
        Find endpoints by IP addresses.
    .PARAMETER MacAddresses
        Find endpoints by MAC Addresses. Can be in EUI-48 or EUI-64 format, case insensitive, colon, hyphen or dot separated, or with no separator e.g. 01:23:45:67:89:AB, 01-23-45-67-89-ab, 0123.4567.89ab, 0123456789ab, 01:23:45:67:89:ab:cd:ef.
    .EXAMPLE
        Get-SophosCentralEndpoint
        List all endpoints in the tenant
    .EXAMPLE
        Get-SophosCentralEndpoint -HealthStatus 'bad'
        List all endpoints with a bad health status
    .EXAMPLE
        Get-SophosCentralEndpoint -TamperProtectionEnabled $false
        List all endpoints with tamper protection disabled
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/get
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralEndpoints')]
    param (
        [ValidateSet('bad', 'good', 'suspicious', 'unknown')]
        [string]$HealthStatus,

        [ValidateSet('computer', 'server', 'securityVm')]
        [string]$Type,

        [System.Boolean]$TamperProtectionEnabled,

        [ValidateSet('creatingWhitelist', 'installing', 'locked', 'notInstalled', 'registering', 'starting', 'stopping', 'unavailable', 'uninstalled', 'unlocked')]
        [string]$LockdownStatus,

        [ValidateSet('isolated', 'notIsolated')]
        [string]$IsolationStatus,

        [string]$HostnameContains,

        [string]$IpAddresses,

        [string]$MacAddresses 
    )
    
    $uriTemp = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoints')
    $uri = New-UriWithQuery -Uri $uriTemp -OriginalPsBoundParameters $PsBoundParameters

    Invoke-SophosCentralWebRequest -Uri $uri
}