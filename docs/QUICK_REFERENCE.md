# Quick Reference Guide

## Essential Keybindings

### Window Management (AeroSpace)
| Key | Action |
|-----|--------|
| `Alt + h/j/k/l` | Navigate windows (vim-style) |
| `Alt + Shift + h/j/k/l` | Move windows |
| `Alt + 1-9` | Switch to workspace 1-9 |
| `Alt + Shift + 1-9` | Move window to workspace 1-9 |
| `Alt + Enter` | Open terminal (Ghostty) |
| `Alt + b` | Horizontal layout |
| `Alt + /` | Vertical layout |
| `Alt + ,` | Accordion layout |
| `Alt + f` | Toggle fullscreen |
| `Alt + Space` | Enter apps mode |
| `Alt + x` | Trigger sketchybar update |

### Apps Mode (after Alt + Space)
| Key | Action |
|-----|--------|
| `w` | Open WezTerm |
| `t` | Open Ghostty |
| `c` | Open VSCode |
| `s` | Open Safari |
| `o` | Open Obsidian |
| `r` | Open Raycast |
| `m` | Open Maccy |
| `q` | Exit apps mode (back to main) |

### Keyboard Customization (Karabiner)
| Key | Action |
|-----|--------|
| `Caps Lock` (hold) | Hyper key (⌘⌃⌥⇧) |
| `Caps Lock` (tap) | Escape |
| `Hyper + 1-9` | Switch to workspace 1-9 |

### Tmux
| Key | Action |
|-----|--------|
| `Ctrl + Space` | Prefix |
| `Prefix + \|` | Split vertically |
| `Prefix + -` | Split horizontally |
| `Prefix + h/j/k/l` | Navigate panes |
| `Prefix + [` | Enter copy mode |
| `Prefix + d` | Detach session |
| `Prefix + c` | Create window |
| `Prefix + n/p` | Next/previous window |
| `Prefix + &` | Kill window |
| `Prefix + x` | Kill pane |

### Neovim (AstroNvim)
| Key | Action |
|-----|--------|
| `Space` | Leader key |
| `Space + f + f` | Find files (Telescope) |
| `Space + f + g` | Live grep (search in files) |
| `Space + f + w` | Find word under cursor |
| `Space + f + o` | Find old files (recent) |
| `Space + e` | Toggle file explorer (Neo-tree) |
| `Space + g + g` | Open LazyGit |
| `Space + g + s` | Git status |
| `Space + /` | Toggle comment |
| `Space + l + f` | Format document |
| `Space + l + a` | Code action |
| `Space + l + r` | Rename symbol |
| `g + d` | Go to definition |
| `g + r` | Go to references |
| `K` | Hover documentation |
| `Ctrl + o` | Jump back |
| `Ctrl + i` | Jump forward |

## Common CLI Commands

### Navigation & Search
```bash
# Smart directory jump (learns your habits)
z <partial-name>

# Fuzzy find files
Ctrl+T                    # In terminal
fd <pattern>              # Direct search

# Search in files
rg <pattern>              # Basic search
rg <pattern> -A 2 -B 2    # With context lines
rg <pattern> --type py    # Filter by file type

# Better ls
ls                        # Uses eza with icons and colors
eza -T                    # Tree view
eza -l --git              # With git status
```

### File Operations
```bash
# View files with syntax highlighting
bat <file>
bat <file> --line-range 10:20

# Compare files
delta file1 file2

# Find files
fd <name>                 # Fast find
fd <name> --type f        # Files only
fd <name> --type d        # Directories only
```

### System Information
```bash
# Disk usage
duf                       # Modern df alternative

# Process list
procs                     # Modern ps alternative
procs <name>              # Filter by name
```

### Git Workflows
```bash
# LazyGit (terminal UI)
lazygit

# Quick git commands
git st                    # Status (aliased)
git lg                    # Pretty log graph
git co <branch>           # Checkout
git br                    # List branches

# GitHub CLI
gh pr list                # List PRs
gh pr create              # Create PR
gh pr view <number>       # View PR
gh issue list             # List issues
gh repo view              # View repo
```

### Runtime Management (Mise)
```bash
# List available versions
mise ls-remote node
mise ls-remote python

# Install and use versions
mise use node@lts         # Use in current project
mise use -g python@3.12   # Use globally
mise use rust@stable

# List installed versions
mise ls

# Update tool versions
mise upgrade
```

### Package Management
```bash
# Homebrew
brew update               # Update package list
brew upgrade              # Upgrade packages
brew search <package>     # Search for package
brew info <package>       # Package info
brew cleanup              # Remove old versions

# Python (pipx for CLI tools)
pipx install <package>    # Install isolated tool
pipx list                 # List installed tools
pipx upgrade-all          # Update all tools

# Python (uv for projects)
uv venv                   # Create venv
uv pip install <package>  # Fast install
```

### Container & Kubernetes
```bash
# Colima (Docker runtime)
colima start              # Start Docker
colima stop               # Stop Docker
colima status             # Check status

# Docker
docker ps                 # List containers
docker images             # List images
docker compose up -d      # Start services

# Kubernetes
k9s                       # Launch terminal UI
kubectl get pods          # List pods
kubectl logs <pod>        # View logs
helm list                 # List helm releases
```

