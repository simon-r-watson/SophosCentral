function Remove-SophosCentralXDRQueryRun {
    <#
    .SYNOPSIS
        Cancel a query run by ID.
    .DESCRIPTION
        Cancel a query run by ID.
    .PARAMETER RunId
        Query run ID.
    .EXAMPLE
        Remove-SophosCentralXDRQueryRun -RunID 6fed0eb5-d8ff-44ee-9c37-df8a9924373d
    .LINK
        https://developer.sophos.com/docs/xdr-query-v1/1/routes/queries/runs/%7BrunId%7D/cancel/post
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipelineByPropertyName = $true)]
        [Alias('ID')]
        [string[]]$RunID,

        [switch]$Force
    )
    
    Show-UntestedWarning

    foreach ($run in $RunID) {
        $uriChild = "/xdr-query/v1/queries/runs/$($run)/cancel"
        $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
        if ($Force -or $PSCmdlet.ShouldProcess('Remove', $run)) {
            Invoke-SophosCentralWebRequest -Uri $uri -Method Post
        }
    }
}