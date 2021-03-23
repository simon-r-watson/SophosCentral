function Invoke-SophosCentralEndpointUpdate {
    <#
    .SYNOPSIS
        Trigger a update on an Endpoint in Sophos Central
    .DESCRIPTION
        Trigger a update on an Endpoint in Sophos Central
    .EXAMPLE
        Invoke-SophosCentralEndpointUpdate -EndpointID "6d41e78e-0360-4de3-8669-bb7b797ee515"
    .EXAMPLE
        Invoke-SophosCentralEndpointUpdate -EndpointID (Get-SophosCentralEndpoints).ID
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("ID")]
        [string[]]$EndpointID
    )
    begin {
        $uriChild = "/endpoint/v1/endpoints/{0}/update-checks"
        $uriString = $GLOBAL:SophosCentral.RegionEndpoint + $uriChild
    }
    process {
        foreach ($endpoint in $EndpointID) {
            $uri = [System.Uri]::New($uriString -f $endpoint)
            Invoke-SophosCentralWebRequest -Uri $uri -Method Post
        }
    }
}