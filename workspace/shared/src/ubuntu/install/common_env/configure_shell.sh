#!/usr/bin/env bash
set -ex

# Complete Shell Configuration - Shared across all environments
# Handles: aliases, PATH, environment variables, virtualenv prompt, Docker settings
BASHRC_FILE="/etc/bash.bashrc"

# Helper functions
ensureEnvVar() {
    local var_name="$1"
    local var_value="$2"
    local bashrc_file="${3:-$BASHRC_FILE}"

    if grep -q "^export $var_name=" "$bashrc_file"; then
        echo "=== ✅ $var_name already set in $bashrc_file ==="
    else
        echo "export $var_name=$var_value" | sudo tee -a "$bashrc_file" > /dev/null
        echo "=== ✅ Set $var_name in $bashrc_file ==="
    fi
}

addToPATH() {
    local new_path="$1"
    local bashrc_file="${2:-$BASHRC_FILE}"

    local path_line="export PATH=\"$new_path:\$PATH\""

    if grep -q "^export PATH=\"$new_path:" "$bashrc_file"; then
        echo "=== ✅ PATH already includes $new_path ==="
    else
        echo "$path_line" | sudo tee -a "$bashrc_file" > /dev/null
        echo "=== ✅ Added $new_path to PATH in $bashrc_file ==="
    fi
}

echo "=== [5/5] Configuring environment ==="

# Add aliases for virtual environments
grep -q 'alias flaskenv=' "$BASHRC_FILE" || echo 'alias flaskenv="source /opt/venvs/flaskenv/bin/activate"' | sudo tee -a "$BASHRC_FILE"
grep -q 'alias pagesenv=' "$BASHRC_FILE" || echo 'alias pagesenv="source /opt/venvs/pagesenv/bin/activate"' | sudo tee -a "$BASHRC_FILE"

# Add VS Code alias (no-sandbox for container environments)
grep -q 'alias code=' "$BASHRC_FILE" || echo 'alias code="code --no-sandbox"' | sudo tee -a "$BASHRC_FILE"

# Add to PATH
addToPATH "/opt/venvs/flaskenv/bin"
addToPATH "/opt/venvs/pagesenv/bin"
addToPATH "/opt/gems/bin"

# Set environment variables
ensureEnvVar "GEM_HOME" "/opt/gems"
ensureEnvVar "DOCKER_BUILDKIT" "1"
ensureEnvVar "COMPOSE_DOCKER_CLI_BUILD" "1"

# Add virtualenv prompt
if ! grep -q 'VIRTUAL_ENV' "$BASHRC_FILE"; then
    sudo tee -a "$BASHRC_FILE" > /dev/null <<'EOF'
# Show Python virtualenv in prompt
if [[ -n "$VIRTUAL_ENV" ]]; then
    venv="($(basename $VIRTUAL_ENV)) "
else
    venv=""
fi
export PS1="${venv}\u:\w\$ "
EOF
    echo "=== ✅ Added virtualenv prompt logic to $BASHRC_FILE ==="
else
    echo "=== ✅ Virtualenv prompt logic already exists in $BASHRC_FILE ==="
fi

echo "=== ✅ Environment configuration complete ==="