### Database Access
```bash
# PostgreSQL
psql                      # Connect to default DB
psql -d dbname            # Connect to specific DB
pgcli                     # Better interface

# Redis
redis-cli                 # Connect to Redis

# SQLite
sqlite3 <db>              # Basic client
litecli <db>              # Better interface
```

### HTTP Requests
```bash
# httpie (human-friendly)
http GET https://api.example.com/users
http POST https://api.example.com/users name=John

# xh (fast alternative)
xh GET https://api.example.com/users
xh :3000/api/users        # Shorthand for localhost
```

## Shell Shortcuts

### History & Command Line
| Key | Action |
|-----|--------|
| `Ctrl + R` | Search history (atuin) |
| `Ctrl + T` | Fuzzy find files (fzf) |
| `Ctrl + A` | Go to beginning of line |
| `Ctrl + E` | Go to end of line |
| `Ctrl + W` | Delete word backward |
| `Ctrl + U` | Delete to beginning of line |
| `Ctrl + K` | Delete to end of line |
| `Ctrl + L` | Clear screen |

### Vi Mode (in zsh)
| Key | Action |
|-----|--------|
| `Esc` or `Ctrl + [` | Enter normal mode |
| `i` | Insert mode |
| `A` | Insert at end of line |
| `I` | Insert at beginning of line |
| `h/j/k/l` | Navigate (normal mode) |
| `w/b` | Word forward/backward |
| `0/$` | Beginning/end of line |
| `/` | Search in line |

## Quick Setup Commands

### First-Time Setup
```bash
# Clone setup repository
git clone <repo-url> ~/mac_dev_setup
cd ~/mac_dev_setup

# Run installation
chmod +x scripts/install.sh
./scripts/install.sh

# Restart shell
exec zsh

# Install runtimes
mise use -g node@lts python@3.12 rust@stable bun@latest
```

### Daily Maintenance
```bash
# Update everything
brew update && brew upgrade && brew cleanup
mise upgrade
pipx upgrade-all
```

### Development Workflow
```bash
# Start new project
mkdir myproject && cd myproject

# Set runtime versions
mise use python@3.12      # or node@lts, rust@stable, etc.

# Initialize git
git init
gh repo create            # Create GitHub repo

# Start coding
code .                    # VSCode
nvim .                    # Neovim
```

## Configuration File Locations

| Tool | Location |
|------|----------|
| Zsh | `~/.zshrc` |
| Starship | `~/.config/starship.toml` |
| Tmux | `~/.tmux.conf` |
| Neovim | `~/.config/nvim/` |
| VSCode | `~/Library/Application Support/Code/User/settings.json` |
| AeroSpace | `~/.config/aerospace/aerospace.toml` |
| Karabiner | `~/.config/karabiner/karabiner.json` |
| Ghostty | `~/.config/ghostty/config` |
| Git | `~/.gitconfig` |
| Mise | `~/.config/mise/config.toml` |
| Sketchybar | `~/.config/sketchybar/` |

## Troubleshooting Quick Fixes

### Service Management
```bash
# Restart services
brew services restart postgresql@16
brew services restart redis
brew services restart sketchybar
brew services restart borders

# Check service status
brew services list

# Stop service
brew services stop <service>
```

### Clear Caches
```bash
# Homebrew cache
brew cleanup -s

# Mise cache
mise cache clear

# Docker
docker system prune -a
```

### Reset Configurations
```bash
# Backup current config
cp ~/.zshrc ~/.zshrc.backup

# Restore from this repo
cd ~/mac_dev_setup
cp configs/shell/zshrc ~/.zshrc
```

## Performance Tips

```bash
# Check zsh startup time
time zsh -i -c exit

# Profile zsh startup (detailed)
zsh -xv 2>&1 | ts -i '%.s'

# Check which services are running
brew services list

# Monitor system resources
htop                      # If installed
procs --tree              # Process tree
```

## Useful Aliases (Included)

```bash
ls='eza -lah --group-directories-first --icons'
cat='bat'
grep='rg'

# You can add more to ~/.zshrc
alias gst='git status'
alias gco='git checkout'
alias gp='git push'
alias gl='git pull'
alias k='kubectl'
```

## Learning Resources

- **Vim Tutorial**: Run `vimtutor` in terminal
- **Tmux**: `Prefix + ?` shows all keybindings
- **AeroSpace**: `aerospace list-windows` to see current state
- **Mise**: `mise --help` for comprehensive help
- **Git**: `gh --help` for GitHub CLI help

## Emergency Commands

```bash
# Kill frozen app
pkill -9 <app-name>

# Restart window manager
brew services restart aerospace

# Restart status bar
sketchybar --reload

# Reset Karabiner
launchctl stop org.pqrs.karabiner.karabiner_console_user_server
launchctl start org.pqrs.karabiner.karabiner_console_user_server

# Force quit everything and log out
osascript -e 'tell application "System Events" to log out'
```

---

**Tip**: Print this guide or keep it handy while you learn the new keybindings. Muscle memory develops in about 2 weeks of consistent use.
