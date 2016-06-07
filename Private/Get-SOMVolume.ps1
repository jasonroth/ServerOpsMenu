Function Get-SOMVolume{
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
            Class = 'Win32_LogicalDisk'
            ErrorAction = 'Stop'
        }
        if ($ComputerName) {
           $CommandParams.Add('ComputerName', $ComputerName) 
        }
    }

    Process {
        
        try {
            Get-CimInstance @CommandParams |
            Where-Object DriveType -eq 3 |
            foreach {
                [pscustomobject]@{
                    ID = $_.DeviceID;VolumeName = $_.VolumeName
                    'Disk Space' = '{0}GB/{1}GB Used' -f (([math]::round(
                    $_.Size/1GB) -[math]::round(
                    $_.FreeSpace/1GB))),([math]::round($_.Size/1GB))
                }
            }
        }
        catch {
            Write-Warning $_
        }
	}

    End {}
}
