Function get-SOMservice {
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
        Get-CimInstance Win32_Service |
        foreach {
             DisplayName = $_.DisplayName
             Name = $_.Name
             StartMode = $_.StartMode
             State = $_.State
             Status = $_.Status
        }
    }
    
    End {}
}

