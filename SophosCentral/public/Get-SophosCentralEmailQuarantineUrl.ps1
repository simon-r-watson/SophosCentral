function Get-SophosCentralEmailQuarantineUrl {
    <#
    .SYNOPSIS
        Get all URLs found in body of a quarantined message. Only supported by the standard quarantine.
    .DESCRIPTION
        Get all URLs found in body of a quarantined message. Only supported by the standard quarantine.
    .PARAMETER ID
        ID from 'X-Sophos-Email-ID' MIME header, or the ID returned by the Get-SophosCentralEmailQuarantine cmdlet.
    .EXAMPLE
        Get-SophosCentralEmailQuarantine -BeginDate (Get-Date).AddDays(-7) -EndDate (Get-Date) -Direction inbound

        List all quarantined inbound emails in the last 7 days
    .LINK
        https://developer.sophos.com/docs/email-v1/1/routes/quarantine/messages/%7Bid%7D/urls/get
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ID
    )
    Test-SophosCentralConnected

    $query = "/email/v1/quarantine/messages/$($ID)/urls"
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $query)

    Invoke-SophosCentralWebRequest -Uri $uri
}
