$title = 'Server Operations Tasks'
$path = 'ServerTasks.xml'

$hash = [ordered]@{
    'Get Services' = {Get-SOMService -ComputerName $ComputerName | Format-Table}
    'Restart Service' = {Restart-SOMService -ComputerName $ComputerName}
    'Get Top 5 Processes by CPU' = {Get-SOMProcess -Property CPU -ComputerName $ComputerName}
    'Get Top 5 Processes by Memory' = {Get-SOMProcess -Property Memory -ComputerName $ComputerName}
    'Stop Process' = {Stop-SOMProcess -Verbose -ComputerName $ComputerName}
    'Restart Process' = {Restart-SOMProcess -Verbose -ComputerName $ComputerName}
    'Get Volumes' = {Get-SOMVolume -ComputerName $ComputerName}
    'Get Recent System Eventlog' = {Get-SOMEventLog -ComputerName $ComputerName | Format-Table -AutoSize}
    'Restart Server' = {Restart-Computer -Confirm -Force -ComputerName $ComputerName}    
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