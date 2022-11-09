function Get-SophosCentralUser {
    <#
    .SYNOPSIS
        Get users listed in Sophos Central
    .DESCRIPTION
        Get users listed in Sophos Central
    .EXAMPLE
        Get-SophosCentralUser -ID 0eb3048c-ed91-4a01-8d39-923c6ca90868

        Find the user with the ID of 0eb3048c-ed91-4a01-8d39-923c6ca90868
    .EXAMPLE
        Get-SophosCentralUser -Search 'John'

        Search for users full name containing John    
    .EXAMPLE
        Get-SophosCentralUser -Search 'Smith' -SearchField 'lastName'

        Search for users last name containing Smith
    .EXAMPLE
        Get-SophosCentralUser -SourceType 'activeDirectory'

        Search for users sourced from Active Directory
    .PARAMETER ID
        ID to match
    .PARAMETER Search
        Search for items that match the given terms
    .PARAMETER SearchFields
        Search only within the specified fields. When not specified, the default behavior is to search the full names of users only.
    .PARAMETER SourceType
        Types of sources of directory information. All users and groups created using this API have the source type custom. All users and groups synced from Active Directory or Azure Active Directory have the source type activeDirectory or azureActiveDirectory.
    .PARAMETER GroupId
        Search for users in a group that has this ID.
    .PARAMETER Domain
        List the items that match the given domain.
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/directory/users/get
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralUsers')]
    param (

        [ValidateScript({
                if ($false -eq [System.Guid]::TryParse($_, $([ref][guid]::Empty))) {
                    throw 'Not a valid GUID' 
                } else {
                    return $true
                }
            })]
        [string]$ID,
        
        [string]$Search,

        [ValidateSet('name', 'firstName', 'lastName', 'email', 'exchangeLogin')]
        [string]$SearchField,

        [ValidateSet('custom', 'activeDirectory', 'azureActiveDirectory')]
        [string]$SourceType,
        
        [ValidateScript({
                if ($false -eq [System.Guid]::TryParse($_, $([ref][guid]::Empty))) {
                    throw 'Not a valid GUID' 
                } else {
                    return $true
                }
            })]
        [string]$GroupID,
        
        [string]$Domain
    )
    Test-SophosCentralConnected

    $body = @{}
    if ($ID) { $body.Add('ids', $id) }
    if ($Search) { $body.Add('search', $Search) }
    if ($SearchField) { $body.Add('searchFields', $SearchField) }
    if ($SourceType) { $body.Add('sourceType', $SourceType) }
    if ($GroupID) { $body.Add('groupId', $GroupID) }
    if ($Domain) { $body.Add('domain', $Domain) }

    $uriChild = '/common/v1/directory/users?pageTotal=true'
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)

    if ($body.Keys.Count -eq 0) {
        Invoke-SophosCentralWebRequest -Uri $uri
    } else {
        Invoke-SophosCentralWebRequest -Uri $uri -Body $body
    }
}