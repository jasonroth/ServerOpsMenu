Function Get-SOMEventLog {
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
            [Parameter()]
            [string]
            $ComputerName
        )
        
    Begin {
        
        $CommandParams = @{
            LogName = 'System'
            Newest = '50'
            ErrorAction = 'Stop'
        }
        if ($ComputerName) {
           $CommandParams.Add('ComputerName', $ComputerName) 
        }
    }

    Process {

        try {
            Get-Eventlog @CommandParams |
            Select-Object -Property Index,
                                    TimeGenerated,
                                    InstanceID,
                                    EntryType,
                                    Message
        }
        catch {
            Write-Warning $_  
        }
	}

    End {}
}
