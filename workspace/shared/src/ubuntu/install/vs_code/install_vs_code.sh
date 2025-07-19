#!/usr/bin/env bash
set -ex
ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/x64/g')
wget -q https://update.code.visualstudio.com/latest/linux-deb-${ARCH}/stable -O vs_code.deb
apt-get update
apt-get install -y ./vs_code.deb
mkdir -p /usr/share/icons/hicolor/apps
wget -O /usr/share/icons/hicolor/apps/vscode.svg https://kasm-static-content.s3.amazonaws.com/icons/vscode.svg
sed -i '/Icon=/c\Icon=/usr/share/icons/hicolor/apps/vscode.svg' /usr/share/applications/code.desktop
sed -i 's#/usr/share/code/code#/usr/share/code/code --no-sandbox##' /usr/share/applications/code.desktop
cp /usr/share/applications/code.desktop $HOME/Desktop
chmod +x $HOME/Desktop/code.desktop
chown 1000:1000 $HOME/Desktop/code.desktop
rm vs_code.deb

# Install VS Code Extensions
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

# Conveniences for python development
apt-get update
apt-get install -y python3-setuptools \
                   python3-venv \
                   python3-virtualenv

# Cleanup
if [ -z ${SKIP_CLEAN+x} ]; then
  apt-get autoclean
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/*
fi
