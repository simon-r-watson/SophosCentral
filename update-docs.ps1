Install-Module platyps -Scope CurrentUser -Force
Import-Module .\SophosCentral\SophosCentral.psd1
New-MarkdownHelp -Module SophosCentral -OutputFolder .\docs
New-ExternalHelp -Path .\docs -OutputPath en-us\

Update-MarkdownHelp .\docs