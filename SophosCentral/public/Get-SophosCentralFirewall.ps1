function Get-SophosCentralFirewall {
    <#
    .SYNOPSIS
        Get firewalls in Sophos Central
    .DESCRIPTION
        Get firewalls in Sophos Central
    .EXAMPLE
        Get-SophosCentralFirewall
    .PARAMETER GroupId
        Firewall group ID, or 'ungrouped'
    .PARAMETER Search
        Search
    .EXAMPLE
        Get-SophosCentralFirewall -GroupId 'ungrouped'
        List firewalls that aren't part of a firewall group.
    .EXAMPLE
        Get-SophosCentralFirewall -GroupId 'e25ec1f2-04f5-477e-a10d-71f2e039ebaf'
        List firewalls in the group e25ec1f2-04f5-477e-a10d-71f2e039ebaf
    .LINK
        https://developer.sophos.com/docs/firewall-v1/1/routes/firewalls/get
    #>
    [CmdletBinding()]
    param (
        [ValidateScript({
                if ($_ -eq 'ungrouped') {
                    return $true
                } elseif ($false -eq [System.Guid]::TryParse($_, $([ref][guid]::Empty))) {
                    throw 'Not a valid GUID' 
                } else {
                    return $true
                }
            })]
        [string]$GroupId,
        [string]$Search
    )
    Test-SophosCentralConnected
    
    $uriTemp = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/firewall/v1/firewalls?pageTotal=true')
    $uri = New-UriWithQuery -Uri $uriTemp -OriginalPsBoundParameters $PsBoundParameters
    Invoke-SophosCentralWebRequest -Uri $uri
}