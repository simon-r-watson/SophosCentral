function New-SophosCentralEndpointGroup {
    <#
    .SYNOPSIS
        Add new endpoint group to the directory.
    .DESCRIPTION
        Add new endpoint group to the directory.
    .PARAMETER Name
        The name of the group
    .PARAMETER Description
        The description of the group
    .PARAMETER Type
        The type of the group
    .PARAMETER EndpointID
        The ID of the endpoint(s) to add to the group
    .EXAMPLE
        New-SophosCentralEndpointGroup -Name "Test Group" -Type "computer" -EndpointID "12345678-1234-1234-1234-123456789012"
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoint-groups/post
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$Description,

        [Parameter(Mandatory = $true)]
        [ValidateSet('computer', 'server')]
        [string]$Type,

        [ValidateScript({
                foreach ($id in $_) {
                    if ($false -eq [System.Guid]::TryParse($id, $([ref][guid]::Empty))) {
                        throw 'Not a valid GUID'
                    }
                }
                if ($_.Count -ge 1000) {
                    throw 'Too many endpoints specified, please specify less than 1000'
                }
                if ($_.Count -ne ($_ | Select-Object -Unique).Count) {
                    throw 'Duplicate endpoints specified, please specify each endpoint only once'
                }

                return $true
            })]
        [string[]]$EndpointID,

        [switch]$Force
    )
    Test-SophosCentralConnected

    $body = @{
        name = $Name
    }
    if ($Description) { $body.Add('description', $Description) }
    if ($Type) { $body.Add('type', $Type) }
    if ($EndpointID) { $body.Add('endpointIds', $EndpointID) }

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoint-groups')

    if ($Force -or $PSCmdlet.ShouldProcess('Create group', ($Name))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
    }
}
