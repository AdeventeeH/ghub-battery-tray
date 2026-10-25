$scriptPath=Join-Path $PSScriptRoot 'Bateria-G535.ps1'
$shortcutPath=Join-Path $PSScriptRoot 'Bateria do headset.lnk'
$shell=New-Object -ComObject WScript.Shell
$link=$shell.CreateShortcut($shortcutPath)
$link.TargetPath=Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
$link.Arguments='-NoProfile -STA -WindowStyle Hidden -ExecutionPolicy Bypass -File "'+$scriptPath+'"'
$link.WorkingDirectory=$PSScriptRoot
$link.Description='Bateria do Logitech G535 pelo G Hub'
$link.Save()
Write-Host 'Atalho criado nesta pasta. Abra Bateria do headset para iniciar.'
