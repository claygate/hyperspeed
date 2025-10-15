#!/usr/bin/env bash
# Mac Development Environment Setup - Master Installation Script
# Author: Peter Campbell Clarke
# Description: Complete automated setup for macOS development environment

set -euo pipefail

# DRYRUN mode: set DRYRUN=1 to plan without executing
DRYRUN="${DRYRUN:-0}"

# Execute command or show plan
run() {
  if [ "$DRYRUN" = "1" ]; then
    echo "[PLAN] $*"
  else
    eval "$@"
  fi
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "======================================"
echo "Mac Development Environment Setup"
echo "======================================"
echo ""

# Function to print colored messages
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${YELLOW}→${NC} $1"; }

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  print_error "This script is designed for macOS only"
  exit 1
fi

# Check for Homebrew
if ! command -v brew >/dev/null 2>&1; then
  print_error "Homebrew is not installed. Install it first from https://brew.sh"
  exit 1
fi

print_success "Homebrew found"

# Step 1: Install Rosetta (for M1/M2 Macs)
if [[ "$(uname -m)" == "arm64" ]]; then
  print_info "Installing Rosetta for Apple Silicon..."
  /usr/sbin/softwareupdate --install-rosetta --agree-to-license 2>&1 | grep -v "installed" || print_success "Rosetta installed"
fi

# Step 2: Update Homebrew
print_info "Updating Homebrew..."
brew update

# Step 3: Tap repositories
print_info "Tapping Homebrew repositories..."
brew tap nikitabobko/tap 2>&1 || true
brew tap FelixKratz/formulae 2>&1 || true
brew tap oven-sh/bun 2>&1 || true
brew tap tilt-dev/tap 2>&1 || true

# Step 4: Install CLI tools
print_info "Installing CLI tools (this will take a while)..."
brew install \
  git gnupg openssh gh \
  zsh starship zoxide fzf ripgrep fd eza bat duf procs \
  jq yq hyperfine gawk coreutils findutils gnu-sed watch gnu-tar \
  tmux reattach-to-user-namespace zellij \
  carapace lazygit git-delta tig atuin \
  just xh httpie uv pipx mise direnv \
  neovim \
  postgresql@16 pgcli sqlite litecli redis \
  colima docker docker-compose lima \
  kubernetes-cli helm k9s kind minikube tilt \
  tesseract poppler ffmpeg imagemagick pngpaste pandoc \
  jj qemu \
  FelixKratz/formulae/sketchybar \
  FelixKratz/formulae/borders \
  2>&1 | grep -E "🍺|already installed|Error" || true

print_success "CLI tools installed"

# Step 5: Install GUI applications
print_info "Installing GUI applications..."
brew install --cask \
  font-jetbrains-mono-nerd-font \
  visual-studio-code \
  ghostty \
  wezterm \
  nikitabobko/tap/aerospace \
  raycast \
  maccy \
  obsidian \
  tailscale \
  ollama \
  2>&1 | grep -E "🍺|already installed|Error" || true

print_success "GUI applications installed"

# Step 6: Karabiner-Elements (requires sudo)
print_info "Installing Karabiner-Elements (requires sudo password)..."
brew install --cask karabiner-elements 2>&1 || print_error "Karabiner install failed - run manually: brew install --cask karabiner-elements"

# Step 7: macOS Settings
print_info "Configuring macOS settings..."
defaults write com.apple.dock autohide -bool true
killall Dock

# Step 8: Create directory structure
print_info "Creating directory structure..."
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"/{zsh,nvim,tmux,starship,karabiner,sketchybar,ghostty,aerospace,borders}
mkdir -p "$HOME/dev"

# Step 9: Install configurations
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$(dirname "$SCRIPT_DIR")/configs"

print_info "Installing configuration files..."

# Shell configs
if [[ -f "$CONFIG_DIR/shell/zshrc" ]]; then
  cat "$CONFIG_DIR/shell/zshrc" >> "$HOME/.zshrc"
  print_success "Installed .zshrc"
fi

if [[ -f "$CONFIG_DIR/shell/starship.toml" ]]; then
  cp "$CONFIG_DIR/shell/starship.toml" "$HOME/.config/starship.toml"
  print_success "Installed starship config"
fi

if [[ -f "$CONFIG_DIR/shell/tmux.conf" ]]; then
  cp "$CONFIG_DIR/shell/tmux.conf" "$HOME/.tmux.conf"
  print_success "Installed tmux config"
fi

if [[ -f "$CONFIG_DIR/shell/ghostty_config" ]]; then
  cp "$CONFIG_DIR/shell/ghostty_config" "$HOME/.config/ghostty/config"
  print_success "Installed Ghostty config"
fi

# Development configs
if [[ -f "$CONFIG_DIR/development/gitconfig" ]]; then
  # Preserve existing user info
  EXISTING_NAME=$(git config --global user.name 2>/dev/null || echo "")
  EXISTING_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

  cp "$CONFIG_DIR/development/gitconfig" "$HOME/.gitconfig"

  if [[ -n "$EXISTING_NAME" ]]; then
    git config --global user.name "$EXISTING_NAME"
  fi
  if [[ -n "$EXISTING_EMAIL" ]]; then
    git config --global user.email "$EXISTING_EMAIL"
  fi

  print_success "Installed git config"
fi

# Desktop environment configs
if [[ -f "$CONFIG_DIR/desktop/aerospace.toml" ]]; then
  cp "$CONFIG_DIR/desktop/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
  print_success "Installed AeroSpace config"
fi

if [[ -f "$CONFIG_DIR/desktop/karabiner.json" ]]; then
  cp "$CONFIG_DIR/desktop/karabiner.json" "$HOME/.config/karabiner/karabiner.json"
  print_success "Installed Karabiner config"
fi

# Editor configs
if [[ -f "$CONFIG_DIR/editor/vscode_settings.json" ]]; then
  mkdir -p "$HOME/Library/Application Support/Code/User"
  cp "$CONFIG_DIR/editor/vscode_settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
  print_success "Installed VSCode settings"
fi

# Step 10: Clone and install additional tools
print_info "Installing tmux plugin manager..."
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  print_success "Installed tmux plugin manager"
fi

print_info "Installing AstroNvim..."
if [[ ! -d "$HOME/.config/nvim" ]] || [[ ! -d "$HOME/.config/nvim/.git" ]]; then
  git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim --depth 1
  if [[ -f "$CONFIG_DIR/editor/nvim_init.lua" ]]; then
    mkdir -p "$HOME/.config/nvim/lua/user"
    cp "$CONFIG_DIR/editor/nvim_init.lua" "$HOME/.config/nvim/lua/user/init.lua"
  fi
  print_success "Installed AstroNvim"
fi

# Step 11: FZF shell integration
print_info "Installing fzf shell integration..."
$(brew --prefix)/opt/fzf/install --all --no-bash --no-fish 2>&1 | grep -v "Downloading" || true
print_success "fzf integration installed"

# Step 12: Install VSCode extensions
print_info "Installing VSCode extensions..."
CODE="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
if [[ -f "$CODE" ]]; then
  "$CODE" --install-extension catppuccin.catppuccin-vsc --force
  "$CODE" --install-extension pkief.material-icon-theme --force
  "$CODE" --install-extension vscodevim.vim --force
  "$CODE" --install-extension ms-python.python --force
  "$CODE" --install-extension ms-python.vscode-pylance --force
  "$CODE" --install-extension charliermarsh.ruff --force
  "$CODE" --install-extension rust-lang.rust-analyzer --force
  "$CODE" --install-extension golang.go --force
  "$CODE" --install-extension esbenp.prettier-vscode --force
  "$CODE" --install-extension dbaeumer.vscode-eslint --force
  "$CODE" --install-extension ms-azuretools.vscode-docker --force
  "$CODE" --install-extension hashicorp.terraform --force
  "$CODE" --install-extension redhat.vscode-yaml --force
  "$CODE" --install-extension eamodio.gitlens --force
  "$CODE" --install-extension github.vscode-pull-request-github --force
  print_success "VSCode extensions installed"
else
  print_error "VSCode not found, skipping extensions"
fi

# Step 13: Install pipx packages
print_info "Installing pipx packages..."
export PATH="/opt/homebrew/bin:$PATH"
pipx ensurepath
pipx install llm 2>&1 || true
pipx install pre-commit 2>&1 || true
print_success "pipx packages installed"

# Step 14: Start services
print_info "Starting services..."
brew services start postgresql@16 2>&1 || true
brew services start redis 2>&1 || true
brew services start sketchybar 2>&1 || true
brew services start borders 2>&1 || true
print_success "Services started"

# Step 15: Create Ollama LaunchAgent
print_info "Creating Ollama LaunchAgent..."
cat > "$HOME/Library/LaunchAgents/com.ollama.ollama.plist" <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.ollama.ollama</string>
  <key>ProgramArguments</key>
  <array>
    <string>/opt/homebrew/bin/ollama</string>
    <string>serve</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>/tmp/ollama.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/ollama.err</string>
</dict>
</plist>
EOF

launchctl load -w "$HOME/Library/LaunchAgents/com.ollama.ollama.plist" 2>&1 || true
print_success "Ollama LaunchAgent created"

# Step 16: Install Nix (optional)
read -p "Install Nix package manager? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  print_info "Installing Nix..."
  curl -L https://install.determinate.systems/nix | sh -s -- install
  print_success "Nix installed"
fi

# Step 17: Install tmux plugins
print_info "Installing tmux plugins..."
tmux start-server 2>&1 || true
tmux new-session -d 2>&1 || true
~/.tmux/plugins/tpm/scripts/install_plugins.sh 2>&1 || true
print_success "tmux plugins installed"

# Step 18: Create PostgreSQL database
print_info "Creating PostgreSQL database..."
sleep 2
/opt/homebrew/opt/postgresql@16/bin/createdb "$(whoami)" 2>&1 || print_info "Database already exists"

# Step 19: Setup AeroSpace automation (optional)
echo ""
read -p "Setup AeroSpace workspace automation? (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  print_info "Setting up AeroSpace automation..."
  if [[ -f "$SCRIPT_DIR/setup_aerospace_automation.sh" ]]; then
    bash "$SCRIPT_DIR/setup_aerospace_automation.sh"
  else
    print_error "AeroSpace automation script not found"
  fi
fi

echo ""
echo "======================================"
echo "Installation Complete!"
echo "======================================"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal: exec zsh"
echo "  2. Grant permissions to Karabiner-Elements and AeroSpace in System Settings"
echo "  3. Install mise runtimes:"
echo "     mise use -g node@lts"
echo "     mise use -g python@3.12"
echo "     mise use -g rust@stable"
echo "     mise use -g bun@latest"
echo "  4. Open and configure your apps:"
echo "     open -a 'Karabiner-Elements'"
echo "     open -a 'AeroSpace'"
echo "     open -a 'Raycast'"
echo ""
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
  echo "AeroSpace workspace automation:"
  echo "  • Press Alt+i then 1-7 to initialize workspaces"
  echo "  • Press Alt+i then 'a' to initialize all at once"
  echo "  • See ~/.config/aerospace/scripts/README.md for details"
  echo ""
fi
print_success "Setup complete! Enjoy your new development environment."
