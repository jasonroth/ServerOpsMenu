Function Get-MOTD {
<#
.NAME
    Get-MOTD

.SYNOPSIS
    Displays system information to a host.

.DESCRIPTION
    The Get-MOTD cmdlet is a system information tool written in PowerShell. 

.EXAMPLE

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

    $ScriptBlock = {
    $Operating_System = Get-CimInstance -ClassName Win32_OperatingSystem
    $Logical_Disk = Get-CimInstance -ClassName Win32_LogicalDisk |
    Where-Object -Property DeviceID -eq $Operating_System.SystemDrive

    [pscustomobject]@{
        Operating_System = $Operating_System
        Processor = Get-CimInstance -ClassName Win32_Processor
        Process_Count = (Get-Process).Count
        Shell_Info = "{0}.{1}" -f $PSVersionTable.PSVersion.Major,$PSVersionTable.PSVersion.Minor
        Logical_Disk = $Logical_Disk
    }
}

    if ($ComputerName) {

# Build Hash to be used for passing parameters to New-PSSession commandlet
        
    $PSSessionParams = @{
        ComputerName = $ComputerName
        ErrorAction = 'Stop'
        OutVariable = 'RemoteSession'
    }

# Add optional parameters to hash

    if ($Credential) {
        $PSSessionParams.Add('Credential', $Credential)
    }
            
# Create remote powershell session
            
    try {
        New-PSSession @PSSessionParams |
        Out-Null
    }
    catch {
        $Message = (Get-Date -Format HH:mm:ss).ToString()+" : Unable to initiate remote session with client $Computer ; $_"
        Write-Verbose $Message
        break
    }
}
    
# Build Hash to be used for passing parameters to Invoke-Command commandlet
            
        $CommandParams = @{
            ScriptBlock = $ScriptBlock
            OutVariable = 'ReturnedValues'
            ErrorAction = 'Stop'
    }
    
# Add optional parameters to hash
    
        if ($RemoteSession) {
        $CommandParams.Add('Session', $RemoteSession)
    }
           
# Run ScriptBlock
        
        try {
            Invoke-Command @CommandParams |
            Out-Null
    }
        catch {
        $Message = (Get-Date -Format HH:mm:ss).ToString()+" : Data collection failed on $ComputerName ; $_"
        Write-Verbose $Message
        break
    }   

    # Assign variables
    $Date = Get-Date
    $OS_Name = $ReturnedValues.Operating_System.Caption
    $Computer_Name = $ReturnedValues.Operating_System.CSName
    $Kernel_Info = $Operating_System.Version
    $Process_Count = $ReturnedValues.Process_Count
    $Uptime = "$(($Uptime = $Date - $($ReturnedValues.Operating_System.LastBootUpTime)).Days) days, $($Uptime.Hours) hours, $($Uptime.Minutes) minutes"
    $Shell_Info = $ReturnedValues.Shell_Info
    $CPU_Info = $ReturnedValues.Processor.Name -replace '\(C\)', '' -replace '\(R\)', '' -replace '\(TM\)', '' -replace 'CPU', '' -replace '\s+', ' '
    $Current_Load = $ReturnedValues.Processor.LoadPercentage
    $Memory_Size = "{0}mb/{1}mb Used" -f (([math]::round($ReturnedValues.Operating_System.TotalVisibleMemorySize/1KB)-
        [math]::round($Operating_System.FreePhysicalMemory/1KB))),([math]::round($Operating_System.TotalVisibleMemorySize/1KB))
    $Disk_Size = "{0}gb/{1}gb Used" -f (([math]::round($ReturnedValues.Logical_Disk.Size/1GB)-
        [math]::round($ReturnedValues.Logical_Disk.FreeSpace/1GB))),([math]::round($ReturnedValues.Logical_Disk.Size/1GB))

    # Write to the Console
    Write-Host -Object ("")
    Write-Host -Object ("")
    Write-Host -Object ("         ,.=:^!^!t3Z3z.,                  ") -ForegroundColor Red
    Write-Host -Object ("        :tt:::tt333EE3                    ") -ForegroundColor Red
    Write-Host -Object ("        Et:::ztt33EEE ") -NoNewline -ForegroundColor Red
    Write-Host -Object (" @Ee.,      ..,     $Date") -ForegroundColor Green
    Write-Host -Object ("       ;tt:::tt333EE7") -NoNewline -ForegroundColor Red
    Write-Host -Object (" ;EEEEEEttttt33#     ") -ForegroundColor Green
    Write-Host -Object ("      :Et:::zt333EEQ.") -NoNewline -ForegroundColor Red
    Write-Host -Object (" SEEEEEttttt33QL     ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("User: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("$env:UserName") -ForegroundColor Cyan
    Write-Host -Object ("      it::::tt333EEF") -NoNewline -ForegroundColor Red
    Write-Host -Object (" @EEEEEEttttt33F      ") -NoNewline -ForeGroundColor Green
    Write-Host -Object ("Hostname: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("$Computer_Name") -ForegroundColor Cyan
    Write-Host -Object ("     ;3=*^``````'*4EEV") -NoNewline -ForegroundColor Red
    Write-Host -Object (" :EEEEEEttttt33@.      ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("OS: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("$OS_Name") -ForegroundColor Cyan
    Write-Host -Object ("     ,.=::::it=., ") -NoNewline -ForegroundColor Cyan
    Write-Host -Object ("``") -NoNewline -ForegroundColor Red
    Write-Host -Object (" @EEEEEEtttz33QF       ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("Kernel: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("NT ") -NoNewline -ForegroundColor Cyan
    Write-Host -Object ("$Kernel_Info") -ForegroundColor Cyan
    Write-Host -Object ("    ;::::::::zt33) ") -NoNewline -ForegroundColor Cyan
    Write-Host -Object ("  '4EEEtttji3P*        ") -NoNewline -ForegroundColor Green
    Write-Host -Object ("Uptime: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("$Uptime") -ForegroundColor Cyan
    Write-Host -Object ("   :t::::::::tt33.") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (":Z3z.. ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object (" ````") -NoNewline -ForegroundColor Green
    Write-Host -Object (" ,..g.        ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("Shell: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("Powershell $Shell_Info") -ForegroundColor Cyan
    Write-Host -Object ("   i::::::::zt33F") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" AEEEtttt::::ztF         ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("CPU: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("$CPU_Info") -ForegroundColor Cyan
    Write-Host -Object ("  ;:::::::::t33V") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" ;EEEttttt::::t3          ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("Processes: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("$Process_Count") -ForegroundColor Cyan
    Write-Host -Object ("  E::::::::zt33L") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" @EEEtttt::::z3F          ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("Current Load: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("$Current_Load") -NoNewline -ForegroundColor Cyan
    Write-Host -Object ("%") -ForegroundColor Cyan
    Write-Host -Object (" {3=*^``````'*4E3)") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" ;EEEtttt:::::tZ``          ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("Memory: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("$Memory_Size") -ForegroundColor Cyan
    Write-Host -Object ("             ``") -NoNewline -ForegroundColor Cyan
    Write-Host -Object (" :EEEEtttt::::z7            ") -NoNewline -ForegroundColor Yellow
    Write-Host -Object ("System Volume: ") -NoNewline -ForegroundColor Red
    Write-Host -Object ("$Disk_Size") -ForegroundColor Cyan
    Write-Host -Object ("                 'VEzjt:;;z>*``           ") -ForegroundColor Yellow
    Write-Host -Object ("                      ````                  ") -ForegroundColor Yellow
    Write-Host -Object ("")
}
