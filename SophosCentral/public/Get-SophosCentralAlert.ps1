function Get-SophosCentralAlert {
    <#
    .SYNOPSIS
        Get alerts listed in Sophos Central
    .DESCRIPTION
        Get alerts listed in Sophos Central
    .PARAMETER Product
        Alerts for a product. You can query by product types.
    .PARAMETER Category
        Alert category. You can query by different categories.
    .PARAMETER Severity
        Alerts for a specific severity level. You can query by severity levels.
    .EXAMPLE
        Get-SophosCentralAlert

        Get all active alerts in the tenant
    .EXAMPLE
        Get-SophosCentralAlert -Product 'server' -Severity 'high

        Get all alerts relating to Sophos Central for Server protection wih High severity
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/alerts/get
    .LINK
        https://developer.sophos.com/docs/common-v1/1/routes/alerts/search/post
    #>
    [CmdletBinding()]
    [Alias('Get-SophosCentralAlerts')]
    param (
        [Parameter(ParameterSetName = 'search')]
        [ValidateSet('other', 'endpoint', 'server', 'mobile', 'encryption', 'emailGateway', 'webGateway', 'phishThreat', 'wireless', 'iaas', 'firewall')]
        [string[]]$Product,

        [Parameter(ParameterSetName = 'search')]
        [ValidateSet('azure', 'adSync', 'applicationControl', 'appReputation', 'blockListed', 'connectivity', 'cwg', 'denc', 'downloadReputation', 'endpointFirewall', 'fenc', 'forensicSnapshot', 'general', 'iaas', 'iaasAzure', 'isolation', 'malware', 'mtr', 'mobiles', 'policy', 'protection', 'pua', 'runtimeDetections', 'security', 'smc', 'systemHealth', 'uav', 'uncategorized', 'updating', 'utm', 'virt', 'wireless', 'xgEmail')]
        [string[]]$Category,

        [Parameter(ParameterSetName = 'search')]
        [ValidateSet('low', 'medium', 'high')]
        [string[]]$Severity
    )
    if ($PsCmdlet.ParameterSetName -ne 'search') {
        $uriChild = '/common/v1/alerts'
        $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)
        Invoke-SophosCentralWebRequest -Uri $uri

    } elseif ($PsCmdlet.ParameterSetName -eq 'search') {
        $uriChild = '/common/v1/alerts/search'
        $uri = [System.Uri]::New($GLOBAL:SophosCentral.RegionEndpoint + $uriChild)

        $searchParam = @{}
        if ($Product) { $searchParam.Add('product', $Product) }
        if ($Category) { $searchParam.Add('category', $Category) }
        if ($Severity) { $searchParam.Add('severity', $Severity) }

        Invoke-SophosCentralWebRequest -Uri $uri -Body $searchParam -Method Post
    }
}
