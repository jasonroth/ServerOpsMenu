$title = 'Server Operations Tasks'
$path = 'ServerOpsMenu.xml'

$hash = [ordered]@{
    'Get Services' = {Get-CimInstance Win32_Service | Select-Object 'DisplayName','Name','StartMode','State','Status' | Format-Table -AutoSize}
    'Restart Service' = {Get-Service (Read-Host 'Service Name') | Restart-Service -Confirm -Force -Verbose}
    'Get Top 5 Processes by CPU' = {Get-Process | Sort-Object -Descending -Property CPU | Select-Object -First 5 | Format-Table -AutoSize}
    'Get Top 5 Processes by Memory' = {Get-Process | Sort-Object -Descending -Property WS | Select-Object -First 5 | Format-Table -AutoSize}
    'Stop Process' = {Get-Process (Read-Host 'Process Name') | Stop-Process -Confirm -Force -Verbose}
    'Get Volumes' = {Get-CimInstance Win32_LogicalDisk | Where-Object DriveType -eq 3 | foreach {[pscustomobject]@{ID = $_.DeviceID;VolumeName = $_.VolumeName;'Disk Space' = '{0}GB/{1}GB Used' -f (([math]::round($_.Size/1GB)-[math]::round($_.FreeSpace/1GB))),([math]::round($_.Size/1GB))}}}
    'Get Recent System Eventlog' = {Get-Eventlog -LogName System -Newest 50 | Select-Object Index, TimeGenerated, InstanceID, EntryType, Message | Format-Table -AutoSize}
    'Restart Server' = {Restart-Computer -Confirm -Force}
    
}

#create item objects
$items = $hash.GetEnumerator() | foreach -Begin {
$i=0 } -Process {
$i++
[pscustomobject]@{
ItemNumber = $i
MenuItem = $_.Name
Action = $_.Value
}
} -end {}

$MyMenu = [pscustomObject]@{
Title = $Title
Items = $items
}

$MyMenu | Export-Clixml -Path $path