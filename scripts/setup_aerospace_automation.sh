#!/usr/bin/env bash
# Setup AeroSpace workspace automation
# This script installs the enhanced AeroSpace configuration and workspace scripts

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${YELLOW}→${NC} $1"; }

echo "=========================================="
echo "AeroSpace Automation Setup"
echo "=========================================="
echo ""

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")/configs"

# Create AeroSpace config directory
print_info "Creating AeroSpace directories..."
mkdir -p "$HOME/.config/aerospace"
mkdir -p "$HOME/.config/aerospace/scripts"
print_success "Directories created"

# Backup existing config if it exists
if [ -f "$HOME/.config/aerospace/aerospace.toml" ]; then
    print_info "Backing up existing AeroSpace config..."
    cp "$HOME/.config/aerospace/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml.backup.$(date +%Y%m%d_%H%M%S)"
    print_success "Backup created"
fi

# Install enhanced AeroSpace configuration
print_info "Installing enhanced AeroSpace configuration..."
if [ -f "$CONFIG_DIR/desktop/aerospace_enhanced.toml" ]; then
    cp "$CONFIG_DIR/desktop/aerospace_enhanced.toml" "$HOME/.config/aerospace/aerospace.toml"
    print_success "Enhanced config installed"
else
    print_error "Enhanced config not found at $CONFIG_DIR/desktop/aerospace_enhanced.toml"
    exit 1
fi

# Install workspace initialization scripts
print_info "Installing workspace initialization scripts..."
if [ -d "$CONFIG_DIR/desktop/aerospace_scripts" ]; then
    cp -r "$CONFIG_DIR/desktop/aerospace_scripts/"* "$HOME/.config/aerospace/scripts/"
    chmod +x "$HOME/.config/aerospace/scripts/"*.sh
    print_success "Workspace scripts installed and made executable"
else
    print_error "Scripts directory not found at $CONFIG_DIR/desktop/aerospace_scripts"
    exit 1
fi

# Install JankyBorders if not already installed
print_info "Checking for JankyBorders (window highlighting)..."
if ! command -v borders >/dev/null 2>&1; then
    print_info "Installing JankyBorders..."
    brew tap FelixKratz/formulae 2>/dev/null || true
    brew install borders 2>/dev/null || print_error "Failed to install borders"
fi

if command -v borders >/dev/null 2>&1; then
    print_success "JankyBorders available"

    # Start borders service
    brew services start borders 2>/dev/null || print_info "Borders service already running"
fi

# Restart AeroSpace to apply new configuration
print_info "Restarting AeroSpace..."
brew services restart aerospace 2>/dev/null || {
    print_info "AeroSpace service not running, starting..."
    brew services start aerospace
}
print_success "AeroSpace restarted"

# Create optional LaunchAgent for automatic workspace initialization
print_info "Creating optional LaunchAgent for workspace initialization..."
cat > "$HOME/Library/LaunchAgents/com.aerospace.workspace-init.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.aerospace.workspace-init</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>-c</string>
    <string>sleep 15 && $HOME/.config/aerospace/scripts/init_all_workspaces.sh</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>/tmp/aerospace-init.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/aerospace-init.err</string>
</dict>
</plist>
EOF
print_success "LaunchAgent created (not loaded by default)"

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Your AeroSpace setup now includes:"
echo "  • Enhanced configuration with automation support"
echo "  • 7 pre-configured workspace layouts"
echo "  • Workspace initialization scripts"
echo "  • Window focus highlighting (borders)"
echo ""
echo "Usage:"
echo "  Alt+i then 1-7  : Initialize specific workspace"
echo "  Alt+i then a    : Initialize all workspaces"
echo "  Alt+i then r    : Reset current workspace"
echo "  Alt+1 to Alt+8  : Switch to workspace"
echo ""
echo "Manual initialization:"
echo "  ~/.config/aerospace/scripts/init_all_workspaces.sh"
echo ""
echo "Enable automatic initialization at login (optional):"
echo "  launchctl load -w ~/Library/LaunchAgents/com.aerospace.workspace-init.plist"
echo ""
echo "View workspace layouts:"
echo "  cat ~/.config/aerospace/scripts/README.md"
echo ""
print_success "Enjoy your automated workspace environment!"
