Function Restart-SOMService {
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
	        [ValidateNotNullOrEmpty()]
            [string[]]
            $Name,
            
            [Parameter()]
            [string[]]
            $ComputerName,

            [Parameter()]
            [PsCredential]
            [System.Management.Automation.CredentialAttribute()]
            $Credential
        )

    Begin {}
    
    Process {
        foreach ($Service in $Name) {
            try {
                Stop-Service -Name $Service -Confirm -Force -PassThru -ErrorAction Stop
                Start-Service -Name $Service -PassThru -ErrorAction Stop
                Write-Host -NoNewline -ForegroundColor Green -Object "Successfully restarted $Item service"
            }
            catch {
                Write-Warning $_
            }
        }
	}
    End {}
}
