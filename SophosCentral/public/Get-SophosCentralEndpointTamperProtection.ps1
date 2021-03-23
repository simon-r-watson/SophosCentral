function Get-SophosCentralEndpointTamperProtection {
    <#
    .SYNOPSIS
        Get Tamper Protection Status
    .DESCRIPTION
        Get Tamper Protection Status
    .EXAMPLE
        Get-SophosCentralEndpointTamperProtection
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