function Invoke-SophosCentralEndpointScan {
    <#
    .SYNOPSIS
        Trigger a scan on Endpoints in Sophos Central
    .DESCRIPTION
        Trigger a scan on Endpoints in Sophos Central
    .PARAMETER EndpointID
        The ID of the Endpoint. Use Get-SophosCentralEndpoints to list them
    .EXAMPLE
        Invoke-SophosCentralEndpointScan -EndpointID "6d41e78e-0360-4de3-8669-bb7b797ee515"
    .EXAMPLE
        Invoke-SophosCentralEndpointScan -EndpointID (Get-SophosCentralEndpoints).ID
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/scans/post
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [string[]]$EndpointID
    )
    begin {
        $uriChild = '/endpoint/v1/endpoints/{0}/scans'
        $uriString = $GLOBAL:SophosCentral.RegionEndpoint + $uriChild
    }
    process {
        foreach ($endpoint in $EndpointID) {
            $uri = [System.Uri]::New($uriString -f $endpoint)
            Invoke-SophosCentralWebRequest -Uri $uri -Method Post
        }
    }
}