Function Stop-SOMProcess {
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
            [string]
            $ComputerName,

            [Parameter()]
            [PsCredential]
            [System.Management.Automation.CredentialAttribute()]
            $Credential
        )

    Begin {}
    
    Process {
        foreach ($Process in $Name) {
            try {
                Stop-Process -Name $Process -Confirm -Force -PassThru  -ErrorAction Stop
                #Start-Service -Name $Item -PassThru -ErrorAction Stop
                Write-Host -NoNewline -ForegroundColor Green -Object "Successfully stopped $Process process"
            }
            catch {
                Write-Warning $_
            }
        }
	}
    
    End {}
}
