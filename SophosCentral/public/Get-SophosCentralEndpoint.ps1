function Get-SophosCentralEndpoint {
    <#
    .SYNOPSIS
        Get Endpoints in Sophos Central (Workstations, Servers)
    .DESCRIPTION
        Get Endpoints in Sophos Central (Workstations, Servers)
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
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/get
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

    $uriBuilder = [System.UriBuilder]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoints')

    foreach ($param in $PsBoundParameters.Keys) {
        if ($null -ne $PsBoundParameters[$param]) {
            $queryPart = $param + '=' + $PsBoundParameters[$param]
            if (($null -eq $uriBuilder.Query) -or ($uriBuilder.Query.Length -le 1 )) {
                $uriBuilder.Query = $queryPart
            } else {
                $uriBuilder.Query = $uriBuilder.Query.Substring(1) + '&' + $queryPart
            }
        }
    }

    $uri = [System.Uri]::New($uriBuilder.Uri)
    Invoke-SophosCentralWebRequest -Uri $uri
}