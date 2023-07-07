function Update-SophosCentralEndpointGroup {
    <#
    .SYNOPSIS
        Add new endpoint group to the directory.
    .DESCRIPTION
        Add new endpoint group to the directory.
    .PARAMETER ID
        The ID of the group
    .PARAMETER Name
        The name of the group
    .PARAMETER Description
        The description of the group
    .EXAMPLE
        Update-SophosCentralEndpointGroup -ID "12345678-1234-1234-1234-123456789012" -Name "Test Group"
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/endpoint-groups/%7BgroupId%7D/patch
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if ($false -eq [System.Guid]::TryParse($_, $([ref][guid]::Empty))) {
                    throw 'Not a valid GUID'
                } else {
                    return $true
                }
            })]
        [string]$ID,

        [string]$Name,

        [string]$Description,

        [switch]$Force
    )
    Test-SophosCentralConnected

    $body = @{
    }
    if ($Description) { $body.Add('description', $Description) }
    if ($Name) { $body.Add('name', $Name) }

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/endpoint-groups/' + $ID)

    if ($Force -or $PSCmdlet.ShouldProcess('Update group', ($ID))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Patch -Body $body
    }
}
