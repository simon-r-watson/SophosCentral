function Get-SophosCentralEndpoints {
    $uriChild = '/endpoint/v1/endpoints'
    $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}