#!/usr/bin/env bash
# Workspace 1: Terminal Grid (6 Ghostty terminals in 3×2 grid)

set -euo pipefail

WORKSPACE=1

echo "Initializing Workspace ${WORKSPACE}: Terminal Grid (6 terminals)"

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

# Set to horizontal tiles layout for the root
aerospace layout h_tiles

# Create 3×2 grid structure
# Row 1: 3 windows side by side
# Row 2: 3 windows side by side

# Focus and arrange first 3 windows in top row (already horizontal)
# Windows are already being added horizontally, so first 3 are in a row

# Now we need to create the second row
# Focus the 4th window and create a new row below
if [ ${#WINDOW_IDS[@]} -ge 4 ]; then
    aerospace focus --window-id ${WINDOW_IDS[3]}
    # Join with first window to create proper tiling
    aerospace move left
    aerospace move down 2>/dev/null || true
fi

# Arrange remaining windows
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
