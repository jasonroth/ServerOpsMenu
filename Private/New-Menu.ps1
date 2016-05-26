$title = 'Server Operations Tasks'
$path = 'ServerOpsMenu.xml'

$hash = [ordered]@{
    'Get Services' = {Get-SOMService | Format-Table}
    'Restart Service' = {Restart-SOMService}
    'Get Top 5 Processes by CPU' = {Get-SOMProcess -Property CPU}
    'Get Top 5 Processes by Memory' = {Get-SOMProcess -Property Memory}
    'Stop Process' = {Stop-SOMProcess -Verbose}
    'Restart Process' = {Restart-SOMProcess -Verbose}
    'Get Volumes' = {Get-SOMVolume}
    'Get Recent System Eventlog' = {Get-SOMEventLog | Format-Table -AutoSize}
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