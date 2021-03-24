function Set-SophosCentralEndpointTamperProtection {
    <#
    .SYNOPSIS
        Update Tamper Protection settings
    .DESCRIPTION
        Update Tamper Protection settings
    .PARAMETER EndpointID
        The ID of the Endpoint. Use Get-SophosCentralEndpoints to list them
    .PARAMETER Enabled
        Use $true to enable Tamper Protection, $false to disable
    .PARAMETER RegeneratePassword
        Use this switch to generate a new Tamper Protection password
    .EXAMPLE
        Set-SophosCentralEndpointTamperProtection -EndpointID '23a920fa-9a34-4869-bc3d-a1626e50f670' -Enabled $false
    .EXAMPLE
        Set-SophosCentralEndpointTamperProtection -EndpointID '23a920fa-9a34-4869-bc3d-a1626e50f670' -RegeneratePassword
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/%7BendpointId%7D/tamper-protection/post
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("ID")]
        [string[]]$EndpointID,

        [Parameter(Mandatory = $true,
            ParameterSetName = "Update Status")]
        [System.Boolean]$Enabled,

        [Parameter(Mandatory = $true,
            ParameterSetName = "Regenerate Password")]
        [switch]$RegeneratePassword
    )
    begin {
        $uriChild = "/endpoint/v1/endpoints/{0}/tamper-protection"
        $uriString = $GLOBAL:SophosCentral.RegionEndpoint + $uriChild
    }
    process {
        foreach ($endpoint in $EndpointID) {
            $uri = [System.Uri]::New($uriString -f $endpoint)
            $body = @{}
            if ($Enabled) { $body.Add('enabled', $Enabled) }
            if ($RegeneratePassword) { $body.Add('regeneratePassword', $RegeneratePassword) }
            Invoke-SophosCentralWebRequest -Uri $uri -Method Post
        }
    }
}