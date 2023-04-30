function Get-SophosCentralEvent {
    <#
    .SYNOPSIS
        Get events within the last 24 hours.
    .DESCRIPTION
        Get events within the last 24 hours.
    .PARAMETER Limit
        The maximum number of items to return, min is 200, max is 1000.
    .PARAMETER FromDate
        The starting date from which alerts will be retrieved. Must be within last 24 hours.
    .PARAMETER ExcludeType
        List of types of events to be excluded.
    .EXAMPLE
        Get-SophosCentralEvent

        Get the most recent events
    .EXAMPLE
        Get-SophosCentralEvent -FromDate (Get-Date).AddMinutes(-15)

        Get events from the last 15 minutes
    .EXAMPLE
        Get-SophosCentralEvent -ExcludeType 'Event::Endpoint::UpdateSuccess', 'Event::Endpoint::Application::Detected'

        Get latest events excluding UpdateSuccess and Application Detected events
    .EXAMPLE
        Get-SophosCentralEvent -Limit 205

        Get 205 of the the most recent events
    .LINK
        https://developer.sophos.com/docs/siem-v1/1/routes/events/get
    #>
    [CmdletBinding(DefaultParameterSetName = 'nullParam')]
    param (
        [ValidateRange(200, 1000)]
        [int]$Limit = 200,

        [ValidateScript({
                if (($_ - [datetime]::Now).TotalHours -gt 24) {
                    throw 'Must be within 24 hours'
                }
                return $true
            })]
        [datetime]$FromDate,

        [string[]]$ExcludeType
    )

    Test-SophosCentralConnected

    # Convert datetime to unix timestamp in UTC
    if ($null -ne $FromDate) {
        $timestamp = Get-Date -Date $FromDate.ToUniversalTime() -UFormat '%s'
        if ($timestamp.IndexOf('.') -gt 0) {
            # Powershell v5 returns a value with .#### where pwsh 7 does not...
            $timestamp = $timestamp.Substring(0, $timestamp.IndexOf('.'))
        }
        $PsBoundParameters.Add('from_date', $timestamp)
        $null = $PsBoundParameters.Remove('FromDate')
    }

    # Transform into API name
    if ($ExcludeType.Count -gt 0) {
        $PsBoundParameters.Add('exclude_types', $PsBoundParameters['ExcludeType'])
        $null = $PsBoundParameters.Remove('ExcludeType')
    }

    $uriTemp = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/siem/v1/events')
    $uri = New-UriWithQuery -Uri $uriTemp -OriginalPsBoundParameters $PsBoundParameters

    Invoke-SophosCentralWebRequest -Uri $uri
}
