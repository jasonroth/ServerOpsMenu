Function Invoke-IHGMenu {
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
            [Parameter(Mandatory=$false,
            Position=0)]
            [string[]]
            $Parameter1
        )

    Begin {
        #Get-MOTD
    }
    Process {

        Invoke-MyMenu -Path .\ADTasks.xml
	}
    End {
    
    }
}
