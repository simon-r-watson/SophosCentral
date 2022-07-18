function Get-SophosCentralEndpointPolicy {
    <#
    .SYNOPSIS
        Get Policies
    .DESCRIPTION
        Get Policies
    .EXAMPLE
        Get-SophosCentralEndpointPolicy -All

        Get all policies
    .EXAMPLE
        Get-SophosCentralEndpointPolicy -BasePolicy

        Get base policies
    .LINK
        https://developer.sophos.com/endpoint-policies#get-all-policies
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralEndpointPolicies')]
    param (
        [Parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'ID')]
        [Alias('ID')]
        [string]$PolicyId,

        [Parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Base')]
        [switch]$BasePolicy,

        [Parameter(Mandatory = $false,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'All')]
        [switch]$All
    )

    if ($BasePolicy) {
        $PolicyId = 'base'
    }

    $uriChild = '/endpoint/v1/policies'
    if (-not([string]::IsNullOrEmpty($PolicyId))) {
        $uriChild = "$($uriChild)/$($PolicyId)"
    }
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}