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

    Begin {}

    Process {
        Get-Eventlog -LogName System -Newest 50 |
        Select-Object Index, TimeGenerated, InstanceID, EntryType, Message
	}

    End {}
}
