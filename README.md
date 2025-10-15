# Hyperspeed

A constantly developed opinionated development environment for macOS with focus on keyboard-driven workflows, modern CLI tools, and the Catppuccin Mocha theme.

Made with ❤️ by [Thrux](https://thrux.net)

## Philosophy

This setup prioritizes:
- **Keyboard-first workflows**: Minimal mouse usage with vim-style keybindings
- **Visual consistency**: Catppuccin Mocha theme across all applications
- **Modern tools**: Fast, ergonomic CLI tools that enhance productivity
- **Reproducibility**: Everything is scripted and documented
- **Minimal friction**: Sensible defaults that "just work"

## What You Get

### Core Experience
- **Tiling Window Manager**: AeroSpace for efficient window management
- **Smart Shell**: Zsh with starship prompt, zoxide, fzf, and atuin
- **Terminal Emulators**: Ghostty and WezTerm with consistent theming
- **Editors**: Neovim (AstroNvim) and VSCode, both with vim keybindings
- **Keyboard Magic**: Karabiner-Elements transforms Caps Lock into a Hyper key

### Development Tools
- **Version Control**: Git with delta, lazygit, and GitHub CLI
- **Languages**: Mise for managing Node, Python, Rust, Bun, and more
- **Containers**: Colima, Docker, and Kubernetes tools
- **Databases**: PostgreSQL 16, Redis, SQLite
- **HTTP Clients**: httpie and xh for API testing

### Productivity Apps
- **Raycast**: Spotlight replacement with powerful extensions
- **Maccy**: Clipboard manager
- **Obsidian**: Knowledge management
- **Sketchybar**: Beautiful status bar
- **Ollama**: Run LLMs locally

## Quick Start

### Prerequisites
1. macOS (tested on Apple Silicon)
2. Xcode Command Line Tools: `xcode-select --install`
3. Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

### Installation

```bash
# Clone this repository
git clone https://github.com/thruxnet/hyperspeed.git ~/hyperspeed
cd ~/hyperspeed

# Run the installation script
chmod +x scripts/install.sh
./scripts/install.sh
```

The script will:
1. Install Rosetta (Apple Silicon Macs)
2. Install 70+ CLI tools via Homebrew
3. Install GUI applications
4. Copy configuration files
5. Set up services (PostgreSQL, Redis, etc.)
6. Install editor extensions
7. Configure macOS settings

**Installation time**: ~20-30 minutes depending on your internet connection.

### Post-Installation

```bash
# 1. Restart your shell
exec zsh

# 2. Install runtime versions
mise use -g node@lts
mise use -g python@3.12
mise use -g rust@stable
mise use -g bun@latest

# 3. Grant permissions in System Settings
# Go to: System Settings → Privacy & Security
# Allow: Karabiner-Elements, AeroSpace, Raycast

# 4. Open apps for first-time setup
open -a "Karabiner-Elements"
open -a "AeroSpace"
open -a "Raycast"

# 5. Configure Git (if not already done)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Directory Structure

```
mac_dev_setup/
├── README.md                    # This file
├── scripts/
│   ├── install.sh               # Master installation script
│   └── mac_dev_final_setup.sh   # Additional setup tasks
├── configs/
│   ├── shell/
│   │   ├── zshrc                # Zsh configuration
│   │   ├── starship.toml        # Prompt configuration
│   │   ├── tmux.conf            # Tmux configuration
│   │   └── ghostty_config       # Ghostty terminal config
│   ├── editor/
│   │   ├── nvim_init.lua        # Neovim user config
│   │   └── vscode_settings.json # VSCode settings
│   ├── desktop/
│   │   ├── aerospace.toml       # Window manager config
│   │   └── karabiner.json       # Keyboard remapping
│   └── development/
│       └── gitconfig            # Git configuration
└── docs/
    ├── PACKAGES.md              # Complete package list with descriptions
    └── SETTINGS.md              # Detailed configuration guide
```

## Key Features & Keybindings

### Window Management (AeroSpace)
```
Alt + h/j/k/l           Navigate windows (vim-style)
Alt + Shift + h/j/k/l   Move windows
Alt + 1-9               Switch to workspace 1-9
Alt + Shift + 1-9       Move window to workspace 1-9
Alt + Enter             Open terminal
Alt + f                 Toggle fullscreen
Alt + Space             Enter apps mode
```

**Apps Mode** (after Alt + Space):
```
w    WezTerm
t    Ghostty
c    VSCode
s    Safari
o    Obsidian
r    Raycast
m    Maccy
q    Exit apps mode
```

### Keyboard Customization (Karabiner)
```
Caps Lock (hold)        Hyper key (⌘⌃⌥⇧)
Caps Lock (tap)         Escape
Hyper + 1-9             Switch to workspace 1-9
```

### Shell Enhancements
```bash
# Smart directory navigation
z <partial-name>        # Jump to directory (zoxide)
Ctrl+R                  # Search command history (atuin)
Ctrl+T                  # Fuzzy find files (fzf)

# Modern replacements
ls                      # Actually runs: eza -lah --icons
cat file.txt            # Actually runs: bat file.txt
grep pattern            # Actually runs: rg pattern

# Quick actions
mise use node@20        # Switch Node version for project
pipx install <tool>     # Install Python CLI tool globally
```

### Terminal Multiplexer (Tmux)
```
Ctrl+Space              Prefix (instead of Ctrl+B)
Prefix + |              Split vertically
Prefix + -              Split horizontally
Prefix + h/j/k/l        Navigate panes (vim-style)
Prefix + [              Enter copy mode (use vim keys)
```

### Editors

**Neovim (AstroNvim)**:
```
Space                   Leader key
Space + f + f           Find files
Space + f + g           Live grep
Space + e               Toggle file tree
Space + g + g           LazyGit
Space + /               Toggle comment
```

**VSCode** (with Vim extension):
- All standard Vim keybindings work
- System clipboard integration enabled
- Leader key: Space (configurable)

## Theme: Catppuccin Mocha

A warm, cozy dark theme applied consistently across:
- Terminal (Ghostty, WezTerm)
- Shell prompt (Starship)
- Editors (Neovim, VSCode)
- Multiplexer (Tmux)
- CLI tools (bat, delta, fzf)
- Status bar (Sketchybar)

**Main Colors**:
- Background: #1e1e2e
- Foreground: #cdd6f4
- Blue: #89b4fa
- Red: #f38ba8
- Green: #a6e3a1
- Yellow: #f9e2af

## Installed Packages

### CLI Tools (70+)
Version control, shell enhancements, data processing, system utilities, HTTP clients, and more.

**Highlights**:
- `git`, `gh`, `lazygit`, `git-delta` - Git workflow
- `ripgrep`, `fd`, `fzf` - Fast searching
- `eza`, `bat`, `zoxide` - Modern core utils
- `mise` - Runtime version management
- `docker`, `k9s`, `kubectl` - Container orchestration

**See [PACKAGES.md](docs/PACKAGES.md) for the complete list.**

### GUI Applications
- **Editors**: Visual Studio Code
- **Terminals**: Ghostty, WezTerm
- **Desktop**: AeroSpace, Karabiner-Elements, Sketchybar, Borders
- **Productivity**: Raycast, Maccy, Obsidian
- **Development**: Tailscale, Ollama
- **Fonts**: JetBrains Mono Nerd Font

### Services (Auto-started)
- PostgreSQL 16 (port 5432)
- Redis (port 6379)
- Sketchybar (status bar)
- Borders (window highlighter)
- Ollama (LLM server)

## Configuration Details

All configurations are stored in `~/.config/` following the XDG Base Directory specification where possible.

**Key Configuration Files**:
- `~/.zshrc` - Shell initialization
- `~/.config/starship.toml` - Shell prompt
- `~/.tmux.conf` - Terminal multiplexer
- `~/.config/aerospace/aerospace.toml` - Window manager
- `~/.config/karabiner/karabiner.json` - Keyboard remapping
- `~/.config/nvim/` - Neovim with AstroNvim
- `~/.config/mise/config.toml` - Runtime versions
- `~/.gitconfig` - Git settings with delta pager

**See [SETTINGS.md](docs/SETTINGS.md) for detailed configuration explanations.**

## Common Tasks

### Update Everything
```bash
# Update Homebrew packages
brew update && brew upgrade && brew cleanup

# Update Neovim plugins
nvim +AstroUpdate

# Update runtime versions
mise upgrade

# Update tmux plugins
~/.tmux/plugins/tpm/bin/update_plugins all

# Update pipx packages
pipx upgrade-all
```

### Development Workflows

**Python Project**:
```bash
cd myproject
mise use python@3.12      # Set Python version
uv venv                   # Create virtual environment
source .venv/bin/activate
uv pip install -r requirements.txt
```

**Node.js Project**:
```bash
cd myproject
mise use node@lts         # Set Node version
npm install
npm run dev
```

**Kubernetes**:
```bash
k9s                       # Launch K9s dashboard
kubectl get pods
helm list
```

### Database Access
```bash
# PostgreSQL
psql                      # Connect to default DB
pgcli                     # Better CLI with autocomplete

# Redis
redis-cli

# SQLite
sqlite3 database.db
litecli database.db       # Better CLI
```

## Troubleshooting

### Karabiner Not Working
1. Grant Accessibility permissions: System Settings → Privacy & Security → Accessibility
2. Add Karabiner-Elements and karabiner_grabber
3. Restart Karabiner

### AeroSpace Not Tiling
1. Grant Accessibility permissions for AeroSpace
2. Check if app is in floating mode: `aerospace list-windows`
3. Restart AeroSpace: `brew services restart aerospace`

### Zsh Slow Startup
```bash
# Profile startup time
time zsh -i -c exit

# Check what's slow
zsh -xv 2>&1 | ts -i '%.s'
```

### Mise Runtime Install Fails
```bash
# Clear cache and retry
mise cache clear
mise install python@3.12
```

### PostgreSQL Won't Start
```bash
# Check logs
brew services info postgresql@16

# Restart service
brew services restart postgresql@16

# Check if port is in use
lsof -i :5432
```

## Customization

### Change Theme
To switch from Catppuccin Mocha to another theme:

1. **Starship**: Edit `~/.config/starship.toml`, change palette
2. **Neovim**: Edit `~/.config/nvim/lua/user/init.lua`, change colorscheme
3. **VSCode**: Open Settings, search "Color Theme"
4. **Ghostty**: Edit `~/.config/ghostty/config`, change theme
5. **Tmux**: Edit `~/.tmux.conf`, change plugin settings

### Modify Keybindings

**AeroSpace**: Edit `~/.config/aerospace/aerospace.toml`
```toml
[mode.main.binding]
alt-h = "focus left"  # Change 'alt' to 'cmd' or other modifier
```

**Karabiner**: Use Karabiner-Elements GUI for complex modifications

**Tmux**: Edit `~/.tmux.conf`
```bash
set -g prefix C-a     # Change prefix to Ctrl+A
unbind C-Space
```

### Add New Tools
```bash
# Install via Homebrew
brew install <package>

# Or via mise for language-specific tools
mise use go@latest

# Or via pipx for Python tools
pipx install <python-tool>
```

## Backup & Restoration

### Backup Current Setup
```bash
# Create backup directory
mkdir -p ~/backups/mac_dev_$(date +%Y%m%d)

# Copy all configs
cp -r ~/.config ~/backups/mac_dev_$(date +%Y%m%d)/
cp ~/.zshrc ~/.tmux.conf ~/.gitconfig ~/backups/mac_dev_$(date +%Y%m%d)/

# Export Homebrew packages
brew bundle dump --file=~/backups/mac_dev_$(date +%Y%m%d)/Brewfile
```

### Restore on New Machine
```bash
# Clone this repo
git clone <repo-url> ~/mac_dev_setup
cd ~/mac_dev_setup

# Run installation
./scripts/install.sh

# Restore any personal customizations from backup
cp ~/backups/mac_dev_<date>/.zshrc ~/.zshrc  # if customized
```

## Philosophy & Design Decisions

### Why These Tools?

**Tiling Window Manager**: AeroSpace provides i3-like tiling without the complexity of yabai+SKHD and works without disabling SIP.

**Shell Tools**: Modern Rust-based tools (ripgrep, fd, eza, bat) are significantly faster than traditional Unix tools while providing better UX.

**Mise over asdf**: Mise is faster, has better performance, and is written in Rust. It's compatible with asdf's `.tool-versions`.

**Catppuccin Theme**: Provides excellent contrast while being easy on the eyes. The Mocha variant is warm and cozy for long coding sessions.

**Vim Keybindings**: Consistent muscle memory across all tools (shell, tmux, editors, window manager) reduces cognitive load.

**Homebrew Only**: Using Homebrew for package management (instead of mix of Homebrew, pkg installers, and manual installs) ensures updates and cleanup are unified.

### Trade-offs

**Opinionated**: This setup makes specific choices (theme, keybindings, tools). Customization is possible but requires understanding the configs.

**Learning Curve**: Keyboard-driven workflows require initial learning but pay off with increased productivity.

**macOS Specific**: Designed for macOS and won't work on Linux/Windows (though many configs are portable).

**Resource Usage**: Running multiple services (PostgreSQL, Redis, Ollama) uses system resources. Disable unused services with `brew services stop <service>`.

## Contributing

Found a better way to configure something? Have a suggestion?

1. Test your changes thoroughly
2. Update relevant documentation
3. Ensure compatibility with the existing setup
4. Submit a pull request with clear explanation

## Resources & Learning

### Official Documentation
- [Homebrew](https://docs.brew.sh/)
- [AeroSpace](https://github.com/nikitabobko/AeroSpace)
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/docs/)
- [AstroNvim](https://docs.astronvim.com/)
- [Mise](https://mise.jdx.dev/)
- [Starship](https://starship.rs/)

### Learning Resources
- [The Art of Command Line](https://github.com/jlevy/the-art-of-command-line)
- [Modern Unix Tools](https://github.com/ibraheemdev/modern-unix)
- [Vim Adventures](https://vim-adventures.com/) - Learn vim keys through a game
- [tmux Cheatsheet](https://tmuxcheatsheet.com/)

### Community
- [r/unixporn](https://reddit.com/r/unixporn) - Rice inspiration
- [r/commandline](https://reddit.com/r/commandline) - CLI tools and tips
- [Catppuccin Discord](https://discord.gg/catppuccin) - Theme support

## Credits

**Theme**: [Catppuccin](https://github.com/catppuccin/catppuccin)
**Window Manager**: [AeroSpace](https://github.com/nikitabobko/AeroSpace) by @nikitabobko
**Status Bar**: [Sketchybar](https://github.com/FelixKratz/SketchyBar) by @FelixKratz
**Neovim**: [AstroNvim](https://github.com/AstroNvim/AstroNvim)
**Shell Prompt**: [Starship](https://github.com/starship/starship)

## License

This configuration is MIT licensed. Feel free to use, modify, and share.

**Note**: Individual tools and applications have their own licenses. Check each project's repository for details.

---

**Enjoy your new development environment!** 🚀

For questions or issues, consult the [SETTINGS.md](docs/SETTINGS.md) documentation or check the troubleshooting section.
