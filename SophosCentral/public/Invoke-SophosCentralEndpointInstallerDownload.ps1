function Invoke-SophosCentralEndpointInstallerDownload {
    <#
    .SYNOPSIS
        Download the endpoint installer.
    .DESCRIPTION
        Download the endpoint installer.
    .EXAMPLE
        Invoke-SophosCentralEndpointInstallerDownload -RequestedProduct interceptX -Platform windows -FilePath 'C:\SophosSetup.exe'
    .LINK
        https://developer.sophos.com/docs/endpoint-v1/1/routes/downloads/get
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('coreAgent', 'interceptX', 'xdr', 'endpointProtection', 'deviceEncryption', 'mtr', 'mtd', 'ztna')]
        [string]$RequestedProduct = 'interceptX',

        [Parameter(Mandatory = $false)]
        [ValidateSet('windows', 'linux', 'macOS')]
        [string]$Platform = 'windows',

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
                if ($_ | Test-Path) {
                    throw 'File already exists'
                }
                return $true
            })]
        [System.IO.FileInfo]$FilePath
    )
    $links = Get-SophosCentralEndpointInstallerLink
    foreach ($installers in $links.installers) {
        if (($installers.supportedProducts -contains $RequestedProduct) -and ($installers.platform -eq $Platform)) {
            Invoke-WebRequest -Uri $installers.downloadUrl -UseBasicParsing -OutFile $FilePath
        }
    }
    if (-not(Test-Path $FilePath)) {
        Write-Error 'Installer was not downloaded. Ensure you selected the correct product/platform'
    }
}