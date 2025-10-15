#!/usr/bin/env bash
# Hyperspeed Development Environment - Uninstall Script
# Author: Peter Campbell Clarke
# Description: Interactive removal of development environment components

set -euo pipefail

# DRYRUN mode: set DRYRUN=0 to execute (defaults to safe plan-only)
DRYRUN="${DRYRUN:-1}"

# Backup mode: set BACKUP=0 to skip backups
BACKUP="${BACKUP:-1}"

# Backup directory
BACKUP_DIR="$HOME/hyperspeed_backup_$(date +%Y%m%d_%H%M%S)"

# Execute command or show plan
run() {
  if [ "$DRYRUN" = "1" ]; then
    echo "[PLAN] $*"
  else
    # shellcheck disable=SC2294
    eval "$@"
  fi
}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "======================================"
echo "Hyperspeed Uninstall Script"
echo "======================================"
echo ""

# Function to print colored messages
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${YELLOW}→${NC} $1"; }
print_warn() { echo -e "${BLUE}!${NC} $1"; }

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  print_error "This script is designed for macOS only"
  exit 1
fi

if [ "$DRYRUN" = "1" ]; then
  echo ""
  echo "=========================================="
  echo "RUNNING IN DRYRUN MODE (safe preview)"
  echo "Set DRYRUN=0 to execute removal"
  echo "=========================================="
  echo ""
fi

# Function to ask yes/no questions
ask() {
  local prompt="$1"
  local default="${2:-N}"

  if [ "$DRYRUN" = "1" ]; then
    echo "[PLAN] Would ask: $prompt"
    return 0  # Always return yes in dry-run
  fi

  if [ "$default" = "Y" ]; then
    read -p "$prompt (Y/n): " -n 1 -r
  else
    read -p "$prompt (y/N): " -n 1 -r
  fi
  echo

  if [ -z "$REPLY" ]; then
    [[ "$default" = "Y" ]]
  else
    [[ $REPLY =~ ^[Yy]$ ]]
  fi
}

# Backup function
backup_file() {
  local file="$1"
  if [ "$BACKUP" = "1" ] && [ -f "$file" ]; then
    local backup_path
    backup_path="$BACKUP_DIR/$(dirname "$file")"
    run "mkdir -p '$backup_path'"
    run "cp -p '$file' '$backup_path/$(basename "$file")'"
    print_info "Backed up: $file"
  fi
}

backup_dir() {
  local dir="$1"
  if [ "$BACKUP" = "1" ] && [ -d "$dir" ]; then
    local backup_path
    backup_path="$BACKUP_DIR/$(dirname "$dir")"
    run "mkdir -p '$backup_path'"
    run "cp -Rp '$dir' '$backup_path/'"
    print_info "Backed up: $dir"
  fi
}

# Create backup directory
if [ "$BACKUP" = "1" ]; then
  run "mkdir -p '$BACKUP_DIR'"
  print_info "Backups will be saved to: $BACKUP_DIR"
  echo ""
fi

# ===== CONFIGURATION FILES =====
if ask "Remove configuration files?"; then
  print_info "Removing configuration files..."

  # Shell configs
  if [ -f "$HOME/.zshrc" ]; then
    backup_file "$HOME/.zshrc"
    run "rm '$HOME/.zshrc'"
  fi

  if [ -f "$HOME/.config/starship.toml" ]; then
    backup_file "$HOME/.config/starship.toml"
    run "rm '$HOME/.config/starship.toml'"
  fi

  if [ -f "$HOME/.tmux.conf" ]; then
    backup_file "$HOME/.tmux.conf"
    run "rm '$HOME/.tmux.conf'"
  fi

  if [ -f "$HOME/.config/ghostty/config" ]; then
    backup_file "$HOME/.config/ghostty/config"
    run "rm '$HOME/.config/ghostty/config'"
  fi

  # Development configs
  if [ -f "$HOME/.gitconfig" ]; then
    backup_file "$HOME/.gitconfig"
    if ask "  Remove .gitconfig? (WARNING: Contains your git identity)" "N"; then
      run "rm '$HOME/.gitconfig'"
    fi
  fi

  # Desktop environment configs
  if [ -d "$HOME/.config/aerospace" ]; then
    backup_dir "$HOME/.config/aerospace"
    run "rm -rf '$HOME/.config/aerospace'"
  fi

  if [ -d "$HOME/.config/karabiner" ]; then
    backup_dir "$HOME/.config/karabiner"
    run "rm -rf '$HOME/.config/karabiner'"
  fi

  if [ -d "$HOME/.config/sketchybar" ]; then
    backup_dir "$HOME/.config/sketchybar"
    run "rm -rf '$HOME/.config/sketchybar'"
  fi

  if [ -d "$HOME/.config/borders" ]; then
    backup_dir "$HOME/.config/borders"
    run "rm -rf '$HOME/.config/borders'"
  fi

  # Editor configs
  if [ -f "$HOME/Library/Application Support/Code/User/settings.json" ]; then
    backup_file "$HOME/Library/Application Support/Code/User/settings.json"
    if ask "  Remove VSCode settings?" "N"; then
      run "rm '$HOME/Library/Application Support/Code/User/settings.json'"
    fi
  fi

  if [ -d "$HOME/.config/nvim" ]; then
    backup_dir "$HOME/.config/nvim"
    if ask "  Remove Neovim config (AstroNvim)?" "N"; then
      run "rm -rf '$HOME/.config/nvim'"
    fi
  fi

  print_success "Configuration files processed"
  echo ""
