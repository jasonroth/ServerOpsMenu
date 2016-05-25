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
            Position=0,
            ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
	        [ValidateNotNullOrEmpty()]
            [string[]]
            $Service
        )

    Begin {}
    
    Process {
        foreach ($Item in $Service) {
            try {
                Stop-Service -Name $Item -Confirm -Force -PassThru -ErrorAction Stop
                Start-Service -Name $Item -PassThru -ErrorAction Stop
                Write-Host -NoNewline -ForegroundColor Green -Object "Successfully restarted $Item service"
            }
            catch {
                Write-Warning $_
            }
        }
	}
    End {}
}
