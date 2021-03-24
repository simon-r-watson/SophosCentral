if (Get-Module SophosCentral) {
    Remove-Module SophosCentral
}

Install-Module platyps -Scope CurrentUser -Force
Import-Module .\SophosCentral\SophosCentral.psd1
New-MarkdownHelp -Module SophosCentral -OutputFolder .\docs -Force
New-ExternalHelp -Path ".\docs" -OutputPath output\SophosCentral\en-us\ -Force
New-ExternalHelp -Path .\docs -OutputPath output\SophosCentral\en-au\ -Force

Update-MarkdownHelp .\docs -Force

Remove-Module SophosCentral