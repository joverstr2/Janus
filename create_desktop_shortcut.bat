@echo off
REM Creates a "Janus-Pro" shortcut on your Windows desktop that runs launch_janus.bat.
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$repo = (Resolve-Path '.').Path;" ^
  "$desktop = [Environment]::GetFolderPath('Desktop');" ^
  "$ws = New-Object -ComObject WScript.Shell;" ^
  "$s = $ws.CreateShortcut((Join-Path $desktop 'Janus-Pro.lnk'));" ^
  "$s.TargetPath = (Join-Path $repo 'launch_janus.bat');" ^
  "$s.WorkingDirectory = $repo;" ^
  "$s.Description = 'Launch the Janus-Pro demo';" ^
  "$s.IconLocation = \"$env:SystemRoot\System32\shell32.dll,13\";" ^
  "$s.Save();" ^
  "Write-Host ('Created shortcut: ' + (Join-Path $desktop 'Janus-Pro.lnk'))"
if errorlevel 1 (
    echo Failed to create the shortcut.
) else (
    echo Done. Double-click "Janus-Pro" on your desktop to start.
)
pause
