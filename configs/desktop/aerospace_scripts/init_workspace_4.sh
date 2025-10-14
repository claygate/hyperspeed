#!/usr/bin/env bash
# Workspace 4: Full Screen Safari

set -euo pipefail

WORKSPACE=4

echo "Initializing Workspace ${WORKSPACE}: Full Screen Safari"

# Switch to workspace
aerospace workspace ${WORKSPACE}

# Flatten any existing layout
aerospace flatten-workspace-tree

# Open Safari if not already open
open -a "Safari"

# Wait for window to open
sleep 2

# Get Safari window ID
SAFARI_IDS=($(aerospace list-windows --workspace ${WORKSPACE} --app-id com.apple.Safari | awk '{print $1}'))

if [ ${#SAFARI_IDS[@]} -eq 0 ]; then
    echo "Warning: No Safari window found, trying to open new window"
    osascript -e 'tell application "Safari" to make new document' 2>/dev/null || true
    sleep 1
    SAFARI_IDS=($(aerospace list-windows --workspace ${WORKSPACE} --app-id com.apple.Safari | awk '{print $1}'))
fi

if [ ${#SAFARI_IDS[@]} -ge 1 ]; then
    # Focus Safari window
    aerospace focus --window-id ${SAFARI_IDS[0]}

    # Set to fullscreen
    aerospace fullscreen on

    echo "Workspace ${WORKSPACE} initialized successfully"
else
    echo "Error: Could not initialize Safari window"
    exit 1
fi
