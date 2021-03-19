function Get-SophosCentralAlerts {
    <#
    .SYNOPSIS
        Get alerts listed in Sophos Central
    .DESCRIPTION
        Get alerts listed in Sophos Central
        https://developer.sophos.com/docs/common-v1/1/routes/alerts/get
    .EXAMPLE
        Get-SophosCentralAlert
    #>
    $uriChild = '/common/v1/alerts'
    $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}