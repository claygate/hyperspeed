# Enhancement Recommendations for Mac Dev Setup

Comprehensive suggestions to optimize and enhance your development environment based on research and best practices.

## Table of Contents
1. [Immediate Enhancements](#immediate-enhancements)
2. [macOS System Optimizations](#macos-system-optimizations)
3. [AeroSpace Advanced Features](#aerospace-advanced-features)
4. [Shell and Terminal Improvements](#shell-and-terminal-improvements)
5. [Development Workflow](#development-workflow)
6. [Productivity Tools](#productivity-tools)
7. [Future Considerations](#future-considerations)

---

## Immediate Enhancements

### 1. macOS Window Management Enhancements

Add these to your setup for smoother window management:

```bash
# Enable dragging windows from anywhere (hold Cmd+Ctrl and drag)
defaults write -g NSWindowShouldDragOnGesture -bool true

# Disable window opening animations (faster)
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# Faster key repeat (after reboot)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable press-and-hold for accented characters (enables fast repeat)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
```

**Add to**: `scripts/install.sh` in the macOS Settings section

### 2. Enhanced Tmux Session Management

Create a tmux session manager script:

```bash
# ~/.local/bin/tmux-sessionizer (inspired by ThePrimeagen)
#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
    selected=$1
else
    selected=$(find ~/dev ~/projects -mindepth 1 -maxdepth 1 -type d | fzf)
fi

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
    tmux new-session -s $selected_name -c $selected
    exit 0
fi

if ! tmux has-session -t=$selected_name 2> /dev/null; then
    tmux new-session -ds $selected_name -c $selected
fi

tmux switch-client -t $selected_name
```

**Benefits**:
- Quick project switching
- Automatic session naming
- Works from inside or outside tmux

**Add keybinding** to AeroSpace config:
```toml
alt-p = 'exec-and-forget open -na "Ghostty" && tmux-sessionizer'
```

### 3. Improved Gitconfig with Better Aliases

Enhance `configs/development/gitconfig`:

```ini
[alias]
    # Better log formats
    lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    lga = log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

    # Quick shortcuts
    s = status -sb
    co = checkout
    cob = checkout -b
    br = branch
    cm = commit -m
    ca = commit --amend
    unstage = reset HEAD --
    last = log -1 HEAD

    # Workflow helpers
    wip = commit -am "WIP"
    undo = reset --soft HEAD^
    amend = commit --amend --no-edit

    # Show changed files
    changed = diff --name-only HEAD

    # Interactive rebase
    ri = rebase -i
    rc = rebase --continue
```

### 4. Sketchybar Configuration

Create basic Sketchybar config with workspace indicators:

**Location**: `configs/desktop/sketchybar/sketchybarrc`

```bash
#!/bin/bash

# Bar appearance
sketchybar --bar height=32 \
                 blur_radius=30 \
                 position=top \
                 padding_left=10 \
                 padding_right=10 \
                 color=0xff1e1e2e

# Defaults
sketchybar --default icon.font="JetBrainsMono Nerd Font:Bold:14.0" \
                     icon.color=0xffcdd6f4 \
                     label.font="JetBrainsMono Nerd Font:Bold:14.0" \
                     label.color=0xffcdd6f4 \
                     padding_left=5 \
                     padding_right=5 \
                     label.padding_left=4 \
                     label.padding_right=4 \
                     icon.padding_left=4 \
                     icon.padding_right=4

# Aerospace workspace indicator
sketchybar --add event aerospace_workspace_change
sketchybar --add item workspace left \
           --set workspace icon.font="sketchybar-app-font:Regular:16.0" \
                          icon.color=0xff89b4fa \
                          icon.padding_left=10 \
                          icon.padding_right=15 \
                          label.color=0xffcdd6f4 \
                          label.padding_left=0 \
                          label.padding_right=10 \
                          script="~/.config/sketchybar/plugins/aerospace.sh" \
           --subscribe workspace aerospace_workspace_change

# Clock
sketchybar --add item clock right \
           --set clock update_freq=10 \
                       icon= \
                       script="~/.config/sketchybar/plugins/clock.sh"

# Battery
sketchybar --add item battery right \
           --set battery update_freq=60 \
                        icon.color=0xffa6e3a1 \
                        script="~/.config/sketchybar/plugins/battery.sh"

sketchybar --update
```

**Plugin**: `configs/desktop/sketchybar/plugins/aerospace.sh`

```bash
#!/bin/bash

WORKSPACE=$(aerospace list-workspaces --focused)
sketchybar --set $NAME label="Workspace $WORKSPACE"
```

### 5. Enhanced Zsh Configuration

Add to `configs/shell/zshrc`:

```bash
# Better history search
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Useful functions
take() {
    mkdir -p "$1" && cd "$1"
}

# Quick backup
backup() {
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.tar.xz) tar xf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Git project cloner with automatic cd
gcl() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

# Quick note-taking
note() {
    local note_dir="$HOME/notes"
    mkdir -p "$note_dir"
    local note_file="$note_dir/$(date +%Y-%m-%d).md"

    if [ $# -eq 0 ]; then
        ${EDITOR:-vim} "$note_file"
    else
        echo "$(date +%H:%M:%S) - $*" >> "$note_file"
    fi
}
```

---

## macOS System Optimizations

### 6. Power Management for Performance

```bash
# Prevent sleep when display is off (useful for long builds)
sudo pmset -c sleep 0

# Disable hard drive sleep
sudo pmset -a disksleep 0

# Set display sleep to 30 minutes
sudo pmset -a displaysleep 30

# Enable Power Nap
sudo pmset -a powernap 1
```

### 7. Security Enhancements

```bash
# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Disable creation of .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
```

### 8. Finder Improvements

```bash
# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Restart Finder to apply changes
killall Finder
```

---

## AeroSpace Advanced Features

### 9. Per-Monitor Gap Configuration

For multi-monitor setups, add to `aerospace.toml`:

```toml
[gaps]
outer.top = [
   { monitor."built-in" = 10 },
   { monitor."main" = 50 },
   50  # default
]
```

### 10. Advanced Window Detection Rules

```toml
# Automatically float certain apps
[[on-window-detected]]
if.app-id = 'com.apple.systempreferences'
run = 'layout floating'

[[on-window-detected]]
if.app-id = 'com.apple.finder'
if.window-title-regex-substring = 'Copy|Move'
run = 'layout floating'

# Specific workspace assignments
[[on-window-detected]]
if.app-id = 'com.figma.Desktop'
run = 'move-node-to-workspace 4'

[[on-window-detected]]
if.app-id = 'com.tinyspeck.slackmacgap'
run = 'move-node-to-workspace 9'

[[on-window-detected]]
if.app-id = 'com.spotify.client'
run = ['move-node-to-workspace 9', 'layout floating']
```

### 11. Custom Screenshot Workflow

Add to `aerospace.toml`:

```toml
# Screenshot shortcuts that work better with tiling
alt-shift-s = 'exec-and-forget screencapture -i -c'  # Interactive to clipboard
alt-shift-3 = 'exec-and-forget screencapture -c'     # Fullscreen to clipboard
alt-shift-4 = 'exec-and-forget screencapture -i ~/Desktop/screenshot-$(date +%Y%m%d-%H%M%S).png'
```

---

## Shell and Terminal Improvements

### 12. Advanced FZF Integration

Add to `.zshrc`:

```bash
# FZF configuration
export FZF_DEFAULT_OPTS="
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --height 40% --layout=reverse --border
"

# FZF Git integration
fgit() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" | fzf --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(echo {} | sed s/^..// | cut -d" " -f1) | head -200') &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# FZF process killer
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi
}
```

### 13. Tmux Enhanced Configuration

Add to `.tmux.conf`:

```bash
# Better colors
set -ga terminal-overrides ",xterm-256color:Tc"

# Start windows and panes at 1, not 0
set -g base-index 1
setw -g pane-base-index 1

# Renumber windows when one is closed
set -g renumber-windows on

# Increase scrollback buffer
set -g history-limit 50000

# Display messages for 4 seconds
set -g display-time 4000

# Refresh status more often
set -g status-interval 5

# Focus events for terminal vim
set -g focus-events on

# Super useful when using "grouped sessions"
setw -g aggressive-resize on

# Easier window splitting
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"

# Quick pane cycling
unbind ^A
bind ^A select-pane -t :.+

# Vim-like pane resizing
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Synchronize panes toggle
bind S set-window-option synchronize-panes\; display-message "synchronize-panes is now #{?pane_synchronized,on,off}"
```

### 14. Starship Performance Optimization

Create `~/.config/starship.toml` with optimizations:

```toml
# Scan timeout (faster prompt)
command_timeout = 500

# Only scan 1 directory deep for git repos
[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
disabled = false
scan_timeout = 30  # Faster for large repos

[nodejs]
detect_files = ["package.json", ".node-version"]
detect_folders = ["node_modules"]
disabled = false

[python]
detect_extensions = []  # Don't check extensions (faster)
detect_files = [".python-version", "Pipfile", "requirements.txt", "pyproject.toml"]

[rust]
detect_extensions = []
detect_files = ["Cargo.toml"]
```

---

## Development Workflow

### 15. Project Template System

Create project scaffolding tool:

**Location**: `~/.local/bin/new-project`

```bash
#!/usr/bin/env bash

PROJECT_NAME=$1
PROJECT_TYPE=${2:-"generic"}

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: new-project <name> [type]"
    echo "Types: python, node, rust, go, generic"
    exit 1
fi

mkdir -p ~/dev/$PROJECT_NAME
cd ~/dev/$PROJECT_NAME

case $PROJECT_TYPE in
    python)
        mise use python@3.12
        uv venv
        echo "venv/" > .gitignore
        echo "# $PROJECT_NAME" > README.md
        mkdir -p src tests
        touch src/__init__.py tests/__init__.py
        ;;
    node)
        mise use node@lts
        npm init -y
        echo "node_modules/" > .gitignore
        mkdir -p src tests
        ;;
    rust)
        mise use rust@stable
        cargo init
        ;;
    go)
        mise use go@latest
        go mod init $PROJECT_NAME
        mkdir -p cmd pkg
        ;;
    *)
        echo "# $PROJECT_NAME" > README.md
        touch .gitignore
        ;;
esac

git init
git add .
git commit -m "Initial commit"

echo "Project $PROJECT_NAME created at ~/dev/$PROJECT_NAME"
code ~/dev/$PROJECT_NAME
```

### 16. Docker Compose Profiles

Create common development stacks:

**Location**: `~/.docker/docker-compose.common.yml`

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_USER: postgres
      POSTGRES_DB: dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  mailhog:
    image: mailhog/mailhog
    ports:
      - "1025:1025"  # SMTP
      - "8025:8025"  # Web UI

volumes:
  postgres_data:
  redis_data:
```

**Usage**:
```bash
alias dev-stack="docker-compose -f ~/.docker/docker-compose.common.yml"
dev-stack up -d postgres redis
```

### 17. Git Hooks Setup

Add to `scripts/install.sh`:

```bash
# Install useful git hooks globally
mkdir -p ~/.git-templates/hooks

# Pre-commit hook example
cat > ~/.git-templates/hooks/pre-commit <<'EOF'
#!/bin/bash
# Run linters/formatters before commit
if command -v pre-commit &> /dev/null; then
    pre-commit run --all-files
fi
EOF

chmod +x ~/.git-templates/hooks/pre-commit

git config --global init.templateDir '~/.git-templates'
```

---

## Productivity Tools

### 18. Raycast Script Commands

Create Raycast script commands in `~/.config/raycast-scripts/`:

**aerospace-init-all.sh**:
```bash
#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Initialize All Workspaces
# @raycast.mode silent
# @raycast.packageName AeroSpace

~/.config/aerospace/scripts/init_all_workspaces.sh
```

**project-open.sh**:
```bash
#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Project
# @raycast.mode fullOutput
# @raycast.packageName Development

PROJECT=$(find ~/dev ~/projects -mindepth 1 -maxdepth 1 -type d 2>/dev/null | fzf)
if [ -n "$PROJECT" ]; then
    code "$PROJECT"
    echo "Opened: $PROJECT"
fi
```

### 19. Better Clipboard Management

Enhance Maccy with custom formats:

```bash
# Create clipboard transformation scripts
mkdir -p ~/.local/bin/clipboard-tools

# Markdown link from clipboard
cat > ~/.local/bin/clipboard-tools/md-link <<'EOF'
#!/bin/bash
URL=$(pbpaste)
echo "[$URL]($URL)" | pbcopy
EOF

chmod +x ~/.local/bin/clipboard-tools/*
```

### 20. Time Tracking Integration

Add simple time tracking:

```bash
# Add to .zshrc
timelog() {
    local log_file="$HOME/.time-tracking/$(date +%Y-%m).md"
    mkdir -p "$(dirname "$log_file")"

    if [ $# -eq 0 ]; then
        cat "$log_file"
    else
        echo "- $(date '+%Y-%m-%d %H:%M') | $*" >> "$log_file"
        echo "Logged: $*"
    fi
}

# Usage:
# timelog Started working on API endpoints
# timelog Meeting with team
# timelog    # View current month's log
```

---

## Future Considerations

### 21. Additional Tools to Explore

**Terminal Enhancements**:
- `zellij` - Modern tmux alternative (already installed)
- `helix` - Post-modern text editor
- `nushell` - Modern shell with structured data

**Development Tools**:
- `devbox` - Portable development environments (already in config)
- `direnv` - Directory-specific environment variables (already installed)
- `watchexec` - Execute commands when files change
- `just` - Command runner (already installed)

**System Tools**:
- `btop` - Better system monitor
- `dust` - Better du
- `bottom` - System monitor
- `tokei` - Code statistics

### 22. Backup and Sync Strategy

Create backup script:

**Location**: `scripts/backup_configs.sh`

```bash
#!/usr/bin/env bash
# Backup all configuration files

BACKUP_DIR="$HOME/Backups/mac-dev-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# Configurations
cp -r ~/.config "$BACKUP_DIR/"
cp ~/.zshrc "$BACKUP_DIR/"
cp ~/.tmux.conf "$BACKUP_DIR/"
cp ~/.gitconfig "$BACKUP_DIR/"

# Application settings
cp -r ~/Library/Application\ Support/Code/User "$BACKUP_DIR/vscode"

# Homebrew packages
brew bundle dump --file="$BACKUP_DIR/Brewfile" --force

# Mise tools
mise list > "$BACKUP_DIR/mise-tools.txt"

echo "Backup created at: $BACKUP_DIR"
```

### 23. Multi-Machine Sync

Use Git for dotfiles:

```bash
cd ~/mac_dev_setup
git remote add origin <your-repo-url>
git push -u origin main

# On new machine:
git clone <your-repo-url> ~/mac_dev_setup
cd ~/mac_dev_setup
./scripts/install.sh
```

### 24. Performance Monitoring

Create system health check script:

```bash
#!/usr/bin/env bash
# Check system resource usage

echo "=== System Health ==="
echo ""
echo "CPU Usage:"
top -l 1 | grep "CPU usage"
echo ""
echo "Memory:"
top -l 1 | grep PhysMem
echo ""
echo "Disk:"
df -h /
echo ""
echo "Top Processes:"
ps aux | sort -rk 3,3 | head -n 5
```

### 25. Workspace Persistence (Future Feature)

Concept for saving/restoring workspace state:

```bash
# Save current workspace state
aerospace-save-state() {
    local state_file="$HOME/.config/aerospace/saved-states/$(date +%Y%m%d-%H%M%S).json"
    mkdir -p "$(dirname "$state_file")"

    # Capture current window layout
    aerospace list-windows --all > "$state_file"
    echo "State saved to: $state_file"
}

# Restore workspace state
aerospace-restore-state() {
    local state_file=$1
    if [ -z "$state_file" ]; then
        state_file=$(find ~/.config/aerospace/saved-states -type f | fzf)
    fi

    # TODO: Parse state file and recreate layout
    echo "Restoring state from: $state_file"
}
```

---

## Implementation Priority

### High Priority (Implement Now)
1. macOS window dragging enhancement (#1)
2. Enhanced gitconfig aliases (#3)
3. Improved Zsh functions (#5)
4. Tmux session manager (#2)
5. Advanced window detection rules (#10)

### Medium Priority (Next Week)
6. Sketchybar configuration (#4)
7. FZF git integration (#12)
8. Project template system (#15)
9. Backup script (#22)
10. Enhanced tmux config (#13)

### Low Priority (When Needed)
11. Docker compose profiles (#16)
12. Raycast script commands (#18)
13. Time tracking (#20)
14. Additional tools exploration (#21)
15. Workspace persistence (#25)

---

## Conclusion

This setup is already excellent! These enhancements will:
- **Improve performance**: Faster window management, optimized shell
- **Increase productivity**: Better shortcuts, automation, tools
- **Enhance stability**: Backups, monitoring, error handling
- **Future-proof**: Modular, documented, version-controlled

**Next Steps**:
1. Review these suggestions
2. Implement high-priority items first
3. Test each enhancement individually
4. Document your customizations
5. Iterate and improve over time

Remember: A development environment is never "done" - it evolves with your needs!

---

**Created**: 2025-10-14
**Author**: Peter Campbell Clarke
