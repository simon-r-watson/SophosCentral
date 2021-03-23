function Get-SophosCentralEndpointTamperProtection {
    <#
    .SYNOPSIS
        Get Tamper Protection Status
    .DESCRIPTION
        Get Tamper Protection Status
    .EXAMPLE
        Get-SophosCentralEndpointTamperProtection -EndpointID '23a920fa-9a34-4869-bc3d-a1626e50f670'
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("ID")]
        [string[]]$EndpointID
    )
    begin {
        $uriChild = "/endpoint/v1/endpoints/{0}/tamper-protection"
        $uriString = $GLOBAL:SophosCentral.RegionEndpoint + $uriChild
    }
    process {
        foreach ($endpoint in $EndpointID) {
            $uri = [System.Uri]::New($uriString -f $endpoint)
            Invoke-SophosCentralWebRequest -Uri $uri
        }
    }
}