#!/usr/bin/env bash
set -ex

# Common System Environment Configuration - Shared across all environments
echo "=== Configuring Common System Environment Settings ==="

# VS Code alias (no-sandbox for container environments)
grep -q 'alias code=' /etc/bash.bashrc || echo 'alias code="code --no-sandbox"' | tee -a /etc/bash.bashrc

# Set Docker environment variables for improved builds
echo 'export DOCKER_BUILDKIT=1' | tee -a /etc/bash.bashrc
echo 'export COMPOSE_DOCKER_CLI_BUILD=1' | tee -a /etc/bash.bashrc

echo "=== ✅ Common System Environment Configuration Complete ==="
