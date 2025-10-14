#!/usr/bin/env bash
# Workspace 2: Second Terminal Grid (6 Ghostty terminals in 3×2 grid)

set -euo pipefail

WORKSPACE=2

echo "Initializing Workspace ${WORKSPACE}: Second Terminal Grid (6 terminals)"

# Switch to workspace
aerospace workspace ${WORKSPACE}

# Flatten any existing layout
aerospace flatten-workspace-tree

# Open 6 Ghostty terminals
for i in {1..6}; do
    open -na "Ghostty"
    sleep 0.5
done

# Wait for windows to open
sleep 2

# Get all Ghostty window IDs in this workspace
WINDOW_IDS=($(aerospace list-windows --workspace ${WORKSPACE} --app-id com.mitchellh.ghostty | awk '{print $1}'))

if [ ${#WINDOW_IDS[@]} -lt 6 ]; then
    echo "Warning: Expected 6 windows, found ${#WINDOW_IDS[@]}"
fi

# Focus first window
aerospace focus --window-id ${WINDOW_IDS[0]} 2>/dev/null || true

# Set to horizontal tiles layout
aerospace layout h_tiles

# Create 3×2 grid structure (same as workspace 1)
if [ ${#WINDOW_IDS[@]} -ge 4 ]; then
    aerospace focus --window-id ${WINDOW_IDS[3]}
    aerospace move left
    aerospace move down 2>/dev/null || true
fi

if [ ${#WINDOW_IDS[@]} -ge 5 ]; then
    aerospace focus --window-id ${WINDOW_IDS[4]}
    aerospace move right
fi

if [ ${#WINDOW_IDS[@]} -ge 6 ]; then
    aerospace focus --window-id ${WINDOW_IDS[5]}
    aerospace move right
fi

# Balance the layout
aerospace balance-sizes

echo "Workspace ${WORKSPACE} initialized successfully"
