' This is useful when running powershell scripts from Task Scheduler.
' Passing `-WindowStyle Hidden` is not enough to run script completely in backgroud, it still flashes a powershell window.
' This script runs powershell script without any window at all.

' Task scheduler settings:
' Program/script:
'   C:\Windows\System32\wscript.exe
' Arguments:
'   "C:\path\to\run_ps.vbs" "C:\path\to\script.ps1"

Set objArgs = WScript.Arguments
If objArgs.Count = 0 Then
    WScript.Echo "Usage: wscript run_ps.vbs <full-path-to-script.ps1>"
    WScript.Quit 1
End If

scriptPath = objArgs(0)

Set shell = CreateObject("WScript.Shell")
powershellCmd = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & scriptPath & """"

shell.Run powershellCmd, 0, False
