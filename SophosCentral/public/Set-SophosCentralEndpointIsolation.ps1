function Set-SophosCentralEndpointIsolation {
    <#
    .SYNOPSIS
        Turn on or off endpoint isolation for multiple endpoints.
    .DESCRIPTION
        Turn on or off endpoint isolation for multiple endpoints.
    .PARAMETER EndpointID
        The ID of the Endpoint. Use Get-SophosCentralEndpoints to list them
    .PARAMETER Enabled
        Use $true to enable isolation, $false to disable
    .PARAMETER Comment
        Reason the endpoints should be isolated or not
    .EXAMPLE
        Set-SophosCentralEndpointIsolation -EndpointID '23a920fa-9a34-4869-bc3d-a1626e50f670' -Enabled $false -Comment "disable iso"
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/isolation/post
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [string[]]$EndpointID,

        [Parameter(Mandatory = $true,
            ParameterSetName = 'Update Status')]
        [System.Boolean]$Enabled,

        [Parameter(Mandatory = $true)]
        [string]$Comment,

        [switch]$Force
    )
    begin {
        $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoints/isolation')
    }
    process {
        
        $body = @{
            enabled = $Enabled
            comment = $Comment
            ids     = @()
        }
        foreach ($endpoint in $EndpointID) {
            $body['ids'] += $endpoint
        }
        
        if ($Force -or $PSCmdlet.ShouldProcess('isolation', ($EndpointID -join ', '))) {
            Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
        } 
    }
    
}