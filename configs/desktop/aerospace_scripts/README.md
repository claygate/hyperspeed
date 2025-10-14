# AeroSpace Workspace Initialization Scripts

Automated workspace layout scripts for AeroSpace window manager.

## Workspace Layouts

### Workspace 1: Terminal Grid
- **Layout**: 6 Ghostty terminals in 3×2 grid
- **Use case**: Multiple terminal sessions for development, monitoring, logs
- **Keybinding**: `Alt+i` then `1`

### Workspace 2: Second Terminal Grid
- **Layout**: 6 Ghostty terminals in 3×2 grid
- **Use case**: Additional terminal workspace for separate projects or tasks
- **Keybinding**: `Alt+i` then `2`

### Workspace 3: Mixed Layout
- **Layout**: 2 narrow Ghostty terminals (sides) + 2 Chrome windows (center)
- **Use case**: Development with terminal and browser side-by-side
- **Keybinding**: `Alt+i` then `3`

### Workspace 4: Full Screen Safari
- **Layout**: Single Safari window in fullscreen
- **Use case**: Focused web browsing, documentation reading, presentations
- **Keybinding**: `Alt+i` then `4`

### Workspace 5: Chrome Grid
- **Layout**: 6 Chrome windows in 3×2 grid
- **Use case**: Multiple web applications, dashboards, monitoring tools
- **Keybinding**: `Alt+i` then `5`

### Workspace 6: Development
- **Layout**: VSCode (75% left) + 2 Chrome windows stacked (25% right)
- **Use case**: Primary development workspace with code and browser previews
- **Keybinding**: `Alt+i` then `6`

### Workspace 7: Full Screen Tmux
- **Layout**: Single Ghostty terminal with tmux in fullscreen
- **Use case**: Deep focus terminal work with tmux session management
- **Keybinding**: `Alt+i` then `7`

### Workspace 8: Empty / Flexible
- **Layout**: Intentionally left empty
- **Use case**: Normal macOS usage, ad-hoc window management
- **Keybinding**: `Alt+8` to switch

## Usage

### Initialize Individual Workspace
```bash
~/.config/aerospace/scripts/init_workspace_1.sh
```

### Initialize All Workspaces at Once
```bash
~/.config/aerospace/scripts/init_all_workspaces.sh
```

### Reset Current Workspace
```bash
~/.config/aerospace/scripts/reset_workspace.sh
```

### Using AeroSpace Keybindings
1. Press `Alt+i` to enter layout initialization mode
2. Press number `1-7` to initialize that workspace
3. Press `a` to initialize all workspaces
4. Press `r` to reset current workspace

## Automatic Startup

To automatically initialize all workspaces when AeroSpace starts, add to your `~/.config/aerospace/aerospace.toml`:

```toml
after-startup-command = [
    'exec-and-forget ~/.config/aerospace/scripts/init_all_workspaces.sh'
]
```

Or for delayed initialization (recommended to avoid startup delays):

```bash
# Add to ~/.zshrc or run manually after login
(sleep 10 && ~/.config/aerospace/scripts/init_all_workspaces.sh) &
```

## Customization

Each script can be edited to customize:
- Number of windows
- Window arrangement
- Specific applications
- Resize parameters
- Additional automation

## Troubleshooting

### Windows not opening
- Increase `sleep` delays in scripts
- Check if applications are installed
- Verify application bundle IDs with: `aerospace list-apps`

### Layout not as expected
- Run `aerospace flatten-workspace-tree` to reset
- Manually adjust with `Alt+h/j/k/l` and `Alt+Shift+h/j/k/l`
- Check AeroSpace logs: `aerospace debug-windows`

### Script permissions
Make scripts executable:
```bash
chmod +x ~/.config/aerospace/scripts/*.sh
```

## Integration

These scripts integrate with:
- **AeroSpace**: Window management and layout control
- **Karabiner**: Hyper key for workspace switching
- **Sketchybar**: Workspace indicators
- **Borders**: Window focus highlighting
- **Tmux**: Terminal multiplexing in Workspace 7

## Tips

1. **Startup order**: Initialize workspaces 1-7 at login, keep workspace 8 clean
2. **Quick reset**: Use `Alt+i` then `r` to reset current workspace
3. **Gradual setup**: Initialize workspaces on-demand instead of all at once
4. **Monitor-specific**: All workspaces assigned to primary monitor
5. **Flexibility**: Workspace 8 remains untouched for normal macOS behavior

## Future Enhancements

Potential improvements:
- Per-workspace tmux session configurations
- URL loading for Chrome windows
- Project-specific workspace templates
- Integration with Raycast for quick workspace switching
- Saved workspace state persistence
