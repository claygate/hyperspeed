#!/usr/bin/env bash
# Workspace 7: Full Screen Tmux (Single Ghostty terminal with tmux, fullscreen)

set -euo pipefail

WORKSPACE=7

echo "Initializing Workspace ${WORKSPACE}: Full Screen Tmux"

# Switch to workspace
aerospace workspace ${WORKSPACE}

# Flatten any existing layout
aerospace flatten-workspace-tree

# Open Ghostty terminal with tmux
osascript <<EOF
tell application "Ghostty"
    activate
    delay 0.5
    tell application "System Events"
        keystroke "tmux new-session -A -s main"
        keystroke return
    end tell
end tell
EOF

# Wait for window to open
sleep 2

# Get Ghostty window ID
GHOSTTY_IDS=($(aerospace list-windows --workspace ${WORKSPACE} --app-id com.mitchellh.ghostty | awk '{print $1}'))

if [ ${#GHOSTTY_IDS[@]} -eq 0 ]; then
    # Fallback: just open Ghostty normally
    echo "AppleScript failed, opening Ghostty normally"
    open -na "Ghostty"
    sleep 2
    GHOSTTY_IDS=($(aerospace list-windows --workspace ${WORKSPACE} --app-id com.mitchellh.ghostty | awk '{print $1}'))
fi

if [ ${#GHOSTTY_IDS[@]} -ge 1 ]; then
    # Focus Ghostty window
    aerospace focus --window-id ${GHOSTTY_IDS[0]}

    # Set to fullscreen
    aerospace fullscreen on

    echo "Workspace ${WORKSPACE} initialized successfully"
    echo "Note: You may need to manually start tmux with 'tmux new-session -A -s main'"
else
    echo "Error: Could not initialize Ghostty window"
    exit 1
fi
