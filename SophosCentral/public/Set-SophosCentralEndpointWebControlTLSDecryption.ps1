function Set-SophosCentralEndpointWebControlTLSDecryption {
    <#
    .SYNOPSIS
        Update settings for SSL/TLS decryption of HTTPS websites.
    .DESCRIPTION
        Update settings for SSL/TLS decryption of HTTPS websites.
    .PARAMETER Category
        The category name to enable/disable TLS decryption for.
    .PARAMETER CategoryID
        The category ID to enable/disable TLS decryption for.
    .PARAMETER EnableCategory
        Whether web decryption is enabled on websites in the specified category.
    .PARAMETER EnableTLSDecryption
        Whether SSL/TLS decryption of HTTPS websites is enabled.
    .EXAMPLE
        Set-SophosCentralEndpointWebControlTLSDecryption -Category 'Downloads' -EnableCategory $false -EnableTLSDecryption $true

        Disable TLS decryption for the 'Downloads' category.
    .EXAMPLE
        Set-SophosCentralEndpointWebControlTLSDecryption -Category 'Downloads', 'Finance & Investment', 'Health & Medicine' -EnableCategory $false -EnableTLSDecryption $true

        Disable TLS decryption for the 'Downloads', 'Finance & Investment' and 'Health & Medicine' categories.
    .EXAMPLE
        Set-SophosCentralEndpointWebControlTLSDecryption -CategoryID 10,14,20 -EnableCategory $false -EnableTLSDecryption $true

        Disable TLS decryption for the categories with IDs 10, 14 and 20. View possible categories with Get-SophosCentralEndpointWebControlCategory.
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/settings/web-control/tls-decryption/patch
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Category')]
        #[ValidateSet('Downloads', 'Finance & Investment', 'Health & Medicine', 'Job Search & Career Development', 'Web-based E-mail')]
        #[ValidateSet({ (Get-SophosCentralEndpointWebControlTLSDecryption).categories.name })]
        [ArgumentCompleter(
            {
                param($cmd, $param, $wordToComplete)
                # This is the duplicated part of the code in the [ValidateScipt] attribute.
                [array] $validValues = (Get-SophosCentralEndpointWebControlTLSDecryption).categories.name
                $validValues -like "$wordToComplete*"
            }
        )]
        [string[]]$Category,

        [Parameter(Mandatory = $true, ParameterSetName = 'CategoryID')]
        [int[]]$CategoryID,

        [Parameter(Mandatory = $true, ParameterSetName = 'Category')]
        [Parameter(Mandatory = $true, ParameterSetName = 'CategoryID')]
        [bool]$EnableCategory,

        [Parameter(Mandatory = $true, ParameterSetName = 'Category')]
        [Parameter(Mandatory = $true, ParameterSetName = 'CategoryID')]
        [bool]$EnableTLSDecryption,

        [Parameter(Mandatory = $false, ParameterSetName = 'Category')]
        [Parameter(Mandatory = $false, ParameterSetName = 'CategoryID')]
        [switch]$Force
    )
    Test-SophosCentralConnected

    #map category names to ids
    if ($null -ne $Category) {
        $possibleCategories = Get-SophosCentralEndpointWebControlTLSDecryption
        $categoryIdLookup = @{}
        foreach ($possibleCategory in $possibleCategories.categories) {
            $categoryIdLookup.Add($possibleCategory.name, $possibleCategory.id)
        }
        $CategoryID = $Category | ForEach-Object { $categoryIdLookup[$_] }
    }

    #generate body
    $categories = @()
    foreach ($c in $CategoryID) {
        $categories += @{
            id                = $c
            decryptionEnabled = $EnableCategory
        }
    }
    $body = @{
        enabled = $EnableTLSDecryption
    }
    if ($null -ne $categories) { $body.Add('categories', $categories) }

    $uri = [System.Uri]::New($SCRIPT:SophosCentral.RegionEndpoint + '/endpoint/v1/settings/web-control/tls-decryption')
    if ($Force -or $PSCmdlet.ShouldProcess('Update TLS Decryption Category', ($CategoryID))) {
        Invoke-SophosCentralWebRequest -Uri $uri -Body $body -Method Patch
    }
}