fi

# ===== SERVICES =====
if ask "Stop and remove services?"; then
  print_info "Stopping services..."

  # Homebrew services
  run "brew services stop postgresql@16 2>&1 || true"
  run "brew services stop redis 2>&1 || true"
  run "brew services stop sketchybar 2>&1 || true"
  run "brew services stop borders 2>&1 || true"

  # Ollama LaunchAgent
  if [ -f "$HOME/Library/LaunchAgents/com.ollama.ollama.plist" ]; then
    backup_file "$HOME/Library/LaunchAgents/com.ollama.ollama.plist"
    run "launchctl unload '$HOME/Library/LaunchAgents/com.ollama.ollama.plist' 2>&1 || true"
    run "rm '$HOME/Library/LaunchAgents/com.ollama.ollama.plist'"
  fi

  # AeroSpace workspace automation LaunchAgent
  if [ -f "$HOME/Library/LaunchAgents/com.aerospace.workspace-init.plist" ]; then
    backup_file "$HOME/Library/LaunchAgents/com.aerospace.workspace-init.plist"
    run "launchctl unload '$HOME/Library/LaunchAgents/com.aerospace.workspace-init.plist' 2>&1 || true"
    run "rm '$HOME/Library/LaunchAgents/com.aerospace.workspace-init.plist'"
  fi

  print_success "Services stopped"
  echo ""
fi

# ===== HOMEBREW GUI APPLICATIONS =====
if ask "Remove Homebrew GUI applications (casks)?"; then
  print_info "Removing GUI applications..."

  CASKS=(
    "karabiner-elements"
    "nikitabobko/tap/aerospace"
    "visual-studio-code"
    "ghostty"
    "wezterm"
    "raycast"
    "maccy"
    "obsidian"
    "tailscale"
    "ollama"
  )

  for cask in "${CASKS[@]}"; do
    if brew list --cask "$cask" &>/dev/null; then
      run "brew uninstall --cask '$cask' 2>&1 || true"
    fi
  done

  print_success "GUI applications removed"
  echo ""
fi

# ===== HOMEBREW CLI TOOLS =====
if ask "Remove Homebrew CLI tools?"; then
  print_info "Removing CLI tools..."

  print_warn "Note: This will NOT remove git, as it may be system-critical"

  CLI_TOOLS=(
    "gnupg" "openssh" "gh"
    "starship" "zoxide" "fzf" "ripgrep" "fd" "eza" "bat" "duf" "procs"
    "jq" "yq" "hyperfine" "gawk" "coreutils" "findutils" "gnu-sed" "watch" "gnu-tar"
    "tmux" "reattach-to-user-namespace" "zellij"
    "carapace" "lazygit" "git-delta" "tig" "atuin"
    "just" "xh" "httpie" "uv" "pipx" "mise" "direnv"
    "neovim"
    "postgresql@16" "pgcli" "sqlite" "litecli" "redis"
    "colima" "docker" "docker-compose" "lima"
    "kubernetes-cli" "helm" "k9s" "kind" "minikube" "tilt"
    "tesseract" "poppler" "ffmpeg" "imagemagick" "pngpaste" "pandoc"
    "jj" "qemu"
    "FelixKratz/formulae/sketchybar"
    "FelixKratz/formulae/borders"
  )

  for tool in "${CLI_TOOLS[@]}"; do
    if brew list "$tool" &>/dev/null 2>&1; then
      run "brew uninstall '$tool' 2>&1 || true"
    fi
  done

  print_success "CLI tools removed"
  echo ""
fi

# ===== FONTS =====
if ask "Remove JetBrains Mono Nerd Font?"; then
  run "brew uninstall --cask font-jetbrains-mono-nerd-font 2>&1 || true"
  print_success "Font removed"
  echo ""
fi

