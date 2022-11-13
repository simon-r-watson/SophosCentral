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
    .PARAMETER LastSeenBefore
        Find endpoints last seen before this. Accepts either [datetime] or a string in the ISO 8601 Duration format (https://en.wikipedia.org/wiki/ISO_8601#Durations)
    .PARAMETER LastSeenAfter
        Find endpoints last seen after this. Accepts either [datetime] or a string in the ISO 8601 Duration format (https://en.wikipedia.org/wiki/ISO_8601#Durations)
    .EXAMPLE
        Get-SophosCentralEndpoint
        List all endpoints in the tenant
    .EXAMPLE
        Get-SophosCentralEndpoint -HealthStatus 'bad'
        List all endpoints with a bad health status
    .EXAMPLE
        Get-SophosCentralEndpoint -TamperProtectionEnabled $false
        List all endpoints with tamper protection disabled
    .EXAMPLE
        Get-SophosCentralEndpoint -LastSeenBefore '-P90D'
        List all endpoints seen more than 90 day ago
    .EXAMPLE
        Get-SophosCentralEndpoint -LastSeenAfter '-P1D'
        List all endpoints seen in the last 1 day
    .EXAMPLE
        Get-SophosCentralEndpoint -LastSeenAfter (Get-Date).AddDays(-1)
        List all endpoints seen in the last 1 day
    .EXAMPLE
        Get-SophosCentralEndpoint -LastSeenAfter '-PT2H'
        List all endpoints seen in the last 2 hours
    .EXAMPLE
        Get-SophosCentralEndpoint -LastSeenAfter '-PT20M'
        List all endpoints seen in the last 20 minutes
    .EXAMPLE
        Get-SophosCentralEndpoint -LastSeenAfter '-P3DT4H5M0S'
        List all endpoints seen in the last 3 days 4 hours 5 minutes and 0 seconds
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/get
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralEndpoints')]
    param (
        [ValidateSet('bad', 'good', 'suspicious', 'unknown')]
        [string[]]$HealthStatus,

        [ValidateSet('computer', 'server', 'securityVm')]
        [string[]]$Type,

        [System.Boolean]$TamperProtectionEnabled,

        [ValidateSet('creatingWhitelist', 'installing', 'locked', 'notInstalled', 'registering', 'starting', 'stopping', 'unavailable', 'uninstalled', 'unlocked')]
        [string[]]$LockdownStatus,

        [ValidateSet('isolated', 'notIsolated')]
        [string]$IsolationStatus,

        [string]$HostnameContains,

        [string]$IpAddresses,

        [string]$MacAddresses,

        [ValidateScript({
                if ($_.GetType().Name -eq 'DateTime') {
                    return $true
                } else {
                    #match this duration format
                    $regex = '^[-+]?P(?!$)(([-+]?\d+Y)|([-+]?\d+\.\d+Y$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?(([-+]?\d+W)|([-+]?\d+\.\d+W$))?(([-+]?\d+D)|([-+]?\d+\.\d+D$))?(T(?=[\d+-])(([-+]?\d+H)|([-+]?\d+\.\d+H$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?([-+]?\d+(\.\d+)?S)?)??$'
                    $_ -match $regex
                }
            })]
        $LastSeenBefore,

        [ValidateScript({
                if ($_.GetType().Name -eq 'DateTime') {
                    return $true
                } else {
                    #match this duration format
                    $regex = '^[-+]?P(?!$)(([-+]?\d+Y)|([-+]?\d+\.\d+Y$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?(([-+]?\d+W)|([-+]?\d+\.\d+W$))?(([-+]?\d+D)|([-+]?\d+\.\d+D$))?(T(?=[\d+-])(([-+]?\d+H)|([-+]?\d+\.\d+H$))?(([-+]?\d+M)|([-+]?\d+\.\d+M$))?([-+]?\d+(\.\d+)?S)?)??$'
                    $_ -match $regex
                }
            })]
        $LastSeenAfter
    )
    Test-SophosCentralConnected

    $uriTemp = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoints')
    $uri = New-UriWithQuery -Uri $uriTemp -OriginalPsBoundParameters $PsBoundParameters

    Invoke-SophosCentralWebRequest -Uri $uri
}