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
            $Property,
            
            [Parameter()]
            [string]
            $ComputerName
        )

    Begin {
        $CommandParams = @{
            ErrorAction = 'Stop'
        }
        if ($ComputerName) {
           $CommandParams.Add('ComputerName', $ComputerName) 
        }
        
        if ($Property -eq 'CPU') {
            $PropertyName = 'CPU(%)'
            $Expression = {
                    $TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
                    [Math]::Round( ($_.CPU * 100 / $TotalSec), 2)
                }

        }
        elseif ($Property -eq 'Memory') {
            $PropertyName = 'Memory(MB)'
            $Expression = @{
                Name = $PropertyName
                Expression = {
                    [Math]::Round( ($_.WS / 1MB), 2)
                }
            }
        }
        $PropertyQuery = @{
            PropertyName = $PropertyName
            Expression = $Expression
        }
    }

    Process {

        Get-Process @CommandParams | 
        Select-Object -Property Name, Description, $PropertyQuery |
        Sort-Object -Property $PropertyName -Descending |
        Select-Object -First 5
    }

    End {}
}
