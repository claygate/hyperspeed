# AeroSpace Workspace Automation Guide

Complete guide for the automated workspace initialization system for AeroSpace window manager.

## Table of Contents
1. [Overview](#overview)
2. [Workspace Layouts](#workspace-layouts)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Configuration](#configuration)
6. [Customization](#customization)
7. [Troubleshooting](#troubleshooting)
8. [Advanced Features](#advanced-features)

## Overview

This automation system provides 8 pre-configured workspaces with automatic window placement and layout management. Each workspace is optimized for specific workflows and can be initialized on-demand or automatically at startup.

### Key Features

- **8 Pre-configured Workspaces**: From terminal grids to development layouts
- **One-command Initialization**: Launch and arrange all windows automatically
- **Keyboard-driven**: Vim-style navigation and custom modes
- **Smart Window Placement**: Automatic sizing and positioning
- **Flexible**: Easy to customize and extend
- **Integration**: Works with Borders, Sketchybar, and tmux

## Workspace Layouts

### Workspace 1: Terminal Grid
**Layout**: 6 Ghostty terminals in 3×2 grid
**Perfect for**: Multiple concurrent terminal sessions, log monitoring, dev/staging/prod views
```
┌──────┬──────┬──────┐
│  T1  │  T2  │  T3  │
├──────┼──────┼──────┤
│  T4  │  T5  │  T6  │
└──────┴──────┴──────┘
```

### Workspace 2: Second Terminal Grid
**Layout**: 6 Ghostty terminals in 3×2 grid
**Perfect for**: Separate project, additional monitoring, microservices development
```
┌──────┬──────┬──────┐
│  T1  │  T2  │  T3  │
├──────┼──────┼──────┤
│  T4  │  T5  │  T6  │
└──────┴──────┴──────┘
```

### Workspace 3: Mixed Layout
**Layout**: 2 narrow Ghostty (20% each) + 2 Chrome windows (30% each)
**Perfect for**: Development with quick terminal access and dual browser views
```
┌──┬───────┬───────┬──┐
│T1│ C1    │ C2    │T2│
│  │       │       │  │
└──┴───────┴───────┴──┘
```

### Workspace 4: Full Screen Safari
**Layout**: Single Safari window in fullscreen
**Perfect for**: Focused reading, presentations, documentation deep dives
```
┌─────────────────────┐
│                     │
│      Safari         │
│    (Fullscreen)     │
│                     │
└─────────────────────┘
```

### Workspace 5: Chrome Grid
**Layout**: 6 Chrome windows in 3×2 grid
**Perfect for**: Multiple web dashboards, monitoring tools, web app testing
```
┌──────┬──────┬──────┐
│  C1  │  C2  │  C3  │
├──────┼──────┼──────┤
│  C4  │  C5  │  C6  │
└──────┴──────┴──────┘
```

### Workspace 6: Development
**Layout**: VSCode (75% left) + 2 Chrome stacked (25% right)
**Perfect for**: Primary development with live preview and documentation
```
┌──────────────┬────┐
│              │ C1 │
│    VSCode    ├────┤
│              │ C2 │
└──────────────┴────┘
```

### Workspace 7: Full Screen Tmux
**Layout**: Single Ghostty with tmux session in fullscreen
**Perfect for**: Deep focus terminal work, complex tmux workflows
```
┌─────────────────────┐
│                     │
│    Ghostty+Tmux     │
│    (Fullscreen)     │
│                     │
└─────────────────────┘
```

### Workspace 8: Empty / Flexible
**Layout**: Intentionally left empty
**Perfect for**: Normal macOS usage, ad-hoc window arrangements, temporary work

## Installation

### Automatic Installation (Recommended)

During the main installation, answer "Y" when prompted:
```bash
cd ~/mac_dev_setup
./scripts/install.sh
# When prompted: "Setup AeroSpace workspace automation? (Y/n):" press Y
```

### Manual Installation

If you skipped automation during install or want to reinstall:
```bash
cd ~/mac_dev_setup
./scripts/setup_aerospace_automation.sh
```

### What Gets Installed

1. **Enhanced AeroSpace Config**: `~/.config/aerospace/aerospace.toml`
   - Custom modes for layout initialization
   - Resize mode for fine-tuning
   - Integration with Borders and Sketchybar

2. **Workspace Scripts**: `~/.config/aerospace/scripts/`
   - Individual workspace initialization scripts (1-7)
   - Master initialization script
   - Reset utility script

3. **Launch Agent** (optional): `~/Library/LaunchAgents/com.aerospace.workspace-init.plist`
   - Automatic workspace initialization at login
   - Not loaded by default

## Usage

### Basic Workspace Switching

```bash
Alt + 1-8          # Switch to workspace 1-8
Alt + Shift + 1-8  # Move current window to workspace 1-8
```

### Initialize Workspaces

#### Using Keyboard (Recommended)
```bash
Alt + i            # Enter layout initialization mode
  then 1-7         # Initialize specific workspace
  or   a           # Initialize all workspaces
  or   r           # Reset current workspace
  or   Esc/q       # Exit mode
```

#### Using Command Line
```bash
# Initialize specific workspace
~/.config/aerospace/scripts/init_workspace_1.sh

# Initialize all workspaces
~/.config/aerospace/scripts/init_all_workspaces.sh

# Reset current workspace
~/.config/aerospace/scripts/reset_workspace.sh
```

### Window Management

```bash
# Focus windows (vim-style)
Alt + h/j/k/l      # Focus left/down/up/right

# Move windows
Alt + Shift + h/j/k/l  # Move window left/down/up/right

# Layout controls
Alt + b            # Horizontal tiles layout
Alt + v            # Vertical tiles layout
Alt + /            # Toggle vertical/horizontal
Alt + ,            # Accordion layout
Alt + f            # Toggle fullscreen

# Resize mode
Alt + r            # Enter resize mode
  h/j/k/l          # Resize by 50px
  Shift + h/j/k/l  # Resize by 10px
  -/=              # Smart resize
  Esc/q/Enter      # Exit mode

# Apps mode (quick launcher)
Alt + Space        # Enter apps mode
  t                # Open Ghostty
  w                # Open WezTerm
  c                # Open VSCode
  s                # Open Safari
  b                # Open Chrome
  o                # Open Obsidian
  r                # Open Raycast
  m                # Open Maccy
  Esc/q            # Exit mode
```

### Karabiner Integration

```bash
Caps Lock (hold)   # Hyper key (⌘⌃⌥⇧)
Caps Lock (tap)    # Escape
Hyper + 1-9        # Switch workspace (alternative to Alt+1-9)
```

## Configuration

### AeroSpace Config Location
```bash
~/.config/aerospace/aerospace.toml
```

### Key Configuration Sections

#### Gaps
```toml
[gaps]
inner.horizontal = 8
inner.vertical = 8
outer.top = 8
outer.bottom = 8
outer.left = 8
outer.right = 24
```

#### Window Detection Rules
```toml
[[on-window-detected]]
if.app-id = 'com.apple.Safari'
run = 'move-node-to-workspace 4'

[[on-window-detected]]
if.app-id = 'com.microsoft.VSCode'
run = 'move-node-to-workspace 6'
```

#### Startup Commands
```toml
after-startup-command = [
    'exec-and-forget borders active_color=0xff89b4fa inactive_color=0xff45475a width=5.0',
    'exec-and-forget sketchybar --trigger aerospace_workspace_change'
]
```

## Customization

### Modify Workspace Layout

Edit the corresponding script in `~/.config/aerospace/scripts/`:

```bash
vim ~/.config/aerospace/scripts/init_workspace_1.sh
```

Example modifications:
- Change number of windows
- Adjust window sizes with `aerospace resize`
- Use different applications
- Add delays for slow-starting apps

### Add New Applications

Find the app bundle ID:
```bash
aerospace list-apps
```

Use in window detection rules:
```toml
[[on-window-detected]]
if.app-id = 'com.example.MyApp'
run = 'move-node-to-workspace 5'
```

### Custom Workspace Templates

Create your own initialization script:
```bash
cp ~/.config/aerospace/scripts/init_workspace_1.sh \
   ~/.config/aerospace/scripts/init_workspace_custom.sh

# Edit and customize
vim ~/.config/aerospace/scripts/init_workspace_custom.sh

# Add to aerospace.toml
[mode.layout-init.binding]
x = ['exec-and-forget ~/.config/aerospace/scripts/init_workspace_custom.sh', 'mode main']
```

### Enable Automatic Initialization

Option 1: LaunchAgent (runs 15 seconds after login)
```bash
launchctl load -w ~/Library/LaunchAgents/com.aerospace.workspace-init.plist
```

Option 2: Add to .zshrc (runs when opening terminal)
```bash
echo '(sleep 10 && ~/.config/aerospace/scripts/init_all_workspaces.sh) &' >> ~/.zshrc
```

Option 3: AeroSpace config (runs immediately after AeroSpace starts)
```toml
after-startup-command = [
    'exec-and-forget ~/.config/aerospace/scripts/init_all_workspaces.sh'
]
```

## Troubleshooting

### Windows Not Opening
**Problem**: Script completes but no windows appear

**Solutions**:
1. Increase sleep delays in scripts
2. Check if applications are installed: `ls /Applications/`
3. Grant automation permissions: System Settings → Privacy & Security → Automation

### Layout Not as Expected
**Problem**: Windows appear but layout is wrong

**Solutions**:
1. Reset workspace: `Alt+i` then `r`
2. Flatten workspace tree: `aerospace flatten-workspace-tree`
3. Check window count: `aerospace list-windows`
4. Manually adjust: Use `Alt+h/j/k/l` and `Alt+Shift+h/j/k/l`

### Script Permissions
**Problem**: "Permission denied" errors

**Solution**:
```bash
chmod +x ~/.config/aerospace/scripts/*.sh
```

### App Bundle ID Not Found
**Problem**: Window detection rules not working

**Solutions**:
1. List running apps: `aerospace list-apps`
2. Find correct bundle ID: `osascript -e 'id of app "AppName"'`
3. Update config with correct bundle ID

### Slow Initialization
**Problem**: Scripts take too long to complete

**Solutions**:
1. Initialize workspaces on-demand instead of all at once
2. Reduce sleep delays in scripts (but may cause failures)
3. Use SSD for faster app launching
4. Close unnecessary background apps

### Tmux Not Starting (Workspace 7)
**Problem**: Terminal opens but tmux doesn't start

**Solutions**:
1. Manually start tmux: `tmux new-session -A -s main`
2. Check if tmux is installed: `which tmux`
3. Use alternative approach: Create Ghostty config with default command

## Advanced Features

### Per-Workspace Tmux Sessions

Create workspace-specific tmux sessions:
```bash
# In init_workspace_1.sh, replace terminal opening with:
for i in {1..6}; do
    osascript -e 'tell application "Ghostty" to activate' -e \
      'tell application "System Events" to keystroke "tmux new-session -A -s ws1-${i}" & return'
    sleep 0.5
done
```

### URL Loading for Chrome

Add URL opening to Chrome initialization:
```bash
# In init_workspace_5.sh
URLS=(
    "https://github.com"
    "https://gmail.com"
    "https://calendar.google.com"
    # ... more URLs
)

for url in "${URLS[@]}"; do
    open -na "Google Chrome" --args --new-window "$url"
    sleep 0.5
done
```

### Project-Specific Workspaces

Create project templates:
```bash
# ~/projects/myproject/workspace-setup.sh
cd ~/projects/myproject

aerospace workspace 1
~/.config/aerospace/scripts/init_workspace_1.sh

# Open project in each terminal
for term in $(aerospace list-windows --workspace 1 --app-id com.mitchellh.ghostty); do
    # Send commands to terminal (implementation varies)
done
```

### Raycast Integration

Create Raycast script commands:
```bash
#!/bin/bash
# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Init Workspace 1
# @raycast.mode silent

~/.config/aerospace/scripts/init_workspace_1.sh
```

### Monitoring and Logging

Add logging to scripts:
```bash
LOG_FILE="$HOME/.config/aerospace/workspace-init.log"

log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_msg "Initializing workspace 1"
# ... rest of script
log_msg "Workspace 1 initialized successfully"
```

### State Persistence

Save and restore workspace state:
```bash
# Save current workspace state
aerospace list-windows --all > ~/.config/aerospace/workspace-state.txt

# Restore (requires custom logic)
# Parse saved state and recreate layout
```

## Integration with Other Tools

### Sketchybar Workspace Indicators

Add to Sketchybar config:
```bash
sketchybar --add event aerospace_workspace_change

sketchybar --add item workspace left \
           --set workspace script="~/.config/sketchybar/plugins/aerospace.sh" \
           --subscribe workspace aerospace_workspace_change
```

### Borders (Window Highlighting)

Already integrated via `after-startup-command`. Customize colors:
```toml
after-startup-command = [
    'exec-and-forget borders active_color=0xffa6e3a1 inactive_color=0xff313244 width=8.0'
]
```

### Alfred/Raycast Workflows

Trigger workspace initialization from launcher:
- Create script command in Raycast
- Create workflow in Alfred
- Bind to custom keyboard shortcut

## Best Practices

1. **Gradual Setup**: Initialize workspaces on-demand rather than all at once
2. **Workspace 8**: Keep it empty for flexibility and normal macOS behavior
3. **Test Changes**: Modify one workspace script at a time
4. **Backup Config**: Keep your aerospace.toml in version control
5. **Document Custom Scripts**: Add comments explaining your modifications
6. **Monitor Resources**: Multiple workspaces with many windows use memory
7. **Use Tmux**: Workspace 7 with tmux is more resource-efficient than multiple terminals
8. **Keyboard Focus**: Learn the keybindings to maximize productivity

## Resources

- AeroSpace Documentation: https://nikitabobko.github.io/AeroSpace/
- AeroSpace GitHub: https://github.com/nikitabobko/AeroSpace
- Hyperspeed Repository: https://github.com/russet/hyperspeed
- This Setup: ~/hyperspeed/
- Script Documentation: ~/.config/aerospace/scripts/README.md
- Configuration File: ~/.config/aerospace/aerospace.toml

## Contributing

Found a better layout? Improved script? Share it:
1. Document your changes clearly
2. Test on fresh install if possible
3. Create examples for others to follow
4. Consider edge cases (slow apps, multiple monitors)

## Future Enhancements

Planned improvements:
- Multi-monitor support with monitor-specific layouts
- Workspace state save/restore
- Project templates
- Time-based workspace switching
- Integration with calendar for automatic layout changes
- Per-workspace environment variables
- Automatic URL loading based on project

---

**Created**: 2025-10-14
**Author**: Peter Campbell Clarke
**License**: MIT
