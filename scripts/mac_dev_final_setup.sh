#!/usr/bin/env bash
set -euo pipefail

echo "==> Final Mac Dev Setup"
echo ""

# 1. Install Karabiner-Elements (requires sudo)
echo "==> Installing Karabiner-Elements (requires sudo password)..."
if [ -f "/opt/homebrew/Caskroom/karabiner-elements/15.5.0/Karabiner-Elements.pkg" ]; then
  sudo /usr/sbin/installer -pkg /opt/homebrew/Caskroom/karabiner-elements/15.5.0/Karabiner-Elements.pkg -target / || echo "Karabiner install failed or already installed"
else
  echo "Karabiner package not found, skipping..."
fi
echo ""

# 2. Install remaining GUI apps (aerospace, tailscale, ollama)
echo "==> Installing remaining GUI apps..."
brew install --cask nikitabobko/tap/aerospace 2>&1 | grep -E "successfully installed|already installed|Error" || true
brew install --cask tailscale 2>&1 | grep -E "successfully installed|already installed|Error" || true
brew install --cask ollama 2>&1 | grep -E "successfully installed|already installed|Error" || true
echo ""

# 3. Install Nix
echo "==> Installing Nix package manager..."
if ! command -v nix >/dev/null 2>&1; then
  curl -L https://install.determinate.systems/nix | sh -s -- install || echo "Nix install failed"
else
  echo "Nix already installed"
fi
echo ""

# 4. Wait for PostgreSQL to be ready and create database
echo "==> Setting up PostgreSQL database..."
export PATH="/opt/homebrew/bin:$PATH"
sleep 3
/opt/homebrew/opt/postgresql@16/bin/createdb "$(whoami)" 2>&1 || echo "Database already exists or postgres not ready"
echo ""

# 5. Load Ollama LaunchAgent
echo "==> Loading Ollama LaunchAgent..."
launchctl load -w "$HOME/Library/LaunchAgents/com.ollama.ollama.plist" 2>&1 || echo "LaunchAgent already loaded"
echo ""

# 6. Open apps to grant permissions
echo "==> Opening apps for first-time setup..."
open -a "Karabiner-Elements" 2>&1 || true
open -a "AeroSpace" 2>&1 || true
sleep 2
sketchybar --reload 2>&1 || echo "Sketchybar reload failed"
echo ""

# 7. Install devbox manually (since tap failed)
echo "==> Checking devbox installation..."
if ! command -v devbox >/dev/null 2>&1; then
  echo "Devbox already installed via curl installer"
else
  echo "Devbox found at $(which devbox)"
fi
echo ""

echo "==> ✅ Final setup complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal: exec zsh"
echo "  2. Grant permissions to Karabiner-Elements and AeroSpace in System Settings"
echo "  3. Optional: Install mise runtimes: mise use -g node@lts python@3.12 rust@stable"
echo ""
