function New-SophosCentralAdmin {
    <#
    .SYNOPSIS
        Create a tenant admin from a directory user.
    .DESCRIPTION
        Create a tenant admin from a directory user.
    .PARAMETER UserID
        ID of an existing user to add admin roles to.
    .PARAMETER RoleID
        ID of roles to assign to the user
    .EXAMPLE
        New-SophosCentralAdmin -UserID 'd5a81643-34db-4c44-a942-d83207ca402c' -RoleID 'fd18b044-a832-4b1a-a7a3-85e663366303'
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/admins/post
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({
                if ($false -eq [System.Guid]::TryParse($_, $([ref][guid]::Empty))) {
                    throw 'Not a valid GUID'
                } else {
                    return $true
                }

            })]
        [string]$UserID,

        [Parameter(Mandatory = $true)]
        [ValidateScript({
                foreach ($role in $_) {
                    if ($false -eq [System.Guid]::TryParse($role, $([ref][guid]::Empty))) {
                        throw 'Not a valid GUID'
                    } else {
                        return $true
                    }
                }
            })]
        [string[]]$RoleID,

        [switch]$Force
    )
    Test-SophosCentralConnected

    $uriChild = '/common/v1/admins'
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)

    $body = @{
        userId          = $UserID
        roleAssignments = @()
    }
    foreach ($role in $RoleID) {
        $roleHash = @{
            roleId = $role
        }
        $body['roleAssignments'] += $roleHash
    }

    if ($Force -or $PSCmdlet.ShouldProcess('Assign admin role', ($UserID))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
    }
}
