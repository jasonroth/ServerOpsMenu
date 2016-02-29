Function Invoke-MyMenu {
[cmdletbinding()]
Param(
[Parameter(Position=0,Mandatory,HelpMessage = "Enter the path to an XML file with an exported menu")]
[ValidateScript({
if (Test-Path $_) {
$True
}
else {
Throw "Cannot validate path $_"
}
})]

[string]$Path
)

$importedMenu = Import-Clixml -Path $path

#verify there are title and item properties

if ($importedMenu.Title -AND $importedMenu.Items) {
$hereMenu = @"

$($ImportedMenu.title)

"@

foreach ($item in $importedMenu.Items) {
$hereMenu+= "{0} - {1}`n" -f $item.ItemNumber,$item.MenuItem
}

$hereMenu += "Enter a menu number or Q to quit"

#Keep looping and running the menu until the user selects Q (or q).
$Running = $True
Do {
cls
Get-MOTD
$r = Read-Host $hereMenu
if ($r -match "^q" -OR $r.length -eq 0) {
#quit the menu
$running = $False
Write-Host "Exiting the menu. Have a nice day" -ForegroundColor green
#bail out
Return
}
elseif ( -Not ([int]$r -ge 1 -AND [int]$r -le $($importedMenu.Items.count)) ) {
Write-Warning "Enter a menu choice between 1 and $($importedMenu.Items.count) or Q to quit"
}
else {
#create a scriptblock
$cmd = [scriptblock]::Create($importedMenu.Items[$r-1].action)
Invoke-Command -ScriptBlock $cmd | Out-Host
#pause
$nothing = Read-Host "Press any key to continue"
}
} While ($Running)

}
else {
Write-Warning "$Path does not appear to have menu information"
}

} #end Function
