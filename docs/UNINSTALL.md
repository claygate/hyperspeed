# Hyperspeed Uninstall Guide

Complete guide for safely removing the Hyperspeed development environment from your macOS system.

## Table of Contents

1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Safety Features](#safety-features)
4. [What Gets Removed](#what-gets-removed)
5. [Usage Examples](#usage-examples)
6. [Selective Removal](#selective-removal)
7. [Manual Removal](#manual-removal)
8. [Troubleshooting](#troubleshooting)
9. [Recovery](#recovery)

## Overview

The uninstall script provides a safe, interactive way to remove Hyperspeed components from your system. It features:

- **Interactive prompts**: Choose what to remove
- **Dry-run mode**: Preview changes before executing
- **Automatic backups**: Saves configs before removal
- **Selective removal**: Keep what you want, remove what you don't
- **Safe defaults**: Protects critical files and directories

## Quick Start

### Preview What Would Be Removed (Recommended First Step)

```bash
cd ~/hyperspeed
./scripts/uninstall.sh
```

This runs in **dry-run mode by default** and shows you what would be removed without making any changes.

### Execute Uninstall

```bash
cd ~/hyperspeed
DRYRUN=0 ./scripts/uninstall.sh
```

The script will:
1. Ask for confirmation for each category
2. Create backups of all removed files
3. Remove selected components
4. Provide a summary of actions taken

### Complete Uninstall (Remove Everything)

```bash
cd ~/hyperspeed
DRYRUN=0 ./scripts/uninstall.sh
# Answer 'y' to all prompts
```

## Safety Features

### 1. Dry-Run Mode (Default)

By default, the script runs in **dry-run mode** which only shows what would happen:

```bash
# Safe preview (default)
./scripts/uninstall.sh

# Actually execute
DRYRUN=0 ./scripts/uninstall.sh
```

### 2. Automatic Backups

All files are backed up before removal to `~/hyperspeed_backup_YYYYMMDD_HHMMSS/`:

```bash
# With backups (default)
DRYRUN=0 ./scripts/uninstall.sh

# Skip backups (not recommended)
DRYRUN=0 BACKUP=0 ./scripts/uninstall.sh
```

### 3. Interactive Prompts

The script asks before removing each category:
- Configuration files
- Services
- GUI applications
- CLI tools
- Databases
- Directories

You can choose to keep certain components and remove others.

### 4. Protected Items

The script includes safeguards for:
- **Git config**: Extra confirmation required (contains your identity)
- **VSCode settings**: Separate prompt (may have personal customizations)
- **Neovim config**: Separate prompt (may have personal plugins)
- **~/dev directory**: Won't remove (may contain your projects)
- **Core system tools**: Won't remove git (system-critical)

## What Gets Removed

### Configuration Files

| File/Directory | Description | Backup? |
|----------------|-------------|---------|
| `~/.zshrc` | Shell configuration | ✅ |
| `~/.config/starship.toml` | Shell prompt config | ✅ |
| `~/.tmux.conf` | Tmux configuration | ✅ |
| `~/.config/ghostty/config` | Ghostty terminal config | ✅ |
| `~/.gitconfig` | Git configuration | ✅ (requires extra confirmation) |
| `~/.config/aerospace/` | Window manager config | ✅ |
| `~/.config/karabiner/` | Keyboard remapping config | ✅ |
| `~/.config/sketchybar/` | Status bar config | ✅ |
| `~/.config/borders/` | Window borders config | ✅ |
| `~/.config/nvim/` | Neovim/AstroNvim config | ✅ (requires extra confirmation) |
| `~/Library/Application Support/Code/User/settings.json` | VSCode settings | ✅ (requires extra confirmation) |

### Services

| Service | Description |
|---------|-------------|
| PostgreSQL@16 | Database server |
| Redis | Key-value store |
| Sketchybar | Status bar |
| Borders | Window highlighter |
| Ollama | LLM server (LaunchAgent) |
| AeroSpace Workspace Init | Auto-workspace setup (LaunchAgent) |

### GUI Applications (Homebrew Casks)

- Karabiner-Elements
- AeroSpace
- Visual Studio Code
- Ghostty
- WezTerm
- Raycast
- Maccy
- Obsidian
- Tailscale
- Ollama

### CLI Tools (Homebrew Formulae)

70+ tools including:
- Shell tools: starship, zoxide, fzf, ripgrep, fd, eza, bat
- Development: neovim, mise, direnv, just
- Version control: gh, lazygit, git-delta, tig
- Containers: docker, docker-compose, colima, lima
- Kubernetes: kubectl, helm, k9s, kind, minikube
- Databases: postgresql@16, pgcli, redis, sqlite, litecli
- And many more (see full list in install.sh)

**Note**: Git is intentionally NOT removed as it's system-critical.

### Additional Components

- tmux plugin manager and plugins
- pipx packages (llm, pre-commit)
- JetBrains Mono Nerd Font
- Homebrew taps (nikitabobko/tap, FelixKratz/formulae, etc.)

### Database Data

- PostgreSQL databases
- Redis data files

**Warning**: These prompts default to 'N' to prevent accidental data loss.

### Directories

- `~/.config/{zsh,nvim,tmux,starship,karabiner,sketchybar,ghostty,aerospace,borders}` (if empty)
- `~/.local/bin` (requires confirmation)
- `~/.tmux` (tmux plugins)

**Not Removed**: `~/dev` (may contain your projects - manual removal only)

## Usage Examples

### Example 1: Remove Everything Except VSCode

```bash
DRYRUN=0 ./scripts/uninstall.sh
# Answer 'y' to most prompts
# Answer 'n' when asked about VSCode settings and VSCode cask
```

### Example 2: Keep Configs, Remove Apps

```bash
DRYRUN=0 ./scripts/uninstall.sh
# Answer 'n' to "Remove configuration files?"
# Answer 'y' to GUI applications and CLI tools
```

### Example 3: Preview Then Execute

```bash
# First: Preview what will happen
./scripts/uninstall.sh

# Review output, then execute
DRYRUN=0 ./scripts/uninstall.sh
```

### Example 4: Clean Slate (Remove Everything)

```bash
cd ~/hyperspeed

# Preview first
./scripts/uninstall.sh

# Execute removal
DRYRUN=0 ./scripts/uninstall.sh
# Answer 'y' to all prompts including database data

# Cleanup homebrew cache
brew cleanup

# Remove the hyperspeed directory itself
cd ~
rm -rf ~/hyperspeed
```

### Example 5: Remove Without Backups (Not Recommended)

```bash
# Only if you're absolutely certain
DRYRUN=0 BACKUP=0 ./scripts/uninstall.sh
```

## Selective Removal

### Remove Only Configuration Files

```bash
DRYRUN=0 ./scripts/uninstall.sh
# Answer 'y' to "Remove configuration files?"
# Answer 'n' to all other prompts
```

### Remove Only GUI Applications

```bash
DRYRUN=0 ./scripts/uninstall.sh
# Answer 'n' to first few prompts
# Answer 'y' to "Remove Homebrew GUI applications?"
# Answer 'n' to remaining prompts
```

### Remove Only Services

```bash
DRYRUN=0 ./scripts/uninstall.sh
# Answer 'n' to configuration files
# Answer 'y' to "Stop and remove services?"
# Answer 'n' to remaining prompts
```

## Manual Removal

If you prefer manual removal or need to clean up specific components:

### Remove Configuration Files

```bash
# Backup first
mkdir -p ~/hyperspeed_manual_backup
cp ~/.zshrc ~/.tmux.conf ~/.gitconfig ~/hyperspeed_manual_backup/
cp -R ~/.config/aerospace ~/hyperspeed_manual_backup/

# Remove
rm ~/.zshrc ~/.tmux.conf
rm -rf ~/.config/{aerospace,karabiner,sketchybar,ghostty,borders}
```

### Remove Services

```bash
# Stop services
brew services stop postgresql@16
brew services stop redis
brew services stop sketchybar
brew services stop borders

# Remove LaunchAgents
launchctl unload ~/Library/LaunchAgents/com.ollama.ollama.plist
rm ~/Library/LaunchAgents/com.ollama.ollama.plist
```

### Remove Homebrew Packages

```bash
# List installed packages
brew list

# Remove specific packages
brew uninstall package-name

# Remove GUI apps
brew uninstall --cask app-name

# Clean up
brew cleanup
```

### Remove Databases

```bash
# PostgreSQL
rm -rf /opt/homebrew/var/postgresql@16

# Redis
rm -rf /opt/homebrew/var/db/redis
```

### Remove Additional Tools

```bash
# tmux plugins
rm -rf ~/.tmux

# Neovim
rm -rf ~/.config/nvim

# pipx packages
pipx list
pipx uninstall package-name
```

## Troubleshooting

### "Permission denied" Errors

Some operations require sudo (like stopping system services):

```bash
# Run with appropriate permissions
sudo brew services stop service-name
```

### Services Won't Stop

```bash
# Check running services
brew services list

# Force stop
launchctl unload -w ~/Library/LaunchAgents/service-name.plist

# Check for running processes
ps aux | grep service-name
killall service-name
```

### Can't Remove Homebrew Package

```bash
# Check dependencies
brew uses --installed package-name

# Force removal (be careful)
brew uninstall --force package-name

# Remove dependencies
brew autoremove
```

### Backup Directory Too Large

Backups are stored in `~/hyperspeed_backup_YYYYMMDD_HHMMSS/`.

```bash
# Check backup size
du -sh ~/hyperspeed_backup_*

# Remove old backups
rm -rf ~/hyperspeed_backup_20250101_*

# Skip backups (not recommended)
DRYRUN=0 BACKUP=0 ./scripts/uninstall.sh
```

### Script Hangs or Freezes

```bash
# Press Ctrl+C to cancel
# Check what's running
ps aux | grep uninstall

# Kill if necessary
killall -9 bash
```

### Database Data Remains After Removal

```bash
# PostgreSQL
rm -rf /opt/homebrew/var/postgresql@16

# Redis
rm -rf /opt/homebrew/var/db/redis

# Check for database processes
ps aux | grep postgres
ps aux | grep redis
```

## Recovery

### Restore From Backup

Backups are saved to `~/hyperspeed_backup_YYYYMMDD_HHMMSS/`.

```bash
# List backups
ls -la ~/hyperspeed_backup_*

# Restore specific file
cp ~/hyperspeed_backup_20250115_120000/.zshrc ~/.zshrc

# Restore entire directory
cp -R ~/hyperspeed_backup_20250115_120000/.config/aerospace ~/.config/
```

### Reinstall Hyperspeed

```bash
cd ~/hyperspeed
./scripts/install.sh
```

Or clone fresh:

```bash
git clone https://github.com/thruxnet/hyperspeed.git ~/hyperspeed
cd ~/hyperspeed
./scripts/install.sh
```

### Restore Individual Components

#### Restore Configuration Files

```bash
# From backup
cp ~/hyperspeed_backup_YYYYMMDD_HHMMSS/.zshrc ~/

# Or from repo
cd ~/hyperspeed
cp configs/shell/zshrc ~/.zshrc
```

#### Reinstall Homebrew Packages

```bash
# Single package
brew install package-name

# GUI app
brew install --cask app-name

# From Brewfile (if available)
brew bundle --file=~/hyperspeed/Brewfile
```

#### Restart Services

```bash
brew services start postgresql@16
brew services start redis
brew services start sketchybar
brew services start borders
```

### Recover Database Data

If you have PostgreSQL/Redis backups:

```bash
# PostgreSQL
pg_restore -d database_name backup_file

# Redis
redis-cli
> CONFIG SET dir /path/to/backup
> CONFIG SET dbfilename dump.rdb
> SAVE
```

## Verification

After uninstall, verify removal:

```bash
# Check services
brew services list

# Check installed apps
brew list
brew list --cask

# Check configuration files
ls -la ~/.config/
ls -la ~/ | grep -E "zshrc|tmux|gitconfig"

# Check LaunchAgents
ls -la ~/Library/LaunchAgents/

# Check running processes
ps aux | grep -E "postgres|redis|ollama|sketchybar|borders"
```

## Notes

### What Stays

The uninstall script does NOT remove:

1. **Homebrew itself** - You may want this for other packages
2. **Xcode Command Line Tools** - System dependency
3. **Git** - System-critical version control
4. **Your projects in ~/dev** - Your work is safe
5. **System macOS settings** - Only Dock autohide is restored

### Clean Slate Removal

To completely remove everything including Homebrew:

```bash
# 1. Run uninstall script
cd ~/hyperspeed
DRYRUN=0 ./scripts/uninstall.sh
# Answer 'y' to all prompts

# 2. Remove Homebrew (optional)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

# 3. Remove residual directories
rm -rf ~/.config
rm -rf ~/.local
rm -rf ~/.cache

# 4. Remove hyperspeed repo
cd ~
rm -rf ~/hyperspeed
```

### Partial Reinstall

You can reinstall individual components without running the full install script:

```bash
# Install single package
brew install package-name

# Copy single config
cp ~/hyperspeed/configs/shell/zshrc ~/.zshrc

# Start single service
brew services start service-name
```

## Getting Help

If you encounter issues:

1. **Check the backup**: `ls -la ~/hyperspeed_backup_*`
2. **Review troubleshooting section** above
3. **Run in dry-run mode**: `./scripts/uninstall.sh` to preview
4. **Check service status**: `brew services list`
5. **Verify processes**: `ps aux | grep service-name`

## Resources

- [Main README](../README.md) - Overview of Hyperspeed
- [Installation Guide](../scripts/install.sh) - Reinstall if needed
- [Package List](PACKAGES.md) - What was installed
- [Homebrew Docs](https://docs.brew.sh/) - Package management
- [GitHub Issues](https://github.com/thruxnet/hyperspeed/issues) - Report problems

---

**Created**: 2025-01-15
**Author**: Peter Campbell Clarke
**License**: MIT
