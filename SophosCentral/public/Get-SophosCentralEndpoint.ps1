function Get-SophosCentralEndpoint {
    $uriChild = '/endpoint/v1/endpoints'
    $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}