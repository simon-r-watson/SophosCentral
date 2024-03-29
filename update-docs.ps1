if (Get-Module SophosCentral) {
    Remove-Module SophosCentral
}

if (-not (Test-Path -Path .\docs)) {
    New-Item -Path .\docs -ItemType Directory
}

Install-Module platyps -Scope CurrentUser -Force
Import-Module .\SophosCentral\SophosCentral.psd1
New-MarkdownHelp -Module SophosCentral -OutputFolder .\docs -Force
New-ExternalHelp -Path .\docs -OutputPath output\SophosCentral\en-us\ -Force
New-ExternalHelp -Path .\docs -OutputPath output\SophosCentral\en-au\ -Force
New-ExternalHelp -Path .\docs -OutputPath output\SophosCentral\en-gb\ -Force

Update-MarkdownHelp .\docs -Force

Copy-Item .\README.md -Destination .\docs\Home.md

Remove-Module SophosCentral