Option Explicit
Dim shell, fs, folder, scriptPath, powershell, command
Set shell = CreateObject("WScript.Shell")
Set fs = CreateObject("Scripting.FileSystemObject")
folder = fs.GetParentFolderName(WScript.ScriptFullName)
scriptPath = fs.BuildPath(folder, "Bateria-G535.ps1")
powershell = shell.ExpandEnvironmentStrings("%SystemRoot%") & "\System32\WindowsPowerShell\v1.0\powershell.exe"
If Not fs.FileExists(scriptPath) Then
    MsgBox "Bateria-G535.ps1 nao encontrado na pasta do iniciador.", 48, "Bateria do headset"
    WScript.Quit 1
End If
command = Chr(34) & powershell & Chr(34) & " -NoProfile -STA -WindowStyle Hidden -ExecutionPolicy Bypass -File " & Chr(34) & scriptPath & Chr(34)
shell.CurrentDirectory = folder
shell.Run command, 0, False
