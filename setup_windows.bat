@echo off
setlocal
REM One-time (idempotent) setup for Janus-Pro on Windows with an NVIDIA GPU.
REM Creates .venv, installs CUDA 12.1 PyTorch, then this repo with the gradio extras.
cd /d "%~dp0"

if not exist ".venv\Scripts\python.exe" (
    echo [Janus] Creating virtual environment in .venv ...
    REM Python 3.10 is recommended: some pinned demo deps lack wheels for newer Pythons.
    py -3.10 -m venv .venv 2>nul || python -m venv .venv
    if errorlevel 1 goto :error
)

call ".venv\Scripts\activate.bat" || goto :error

if exist ".venv\.janus_setup_done" (
    echo [Janus] Setup already completed. Delete .venv\.janus_setup_done to force a reinstall.
    goto :eof
)

python -m pip install --upgrade pip || goto :error
echo [Janus] Installing PyTorch with CUDA 12.1 ...
python -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121 || goto :error
echo [Janus] Installing Janus and gradio demo dependencies ...
python -m pip install -e .[gradio] || goto :error

python -c "import torch; print('[Janus] torch', torch.__version__, '| CUDA available:', torch.cuda.is_available())"
echo done> ".venv\.janus_setup_done"
echo [Janus] Setup complete.
goto :eof

:error
echo.
echo [Janus] Setup FAILED. See the messages above.
if not "%JANUS_FROM_LAUNCHER%"=="1" pause
exit /b 1
