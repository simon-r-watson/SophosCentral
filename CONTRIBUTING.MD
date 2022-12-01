# Contributing

## General

* Please use Visual Studio Code (VSCode) and open root repository folder in VSCode. This will ensure you get the correct extensions for PowerShell (and the its script analyzer) and basic spell check. It will also correctly format the ps1 files when you save them.
* Please resolve any warnings or errors reported by PSScriptAnalyzer in VSCode for the files you are updating, or add suppression and justification on why to ignore it. For more info on this see <https://learn.microsoft.com/en-us/powershell/utility-modules/psscriptanalyzer/using-scriptanalyzer?view=ps-modules#suppressing-rules>

## How to debug a function

Create a new ps1 file in the root of the repo and enter in the following. For the purpose of this example we will call it test.ps1

```powershell
#Remove the module if already imported (so you get the latest updates when running)
$modules = 'SophosCentral-Debug', 'SophosCentral'
foreach ($module in $modules) {
    if (Get-Module $module) {
        Remove-Module $module
    }
}

Import-Module .\SophosCentral\SophosCentral-Debug.psm1

#Connect to Sophos Central, you can change this to the secret vault method if you have set this up
#You will need to connect each time the module is removed/imported
$clientID = Read-Host -Prompt "Client ID"
$clientSecret = Read-Host -AsSecureString -Prompt "Client Secret:"
Connect-SophosCentral -ClientID $clientID -ClientSecret $clientSecret

#Connect to a customer tenant, if you are a Partner or Enterprise tenant
Connect-SophosCentralCustomerTenant -CustomerTenantID "7d565595-e281-4128-9711-c97eb1d202c5"

#Function you want to test
Get-SophosCentralEndpoint -LastSeenAfter '-P3DT4H5M0S'
```

Then set a breakpoint in VSCode, either on the function in the above snippet in your test.ps1 file, or on a line in another function called by the function from your test.ps1.

Run the test.ps1 in VSCode (Run > Start Debugging).
