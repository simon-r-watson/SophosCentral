function Get-SophosCentralPartnerBilling {
    <#
    .SYNOPSIS
        Get billing usage report
    .DESCRIPTION
        Get billing usage report
    .EXAMPLE
        Get-SophosCentralPartnerBilling -LastMonth
    .EXAMPLE
        Get-SophosCentralPartnerBilling -Month 5 -Year 2022
    .LINK
        https://developer.sophos.com/docs/partner-v1/1/routes/billing/usage/%7Byear%7D/%7Bmonth%7D/get
    #>
    [CmdletBinding()]
    param (
        [Parameter(Position = 0,
            Mandatory = $true,
            ParameterSetName = 'Custom')]
        [ValidateRange(1, 12)]
        [int]$Month,
        
        [Parameter(Position = 1,
            Mandatory = $true,
            ParameterSetName = 'Custom')]
        [ValidateRange(2000, 2050)]
        [int]$Year,

        [Parameter(Position = 2,
            ParameterSetName = 'LastMonth')]
        [switch]$LastMonth
    )

    if ($SCRIPT:SophosCentral.IDType -ne 'partner') {
        throw 'You are not currently logged in using a Sophos Central Partner Service Principal'
    } else {
        Write-Verbose 'currently logged in using a Sophos Central Partner Service Principal'
    }

    if ($LastMonth) {
        $date = (Get-Date).AddMonths(-1)
        $Year = $date.Year
        $Month = $date.Month
    }

    $header = Get-SophosCentralAuthHeader -PartnerInitial
    $uri = [System.Uri]::New("https://api.central.sophos.com/partner/v1/billing/usage/$year/$month")
    Invoke-SophosCentralWebRequest -Uri $uri -CustomHeader $header
}