function New-SophosCentralUser {
    <#
    .SYNOPSIS
        Create a new user in Sophos Central
    .DESCRIPTION
        Create a new user in Sophos Central
    .PARAMETER Name
        This parameter is mandatory
    .PARAMETER GroupIDs
        A list/array of group ID's to add them to. To determine the ID of the groups use Get-SophosCentralUserGroups
    .EXAMPLE
        New-SophosCentralUser -Name "John Smith" -FirstName "John" -LastName "Smith" -Email "jsmith@contoso.com"
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/directory/users/post
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$FirstName,
        [string]$LastName,
        [string]$Email,
        [string]$ExchangeLogin,
        [string[]]$GroupIDs,
        [switch]$Force
    )
    Test-SophosCentralConnected
    
    $uriChild = '/common/v1/directory/users'
    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + $uriChild)

    $body = @{
        name = $Name
    }
    if ($firstName) { $body.Add('firstName', $FirstName) }
    if ($LastName) { $body.Add('lastName', $LastName) }
    if ($email) { $body.Add('email', $email) }
    if ($exchangeLogin) { $body.Add('exchangeLogin', $exchangeLogin) }
    if ($groupIds) { $body.Add('groupIds', $groupIds) }

    if ($Force -or $PSCmdlet.ShouldProcess('Create user', ($Name))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body
    }
}