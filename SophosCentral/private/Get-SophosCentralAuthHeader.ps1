function Get-SophosCentralAuthHeader {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [switch]$Initial,
        [switch]$PartnerInitial
    )

    if ((Test-SophosCentralAuth) -eq $true) {
        $header = @{
            Authorization = 'Bearer ' + (Unprotect-Secret -Secret $SCRIPT:SophosCentral.access_token)
        }
        if (($Initial -ne $true) -and ($PartnerInitial -ne $true)) {
            switch ($SCRIPT:SophosCentral.IDType) {
                'partner' {
                    $header.Add('X-Tenant-ID', $SCRIPT:SophosCentral.CustomerTenantID)
                }
                'tenant' {
                    $header.Add('X-Tenant-ID', $SCRIPT:SophosCentral.TenantID)
                }
            }
        }
        if ($PartnerInitial) {
            $header.Add('X-Partner-ID', $SCRIPT:SophosCentral.TenantID)
        }
        $header
    }
}