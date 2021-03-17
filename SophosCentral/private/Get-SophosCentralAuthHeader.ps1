function Get-SophosCentralAuthHeader {
    [CmdletBinding()]
    param (
        [switch]$Initial
    )

    if ($GLOBAL:SophosCentral) {
        $header = @{
            Authorization = 'Bearer ' + $GLOBAL:SophosCentral.access_token
        }
        if ($Initial -ne $true) {
            $header.Add('X-Tenant-ID', $GLOBAL:SophosCentral.TenantID)
        }
        $header
    }
}