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
            [Parameter(
            Mandatory=$false,
            Position=0)]
			[ValidateNotNullOrEmpty()]
            [string[]]
            $ComputerName,

            [Parameter()]
            [PsCredential]
            [System.Management.Automation.CredentialAttribute()]
            $Credential
        )
        
    Begin {}

    Process {
        $CommandParams = @{
            LogName = 'System'
            Newest = '50'
            ErrorAction = 'Stop'
        }
        if ($ComputerName) {
           $CommandParams.Add('ComputerName', $ComputerName) 
        }
        if ($Credential) {
            $CommandParams.Add('Credential', $Credential)  
        }
        Get-Eventlog @CommandParams |
        Select-Object -Property Index,
                                TimeGenerated,
                                InstanceID,
                                EntryType,
                                Message
	}

    End {}
}