# ===== ADDITIONAL TOOLS =====
if ask "Remove additional installed tools (tmux plugins, pipx packages)?"; then
  print_info "Removing additional tools..."

  # tmux plugin manager
  if [ -d "$HOME/.tmux" ]; then
    backup_dir "$HOME/.tmux"
    run "rm -rf '$HOME/.tmux'"
  fi

  # pipx packages
  if command -v pipx >/dev/null 2>&1; then
    run "pipx uninstall llm 2>&1 || true"
    run "pipx uninstall pre-commit 2>&1 || true"
  fi

  print_success "Additional tools removed"
  echo ""
fi

# ===== DATABASES =====
if ask "Remove PostgreSQL and Redis data? (WARNING: Deletes all databases)" "N"; then
  print_info "Removing database data..."

  if [ -d "/opt/homebrew/var/postgresql@16" ]; then
    backup_dir "/opt/homebrew/var/postgresql@16"
    run "rm -rf '/opt/homebrew/var/postgresql@16'"
  fi

  if [ -f "/opt/homebrew/var/db/redis/dump.rdb" ]; then
    backup_file "/opt/homebrew/var/db/redis/dump.rdb"
    run "rm -rf '/opt/homebrew/var/db/redis'"
  fi

  print_success "Database data removed"
  echo ""
fi

# ===== DIRECTORIES =====
if ask "Remove development directories (~/.config, ~/.local/bin)?"; then
  print_info "Removing directories..."

  # Only remove empty config directories
  for dir in "$HOME/.config"/{zsh,nvim,tmux,starship,karabiner,sketchybar,ghostty,aerospace,borders}; do
    if [ -d "$dir" ] && [ -z "$(ls -A "$dir")" ]; then
      run "rmdir '$dir' 2>&1 || true"
    fi
  done

  if ask "  Remove ~/.local/bin? (May contain other tools)" "N"; then
    backup_dir "$HOME/.local/bin"
    run "rm -rf '$HOME/.local/bin'"
  fi

  if ask "  Remove ~/dev directory? (WARNING: May contain your projects)" "N"; then
    print_error "Skipping ~/dev - please remove manually if desired"
  fi

  print_success "Directories processed"
  echo ""
fi

# ===== HOMEBREW TAPS =====
if ask "Remove Homebrew taps?"; then
  print_info "Removing Homebrew taps..."

  run "brew untap nikitabobko/tap 2>&1 || true"
  run "brew untap FelixKratz/formulae 2>&1 || true"
  run "brew untap oven-sh/bun 2>&1 || true"
  run "brew untap tilt-dev/tap 2>&1 || true"

  print_success "Homebrew taps removed"
  echo ""
fi

# ===== MACOS SETTINGS =====
if ask "Restore macOS Dock settings (disable autohide)?"; then
  print_info "Restoring macOS settings..."

  run "defaults write com.apple.dock autohide -bool false"
  run "killall Dock"

  print_success "macOS settings restored"
  echo ""
fi

# ===== NIX =====
if command -v nix >/dev/null 2>&1; then
  if ask "Remove Nix package manager? (requires sudo)" "N"; then
    print_info "Removing Nix..."
    print_warn "This requires sudo and may take a few minutes"

    if [ "$DRYRUN" = "0" ]; then
      # Determinate Systems Nix installer provides uninstall
      if command -v nix-installer >/dev/null 2>&1; then
        nix-installer uninstall
      else
        print_error "nix-installer not found. Manual uninstall required:"
        print_info "  See: https://github.com/DeterminateSystems/nix-installer#uninstalling"
      fi
    else
      echo "[PLAN] Would run: nix-installer uninstall"
    fi

    print_success "Nix removal initiated"
    echo ""
  fi
fi

# ===== SUMMARY =====
echo ""
echo "======================================"
echo "Uninstall Complete!"
echo "======================================"
echo ""

if [ "$BACKUP" = "1" ]; then
  print_success "Backups saved to: $BACKUP_DIR"
  echo ""
fi

if [ "$DRYRUN" = "1" ]; then
  echo "This was a DRY RUN. No changes were made."
  echo "To execute removal, run: DRYRUN=0 ./scripts/uninstall.sh"
  echo ""
else
  print_info "Recommended next steps:"
  echo "  1. Restart your terminal"
  echo "  2. Run 'brew cleanup' to clean up cached downloads"
  echo "  3. Check System Settings → Login Items for any remaining agents"
  echo "  4. Review $BACKUP_DIR to recover any needed files"
  echo ""

  if ask "Run 'brew cleanup' now?"; then
    brew cleanup
    print_success "Homebrew cleaned up"
  fi
fi

print_success "Uninstall script completed successfully"
