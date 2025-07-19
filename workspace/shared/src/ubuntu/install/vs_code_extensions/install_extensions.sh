#!/usr/bin/env bash
set -ex

# VS Code Extensions Installation - Common for all environments
echo "=== Installing VS Code Extensions ==="

code --user-data-dir /root/.vscode --no-sandbox --install-extension github.vscode-github-actions \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-python.python \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-azuretools.vscode-docker \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-vscode-remote.remote-containers \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension VisualStudioExptTeam.vscodeintellicode \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-toolsai.jupyter \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-toolsai.vscode-jupyter-cell-tags \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-toolsai.jupyter-keymap \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-python.vscode-pylance \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension ms-python.debugpy \
  && code --user-data-dir /root/.vscode --no-sandbox --install-extension yy0931.vscode-sqlite3-editor

echo "=== VS Code Extensions Installation Complete ==="
