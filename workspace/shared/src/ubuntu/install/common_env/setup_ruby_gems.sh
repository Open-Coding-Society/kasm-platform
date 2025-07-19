#!/usr/bin/env bash
set -ex

# Helper function for gem installation
ensure_gem_installed() {
    local gem_name=$1
    if gem list -i "$gem_name" > /dev/null 2>&1; then
        echo "=== ✅ Gem '$gem_name' already installed ==="
    else
        echo "=== ✅ Installing gem '$gem_name'... ==="
        gem install "$gem_name" || { echo "❌ ERROR: Failed to install gem: $gem_name" >&2; exit 1; }
    fi
}

# Common Ruby Gems Setup - Shared across all environments
echo "=== [4/5] Installing Ruby Gems ==="
export GEM_HOME=/opt/gems
export PATH=$GEM_HOME/bin:$PATH
mkdir -p "$GEM_HOME"
chmod -R 777 "$GEM_HOME"

# Core gems
ensure_gem_installed bundler
ensure_gem_installed jekyll

# Ruby stdlib gems (Ruby 3+ modular gems)
ensure_gem_installed benchmark
ensure_gem_installed openssl
ensure_gem_installed zlib
ensure_gem_installed racc
ensure_gem_installed bigdecimal
ensure_gem_installed drb
ensure_gem_installed unicode-display_width
ensure_gem_installed logger
ensure_gem_installed etc
ensure_gem_installed fileutils
ensure_gem_installed ipaddr
ensure_gem_installed mutex_m
ensure_gem_installed ostruct
ensure_gem_installed rss
ensure_gem_installed strscan
ensure_gem_installed stringio
ensure_gem_installed time

chmod -R 777 "$GEM_HOME"
echo "=== ✅ Ruby environment configured ==="
