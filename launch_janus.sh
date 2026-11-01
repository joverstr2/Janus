#!/usr/bin/env bash
# Launch the Janus-Pro gradio demo on Linux. Sets up .venv on first run.
set -euo pipefail
cd "$(dirname "$(readlink -f "$0")")"

PY="${PYTHON:-python3.10}"
command -v "$PY" >/dev/null 2>&1 || PY=python3

if [ ! -f .venv/.janus_setup_done ]; then
    echo "[Janus] First run: setting up .venv (Python 3.10 recommended) ..."
    [ -x .venv/bin/python ] || "$PY" -m venv .venv
    # shellcheck disable=SC1091
    . .venv/bin/activate
    python -m pip install --upgrade pip
    python -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121
    python -m pip install -e ".[gradio]"
    python -c "import torch; print('[Janus] torch', torch.__version__, '| CUDA available:', torch.cuda.is_available())"
    touch .venv/.janus_setup_done
fi

# shellcheck disable=SC1091
. .venv/bin/activate
export JANUS_MODEL="${JANUS_MODEL:-deepseek-ai/Janus-Pro-1B}"
export JANUS_PORT="${JANUS_PORT:-7860}"
echo "[Janus] Model: $JANUS_MODEL — opening http://127.0.0.1:$JANUS_PORT when ready"
exec python demo/app_januspro.py
