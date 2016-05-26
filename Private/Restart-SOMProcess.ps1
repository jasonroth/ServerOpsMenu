Function Restart-SOMProcess {
    <#
        .SYNOPSIS
            ####

        .DESCRIPTION
            ####

        .PARAMETER Name
            ####
        
        .EXAMPLE
            ####
        
		.EXAMPLE
            ####
			
        .EXAMPLE
            ####
  #>

    [CmdletBinding()]
        Param (
            [Parameter(
            Mandatory=$true,
            Position=0,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
	        [ValidateNotNullOrEmpty()]
            [string[]]
            $Name
        )

    Begin {}
    
    Process {
        foreach ($Item in $Name) {
            try {
                $ProcessID = (Get-Process -Name $Name -ErrorAction Stop).Id
            }
            catch {
                Write-Warning $_
            }
            foreach ($ID in $ProcessID) {
                try {                
                    $Command = ((Get-WmiObject -Class Win32_Process -Filter "Handle=$ID" -ErrorAction Stop).CommandLine).Split(' ')
                    $StartParams = @{
                        FilePath = $Command[0]
                        PassThru = $true
                        ErrorAction = 'Stop'
                    }
                    if ($Command[1]) {
                        $StartParams.Add('ArgumentList', $Command[1])
                    }
                    Stop-Process -Id $ID -Confirm -Force -PassThru  -ErrorAction Stop
                    Wait-Process -Id $ID -Timeout 30 -ErrorAction SilentlyContinue
                    Write-Host -ForegroundColor Green -Object "Successfully stopped $Item process"
                    Start-Process @StartParams
                    Write-Host -ForegroundColor Green -Object "Successfully started $Item process"
                }
                catch {
                    Write-Warning $_
                }
            }
        }
	}
    
    End {}
}
