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

    Begin {}

    Process {
        Get-CimInstance Win32_LogicalDisk |
        Where-Object DriveType -eq 3 |
        foreach {[pscustomobject]@{
        ID = $_.DeviceID;VolumeName = $_.VolumeName
        'Disk Space' = '{0}GB/{1}GB Used' -f (([math]::round($_.Size/1GB)-[math]::round($_.FreeSpace/1GB))),([math]::round($_.Size/1GB))}}
	}

    End {}
}
