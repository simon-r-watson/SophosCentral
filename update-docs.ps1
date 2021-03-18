Install-Module platyps -Scope CurrentUser -Force
Import-Module .\SophosCentral\SophosCentral.psd1
New-MarkdownHelp -Module SophosCentral -OutputFolder .\docs -Force
New-ExternalHelp -Path .\docs -OutputPath en-us\ -Force

Update-MarkdownHelp .\docs -Force

Remove-Module SophosCentral