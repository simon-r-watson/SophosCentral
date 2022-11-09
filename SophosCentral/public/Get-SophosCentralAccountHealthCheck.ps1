function Get-SophosCentralAccountHealthCheck {
    <#
    .SYNOPSIS
        The Account Health Check API allows you to retrieve a health report for your Sophos Central account indicating whether you are making the best use of your Sophos security products.
    .DESCRIPTION
        The Account Health Check API allows you to retrieve a health report for your Sophos Central account indicating whether you are making the best use of your Sophos security products.
    .EXAMPLE
        Get-SophosCentralAccountHealthCheck
    .LINK
        https://developer.sophos.com/account-health-check
    #>
    [CmdletBinding()]
    param (
    )
    Test-SophosCentralConnected
    
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/account-health-check/v1/health-check')
    Invoke-SophosCentralWebRequest -Uri $uri
}