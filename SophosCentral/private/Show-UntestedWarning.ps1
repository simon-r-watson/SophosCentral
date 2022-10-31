function Show-UntestedWarning {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$CustomWarning
    )
    if ($null -eq $SCRIPT:TestWarning) {
        $SCRIPT:TestWarning = $true
    }
    
    if ($SCRIPT:TestWarning -eq $true) {
        if ($null -ne $CustomWarning) {
            Write-Warning $CustomWarning
        } else {
            Write-Warning 'This command has not been tested'
        }
        
        $action = Read-Host -Prompt "Continue?`ny: Continue`nn: Stop`nf: Ignore untested warnings for this session`nEnter response here"
        switch ($action) {
            'y' {  }
            'n' { throw 'cancelling' }
            'f' { $SCRIPT:TestWarning = $false }
            Default { throw 'cancelling' }
        }
    }
}