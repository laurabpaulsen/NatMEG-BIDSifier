#!/usr/bin/env bash
# Setup script for NatMEG BIDSifier User Edition
# Initializes submodule and configures local environment

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

echo "🔧 NatMEG BIDSifier - User Edition Setup"
echo "========================================"
echo

# Check if git is initialized
if [[ ! -d "$REPO_ROOT/.git" ]]; then
  echo "Initializing git repository..."
  cd "$REPO_ROOT"
  git init
  echo "✓ Git initialized"
  echo
fi

# Add submodule if not already present
if [[ ! -f "$REPO_ROOT/.gitmodules" ]] || ! grep -q "shared/admin" "$REPO_ROOT/.gitmodules" 2>/dev/null; then
  echo "Adding admin repo as submodule..."
  cd "$REPO_ROOT"
  
  read -rp "Enter admin repo URL (e.g., git@github.com:k-CIR/NatMEG-BIDSifier-admin.git): " admin_repo_url
  
  git submodule add "$admin_repo_url" shared/admin
  
  # Create symlink to localctl.sh
  mkdir -p "$REPO_ROOT/scripts"
  ln -sf ../shared/admin/scripts/localctl.sh "$REPO_ROOT/scripts/localctl.sh"
  
  echo "✓ Submodule added and symlinked"
  echo
else
  # Submodule already configured, just ensure it's initialized
  if [[ ! -d "$REPO_ROOT/shared/admin/.git" ]]; then
    echo "Initializing submodule..."
    cd "$REPO_ROOT"
    git submodule update --init --recursive
    echo "✓ Submodule initialized"
    echo
  else
    echo "✓ Submodule already initialized"
    echo
  fi
fi

# Make scripts executable
chmod +x "$REPO_ROOT/localctl-ui.sh" 2>/dev/null || true
chmod +x "$REPO_ROOT/scripts/localctl.sh" 2>/dev/null || true

# Create config directory
mkdir -p "$REPO_ROOT/.config"

# Ask for initial configuration
echo "Initial Configuration"
echo "===================="
echo
read -rp "SSH Target (user@host): " ssh_target
read -rp "Remote Repository Path [/data/users/natmeg/scripts/NatMEG-BIDSifier]: " remote_repo
remote_repo=${remote_repo:-/data/users/natmeg/scripts/NatMEG-BIDSifier}
read -rp "Local Port [8080]: " local_port
local_port=${local_port:-8080}

# Save configuration
cat > "$REPO_ROOT/.config/settings" <<EOF
SSH_TARGET="$ssh_target"
REMOTE_REPO="$remote_repo"
LOCAL_PORT="$local_port"
EOF

echo
echo "✓ Configuration saved to .config/settings"
echo

# Create .gitignore
cat > "$REPO_ROOT/.gitignore" <<EOF
# Local configuration
.config/settings
.connect_logs/
*.log
.venv/
__pycache__/
*.pyc
.DS_Store
EOF

echo "✓ .gitignore created"
echo

# Test SSH connection
echo "Testing SSH connection..."
if ssh -o ConnectTimeout=5 "$ssh_target" "echo '✓ SSH connection successful'" 2>/dev/null; then
  echo
else
  echo "⚠ Warning: Could not connect to $ssh_target"
  echo "Check your credentials and try again."
  echo
fi

echo "Setup Complete!"
echo "=============="
echo
echo "Next steps:"
echo "  1. Start the tunnel:    ./localctl-ui.sh"
echo "  2. Or use directly:     ./scripts/localctl.sh start"
echo
echo "For more information, see README.md"
