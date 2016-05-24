$title = 'Server Operations Tasks'
$path = 'ServerOpsMenu.xml'

$hash = [ordered]@{
    'Get Services' = {Get-SOMService | Format-Table}
    'Restart Service' = {Restart-SOMService}
    'Get Top 5 Processes by CPU' = {Get-SOMProcess -Property CPU}
    'Get Top 5 Processes by Memory' = {Get-SOMProcess -Property Memory}
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