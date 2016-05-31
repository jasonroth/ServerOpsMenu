Function Invoke-Menu {
    <#
        .SYNOPSIS
            Systems and server operations menu for service desk personnel.

        .DESCRIPTION
            Scaffolding for generating custom operations menus. Can be used for local or remote management.
            Server management, AD, Exchange, etc...

        .PARAMETER ComputerName
            Remote system to be managed.
        
        .PARAMETER Credential
            Optional credential parameter    
        
        .EXAMPLE
            Invoke-Menu -ComputerName Server1.contoso.com
        
		.EXAMPLE
            Invoke-Menu -ComputerName Server1.contoso.com -Credential contoso\admin

        .VERSION
            0.1.0            
    #>
    
    [cmdletbinding()]
    #Requires -RunAsAdministrator
        Param (
            [Parameter(
            Mandatory=$false,
            Position=0)]
			[string[]]
            $ComputerName,

            [Parameter(
            Mandatory=$false,
            Position=1)]
            [PsCredential]
            [System.Management.Automation.CredentialAttribute()]
            $Credential,

            [Parameter(
            Mandatory=$false,
            Position=2)]
            [ValidateScript({
                if (Test-Path $_) {$True}
                else {Throw "Cannot validate path $_"}
            })]
            [string]
            $Path = 'ServerTasks.xml'
        )

    Begin {

        if ($ComputerName) {

# Build Hash to be used for passing parameters to New-PSSession commandlet
        
            $PSSessionParams = @{
                ComputerName = $ComputerName
                ErrorAction = 'Stop'
            }

# Add optional parameters to hash

            if ($Credential) {
                $PSSessionParams.Add('Credential', $Credential)
            }
            
# Create remote powershell session
            
            try {
                $RemoteSession = New-PSSession @PSSessionParams
            }
            catch {
                $Message = (Get-Date -Format HH:mm:ss).ToString()+" : Unable to initiate remote session with client ComputerName ; $_"
                Write-Warning $Message
                break
            }
            Get-MOTD @PSSessionParams
        }
        else {
            Get-MOTD
        }
       
# Import Menu and verify there are title and item properties
        
        $ImportedMenu = Import-Clixml -Path $Path
        if ($ImportedMenu.Title -AND $ImportedMenu.Items) {
        
            $HereMenu = @"

$($ImportedMenu.title)


"@
        }
    }

    Process {
        foreach ($Item in $ImportedMenu.Items) {
            $HereMenu+= "{0}) {1}`n" -f $Item.ItemNumber,$Item.MenuItem
        }
        
        $HereMenu += "Enter a menu number or Q to quit"
        
# Keep looping and running the menu until the user selects Q (or q).

        $Running = $True
        
        Do {
            #cls
            $Selection = Read-Host $HereMenu
            if ($Selection -match "^q" -OR $Selection.length -eq 0) {

# quit the menu
                $Running = $False
                Write-Host "Exiting the menu. Have a nice day" -ForegroundColor green
# bail out
                Return
            }
            elseif (-Not ([int]$Selection -ge 1 -AND [int]$Selection -le $($ImportedMenu.Items.count)) ) {
                
                Write-Warning "Enter a menu choice between 1 and $($ImportedMenu.Items.count) or Q to quit"
            }
            else {

#create a scriptblock

                $ScriptBlock = [scriptblock]::Create($ImportedMenu.Items[$Selection -1].action)

# Build Hash to be used for passing parameters to Invoke-Command commandlet
            
                $CommandParams = @{
                    ScriptBlock = $ScriptBlock
                    ErrorAction = 'Stop'
                }
                if ($Credential) {
                    $CommandParams.Add('Credential', $Credential)  
                }
    
# Add optional parameters to hash
    
                Invoke-Command @CommandParams | Out-Host

#pause

                $Nothing = Read-Host "Press any key to continue"
            }
        }

        While ($Running)
        
        else {
            Write-Warning "$Path does not appear to have menu information"
        }
    }

    End {}
}

