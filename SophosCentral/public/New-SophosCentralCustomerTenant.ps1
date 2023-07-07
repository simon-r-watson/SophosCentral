function New-SophosCentralCustomerTenant {
    <#
    .SYNOPSIS
        Create a new tenant.
    .DESCRIPTION
        Create a new tenant.
    .PARAMETER Name
        Name of the tenant
    .EXAMPLE
        New-SophosCentralCustomerTenant -Name 'Test User' -DataGeography AU -BillingType 'trial' -FirstName 'John' -LastName 'Smith' -Email 'test@contoso.com' -Phone '+612000000' -Address1 '31 Bligh St' -City 'Sydney' -CountryCode 'AU' -PostalCode '2000' -State 'New South Whales'
    .LINK
        https://developer.sophos.com/docs/partner-v1/1/routes/tenants/post
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateSet('US', 'IE', 'DE', 'CA', 'AU', 'JP')]
        [string]$DataGeography,

        [Parameter(Mandatory = $true)]
        [ValidateSet('trial', 'usage')]
        [string]$BillingType,

        [Parameter(Mandatory = $true)]
        [string]$FirstName,

        [Parameter(Mandatory = $true)]
        [string]$LastName,

        [Parameter(Mandatory = $true)]
        [string]$Email,

        [Parameter(Mandatory = $true)]
        [string]$Phone,

        [Parameter(Mandatory = $true)]
        [string]$Address1,

        [string]$Address2,

        [string]$Address3,

        [Parameter(Mandatory = $true)]
        [string]$City,

        [string]$State,

        [Parameter(Mandatory = $true)]
        [string]$CountryCode,

        [Parameter(Mandatory = $true)]
        [string]$PostalCode,

        [switch]$Force
    )
    Test-SophosCentralConnected

    if ((Test-SophosPartner) -eq $false) {
        throw 'You are not currently logged in using a Sophos Central Partner Service Principal'
    }

    $uri = [System.Uri]::New('https://api.central.sophos.com/partner/v1/tenants')

    $body = @{
        name          = $Name
        dataGeography = $DataGeography
        billingType   = $billingType
        contact       = @{
            firstName = $firstName
            lastName  = $lastName
            email     = $email
            phone     = $Phone
            address   = @{
                address1    = $address1
                city        = $City
                countryCode = $countryCode
                postalCode  = $postalCode
            }
        }
    }
    if ($address2) { $body['contact']['address'].Add('address2', $address2) }
    if ($address3) { $body['contact']['address'].Add('address3', $address3) }
    if ($state) { $body['contact']['address'].Add('state', $state) }

    try {
        $header = Get-SophosCentralAuthHeader -PartnerInitial
    } catch {
        throw $_
    }

    if ($Force -or $PSCmdlet.ShouldProcess($Name, ($body.keys -join ', '))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Method Post -Body $body -CustomHeader $header
    }
}
