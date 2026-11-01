@echo off
setlocal
REM Launch the Janus-Pro gradio demo. Runs setup on first use.
cd /d "%~dp0"

if not exist ".venv\.janus_setup_done" (
    set "JANUS_FROM_LAUNCHER=1"
    call "%~dp0setup_windows.bat" || goto :error
)

call ".venv\Scripts\activate.bat" || goto :error

if "%JANUS_MODEL%"=="" set "JANUS_MODEL=deepseek-ai/Janus-Pro-1B"
if "%JANUS_PORT%"=="" set "JANUS_PORT=7860"
echo [Janus] Model: %JANUS_MODEL%
echo [Janus] The browser opens automatically at http://127.0.0.1:%JANUS_PORT% once the model is loaded.
echo [Janus] First launch downloads the model weights (~4 GB for 1B); this can take a while.
echo [Janus] Close this window to stop Janus.
echo.

python demo\app_januspro.py
if errorlevel 1 goto :error
goto :eof

:error
echo.
echo [Janus] Janus exited with an error. See the messages above.
pause
exit /b 1
