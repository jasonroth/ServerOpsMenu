Function Get-SOMProcess {
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
            Position=0)]
            [ValidateSet("CPU", "Memory")]
            [string]
            $Property
        )

    Begin {}

    Process {
        if ($Property -eq 'CPU') {
            $CPUPercent = @{
                Name = 'CPUPercent'
                Expression = {
                    $TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
                    [Math]::Round( ($_.CPU * 100 / $TotalSec), 2)
                }
            }
            Get-Process | 
            Select-Object -Property Name, Description, $CPUPercent |
            Sort-Object -Property CPUPercent -Descending |
            Select-Object -First 5
        }
        elseif ($Property -eq 'Memory') {
            $MemoryMB = @{
                Name = 'Memory(MB)'
                Expression = {
                    [Math]::Round( ($_.WS / 1MB), 2)
                }
            }
            Get-Process | 
            Select-Object -Property Name, Description, $MemoryMB |
            Sort-Object -Property CPUPercent -Descending |
            Select-Object -First 5
        }
    }

    End {}
}
