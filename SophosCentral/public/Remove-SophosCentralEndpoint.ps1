function Remove-SophosCentralEndpoint {
    <#
    .SYNOPSIS
        Deletes a specified endpoint.
    .DESCRIPTION
        Deletes a specified endpoint.
    .PARAMETER EndpointID
        The ID of the endpoint
    .EXAMPLE
        Remove-SophosCentralEndpoint -EndpointID 59412c23-0ef1-49d6-9f4f-3b8b4863c176
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoints/get
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [string[]]$EndpointID,

        [switch]$Force
    )
    
    foreach ($endpoint in $EndpointID) {
        $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoints/' + $endpoint)
        if ($Force -or $PSCmdlet.ShouldProcess('Remove Endpoint', $Endpoint)) {
            Invoke-SophosCentralWebRequest -Uri $uri -Method Delete
        }
    }
}