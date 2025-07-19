#!/usr/bin/env bash
set -ex

# ====== Setup Constants ======
LOGFILE="/tmp/kasm_install_tools.log"
exec > >(tee -a "$LOGFILE") 2>&1

# ====== Setup Functions ======
log() {
    echo "=== ✅ $1 ==="
}

# ====== Start Installation ======
echo "=== 🏗️ Starting KASM Tools Installation (Noble) ==="

# ====== Environment-Specific Package Installation ======
echo "=== [1/4] Installing Noble-specific packages ==="
apt-get update && log "APT update complete"
apt-get install -y \
    curl \
    sudo \
    wget \
    nano \
    zip \
    build-essential \
    ruby-full \
    jupyter-notebook \
    sqlite3 \
    python3 \
    python3-pip \
    python-is-python3 \
    default-jdk \
    default-jre-headless \
    bundler \
    ca-certificates \
    software-properties-common \
    && log "APT packages installed"

# ====== User Permissions Setup ======
echo "=== [2/4] Setting up user permissions ==="
echo "kasm-user  ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers && log "Sudo configured for kasm-user"

# ====== Shared Environment Setup ======
echo "=== [3/4] Setting up shared development environment ==="

# Setup Python virtual environments
log "Running shared Python environment setup..."
/usr/bin/setup_python_envs.sh

# Setup Ruby gems
log "Running shared Ruby gems setup..."
/usr/bin/setup_ruby_gems.sh

# Configure shell environment
log "Running shared shell configuration..."
/usr/bin/configure_shell.sh

# ====== Cleanup ======
echo "=== [4/4] Final cleanup ==="
if [ -z ${SKIP_CLEAN+x} ]; then
    apt-get autoclean
    rm -rf \
        /var/lib/apt/lists/* \
        /var/tmp/* \
        /tmp/*
    log "Cleanup complete"
fi

echo "=== ✅ KASM Tools Installation Complete (Noble) ==="
