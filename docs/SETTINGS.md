# Configuration Settings Guide

## Overview
This setup is built around the **Catppuccin Mocha** theme, a warm dark theme that's applied consistently across all tools for a unified visual experience.

## Shell Configuration

### Zsh (~/.zshrc)
**Key Features:**
- **Vi mode**: `bindkey -v` enables vim-like editing in the command line
- **Smart navigation**: zoxide learns your most-used directories
- **History**: Atuin provides searchable, synced shell history
- **Completion**: Carapace provides intelligent completions

**Environment Variables:**
```bash
EDITOR=vim          # Default editor for git commits, etc.
VISUAL=vim          # Visual editor
FZF_DEFAULT_COMMAND # Uses fd with smart defaults
```

**Aliases:**
- `ls` → `eza -lah --group-directories-first --icons` (colorful, informative ls)
- `cat` → `bat` (syntax-highlighted cat)
- `grep` → `rg` (faster ripgrep)

### Starship Prompt (~/.config/starship.toml)
**Catppuccin Mocha Theme** with custom elements:
- Git status (branch, changes, stash)
- Current directory (truncated intelligently)
- Language versions (Node, Python, Rust, Go, etc.)
- Command duration for slow commands
- Username/hostname (only when needed)
- Error status (shows exit code if non-zero)

**Colors:**
- Base: #1e1e2e (background)
- Text: #cdd6f4
- Accents: #89b4fa (blue), #f38ba8 (red), #a6e3a1 (green)

## Terminal Emulators

### Ghostty (~/.config/ghostty/config)
**Settings:**
- Font: JetBrainsMono Nerd Font, size 13
- Theme: Catppuccin Mocha
- Window padding: 10px
- Cursor style: Block with blink
- Shell integration: Enabled

**Features:**
- GPU-accelerated rendering
- Native macOS integration
- Fast startup time

### Tmux (~/.tmux.conf)
**Configuration:**
- Prefix: `Ctrl+Space` (instead of default Ctrl+B)
- Mouse support enabled
- Vi mode for copy mode
- Catppuccin Mocha theme (via plugin)
- True color support

**Plugins** (via tpm):
- tmux-resurrect: Save/restore tmux sessions
- tmux-continuum: Auto-save sessions
- catppuccin/tmux: Theme

**Key Bindings:**
- `Prefix + |` : Split vertically
- `Prefix + -` : Split horizontally
- `Prefix + h/j/k/l` : Navigate panes (vim-style)

## Desktop Environment

### AeroSpace (~/.config/aerospace/aerospace.toml)
**Tiling Window Manager** inspired by i3/sway

**Key Bindings:**
- `Alt + h/j/k/l` : Focus window (vim navigation)
- `Alt + Shift + h/j/k/l` : Move window
- `Alt + 1-9` : Switch to workspace
- `Alt + Shift + 1-9` : Move window to workspace
- `Alt + Enter` : Open Ghostty terminal
- `Alt + b` : Horizontal layout
- `Alt + /` : Vertical layout
- `Alt + ,` : Accordion layout
- `Alt + f` : Toggle fullscreen
- `Alt + Space` : Enter apps mode

**Apps Mode** (Alt + Space):
- `w` : WezTerm
- `t` : Ghostty
- `c` : VSCode
- `s` : Safari
- `o` : Obsidian
- `r` : Raycast
- `m` : Maccy
- `q` : Exit apps mode

**Gaps:**
- Inner: 8px (horizontal and vertical)
- Outer: 8px (top, bottom, left), 24px (right)

**Features:**
- All workspaces assigned to primary monitor
- Auto-start on login
- Integrates with Sketchybar for workspace display

### Karabiner-Elements (~/.config/karabiner/karabiner.json)
**Keyboard Remapping**

**Complex Modifications:**
1. **Caps Lock → Hyper Key**
   - Hold: Acts as Cmd+Ctrl+Opt+Shift (⌘⌃⌥⇧)
   - Tap: Escape
   - Use case: Powerful modifier for custom shortcuts

2. **Hyper + 1-9 → AeroSpace Workspaces**
   - Hyper+1 : Workspace 1
   - Hyper+2 : Workspace 2
   - ... and so on

