$launcher=Join-Path $PSScriptRoot 'Iniciar-Bateria.vbs'
$shortcutPath=Join-Path $PSScriptRoot 'Bateria do headset.lnk'
$shell=New-Object -ComObject WScript.Shell
$link=$shell.CreateShortcut($shortcutPath)
$link.TargetPath=Join-Path $env:SystemRoot 'System32\wscript.exe'
$link.Arguments='"'+$launcher+'"'
$link.WindowStyle=7
$link.WorkingDirectory=$PSScriptRoot
$link.Description='Bateria do Logitech G535 pelo G Hub'
$link.Save()
Write-Host 'Atalho criado nesta pasta. Abra Bateria do headset para iniciar sem terminal.'
