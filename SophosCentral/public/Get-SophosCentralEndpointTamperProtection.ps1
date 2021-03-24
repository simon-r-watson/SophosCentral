function Get-SophosCentralEndpointTamperProtection {
    <#
    .SYNOPSIS
        Get Tamper Protection Status
    .DESCRIPTION
        Get Tamper Protection Status
    .PARAMETER EndpointID
        The ID of the Endpoint. Use Get-SophosCentralEndpoints to list them
    .EXAMPLE
        Get-SophosCentralEndpointTamperProtection -EndpointID '23a920fa-9a34-4869-bc3d-a1626e50f670'
    .EXAMPLE
        Get-SophosCentralEndpointTamperProtection -EndpointID (Get-SophosCentralEndpoints).ID
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/tamper-protection/get
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