**Why Hyper Key?**
The Hyper key is unused in macOS, making it perfect for custom global shortcuts without conflicts.

### Sketchybar (~/.config/sketchybar/)
**Status Bar** for macOS (replaces default menu bar)

**Modules:**
- Date/Time
- Battery
- WiFi status
- AeroSpace workspace indicator
- System stats (CPU, memory)

**Theme:** Catppuccin Mocha
**Position:** Top of screen
**Auto-hide:** No (always visible)

### Borders
**Window Border Highlighter**
- Highlights active window with colored border
- Color: Catppuccin Blue (#89b4fa)
- Width: 5px
- Helps identify focused window in tiling layout

## Editors

### Neovim (~/.config/nvim/)
**Distribution:** AstroNvim v4
**Theme:** Catppuccin Mocha

**User Configuration** (`lua/user/init.lua`):
```lua
{
  colorscheme = "catppuccin",
  plugins = {
    {"catppuccin/nvim", name="catppuccin", priority=1000},
    {"epwalsh/obsidian.nvim", version="*"}
  },
  options = {
    opt = {
      number = true,
      relativenumber = true
    }
  }
}
```

**Features:**
- LSP support for all languages
- Tree-sitter syntax highlighting
- Telescope fuzzy finder
- Neo-tree file explorer
- Git integration (gitsigns)
- Obsidian note integration

**Key Bindings** (AstroNvim defaults):
- Leader: Space
- `Space + f + f` : Find files
- `Space + f + g` : Live grep
- `Space + e` : Toggle file explorer
- `Space + g + g` : LazyGit

### Visual Studio Code
**Theme:** Catppuccin Mocha
**Icon Theme:** Material Icon Theme
**Font:** JetBrainsMono Nerd Font, 14px

**Settings:**
```json
{
  "editor.fontFamily": "JetBrainsMono Nerd Font",
  "editor.fontSize": 14,
  "editor.lineHeight": 1.6,
  "editor.cursorBlinking": "smooth",
  "editor.cursorSmoothCaretAnimation": "on",
  "workbench.colorTheme": "Catppuccin Mocha",
  "workbench.iconTheme": "material-icon-theme",
  "vim.useSystemClipboard": true
}
```

**Extensions:**
- **Vim**: Vim emulation
- **Python**: Python language support
- **Rust**: rust-analyzer
- **Go**: Go language support
- **Docker**: Dockerfile and Compose support
- **Terraform**: HCL syntax and validation
- **GitLens**: Git supercharged
- **GitHub PR**: Pull request integration

**Vim Mode:**
- Enabled by default
- System clipboard integration
- Visual block mode supported

## Development Tools

### Git (~/.gitconfig)
**User:**
```ini
[user]
    name = Peter Campbell Clarke
    email = peter@holonic.bio
```

**Core Settings:**
```ini
[core]
    editor = vim
    pager = delta
    autocrlf = input
```

**Delta (diff viewer):**
- Syntax highlighting for diffs
- Side-by-side view
- Line numbers
- Theme: Catppuccin Mocha

**Aliases:**
```ini
[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    lg = log --graph --oneline --decorate --all
```

### Mise
**Runtime Manager** configuration in `~/.config/mise/config.toml`

**Global Tools:**
```toml
[tools]
node = "lts"
python = "3.12"
rust = "stable"
bun = "latest"
```

**Features:**
- Automatic version switching per directory
- Fast installation and switching
- Compatible with .tool-versions files
- Replaces asdf, nvm, pyenv, etc.

## Database Configuration

### PostgreSQL 16
**Service:** Auto-starts via brew services
**Port:** 5432
**User:** Current macOS user
**Database:** Same as username (auto-created)

**Connection:**
```bash
psql                    # Connect to default DB
pgcli                   # Alternative with better UX
```

### Redis
**Service:** Auto-starts via brew services
**Port:** 6379
**Configuration:** Default (no password)

**Connection:**
```bash
redis-cli
```

## Container & Kubernetes

### Colima
**Container Runtime** (Docker Desktop alternative)

**Start:**
```bash
colima start
# or
colima start --cpu 4 --memory 8  # Custom resources
```

**Features:**
- Docker and Kubernetes support
- Faster than Docker Desktop
- No licensing requirements

### Kubernetes Tools
**kubectl:** Kubernetes CLI
**k9s:** Terminal UI for Kubernetes clusters
**helm:** Package manager for Kubernetes
**kind/minikube:** Local cluster development

## Theme Details: Catppuccin Mocha

**Philosophy:** Warm, cozy dark theme that's easy on the eyes

**Color Palette:**
```
Rosewater: #f5e0dc
Flamingo:  #f2cdcd
Pink:      #f5c2e7
Mauve:     #cba6f7
Red:       #f38ba8
Maroon:    #eba0ac
Peach:     #fab387
Yellow:    #f9e2af
Green:     #a6e3a1
Teal:      #94e2d5
Sky:       #89dceb
Sapphire:  #74c7ec
Blue:      #89b4fa
Lavender:  #b4befe
Text:      #cdd6f4
Subtext1:  #bac2de
Subtext0:  #a6adc8
Overlay2:  #9399b2
Overlay1:  #7f849c
Overlay0:  #6c7086
Surface2:  #585b70
Surface1:  #45475a
Surface0:  #313244
Base:      #1e1e2e
Mantle:    #181825
Crust:     #11111b
```

**Applied To:**
- Starship prompt
- Tmux status bar
- Neovim (via plugin)
- VSCode (via extension)
- Ghostty terminal
- Git Delta
- Bat syntax highlighting
- Sketchybar

## macOS Settings

**Dock:**
- Auto-hide enabled (more screen space)
- Position: Bottom
- Size: Small-Medium
- Magnification: Disabled

**System Preferences Recommendations:**
1. **Accessibility → Display:**
   - Reduce transparency (better performance)

2. **Trackpad:**
   - Tap to click: Enabled
   - Three finger drag: Enabled (via Accessibility)

3. **Keyboard:**
   - Key repeat: Fast
   - Delay until repeat: Short

4. **Security:**
   - Grant accessibility permissions to:
     - Karabiner-Elements
     - AeroSpace
     - Raycast

## Keyboard Shortcuts Summary

**Global (Karabiner):**
- Caps Lock → Hyper/Escape
- Hyper + 1-9 → Workspaces

**AeroSpace:**
- Alt + hjkl → Navigate windows
- Alt + Shift + hjkl → Move windows
- Alt + 1-9 → Switch workspace
- Alt + Enter → Terminal
- Alt + Space → Apps mode

**Tmux:**
- Ctrl+Space → Prefix
- Prefix + | → Split vertical
- Prefix + - → Split horizontal

**Neovim:**
- Space → Leader
- Space + ff → Find files
- Space + gg → Git

**VSCode:**
- Cmd + P → Quick open
- Cmd + Shift + P → Command palette
- Vim bindings enabled

## Directory Structure

```
$HOME/
├── .config/
│   ├── aerospace/      # Window manager
│   ├── karabiner/      # Keyboard remapping
│   ├── sketchybar/     # Status bar
│   ├── ghostty/        # Terminal
│   ├── nvim/           # Neovim
│   ├── starship.toml   # Prompt
│   └── mise/           # Runtime manager
├── .local/bin/         # User binaries
├── .tmux/              # Tmux plugins
├── .zshrc              # Zsh configuration
├── .gitconfig          # Git configuration
└── dev/                # Development projects
```

## Performance Optimizations

1. **Zsh startup:** Fast due to lazy loading
2. **Homebrew:** Minimal analytics
3. **Docker:** Colima uses less resources than Docker Desktop
4. **Neovim:** Lazy-loaded plugins via AstroNvim
5. **macOS:** Reduced transparency and animations

## Maintenance

**Update everything:**
```bash
# Homebrew packages
brew update && brew upgrade

# Neovim plugins
nvim +AstroUpdate

# Mise runtimes
mise upgrade

# Tmux plugins
~/.tmux/plugins/tpm/bin/update_plugins all
```

**Cleanup:**
```bash
# Homebrew
brew cleanup

# Mise
mise cache clear

# Docker
docker system prune -a
```
