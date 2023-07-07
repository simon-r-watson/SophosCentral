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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('UseProcessBlockForPipelineCommand', 'All', Justification = 'We do not need to use the variable', Scope = 'Function')]
    param (
        [Parameter(Mandatory = $false,
            ParameterSetName = 'ID')]
        [Alias('ID')]
        [string]$PolicyId,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'Base')]
        [switch]$BasePolicy,

        [Parameter(Mandatory = $false,
            ParameterSetName = 'All')]
        [switch]$All
    )
    Test-SophosCentralConnected

    if ($BasePolicy) {
        $PolicyId = 'base'
    }

    $uriChild = '/endpoint/v1/policies'
    if ($All) {
        $uriChild = $uriChild + '?pageTotal=true'
    } elseif (-not([string]::IsNullOrEmpty($PolicyId))) {
        $uriChild = "$($uriChild)/$($PolicyId)"
    }
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)
    Invoke-SophosCentralWebRequest -Uri $uri
}
