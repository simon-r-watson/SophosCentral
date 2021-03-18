function Get-SophosCentralAlert {
    <#
        .DESCRIPTION
        https://developer.sophos.com/docs/common-v1/1/routes/alerts/get
    #>
    $uriChild = '/common/v1/alerts'
    $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}