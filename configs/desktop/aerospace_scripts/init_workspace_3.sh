#!/usr/bin/env bash
# Workspace 3: Mixed Layout (2 narrow Ghostty terminals + 2 Chrome windows in center)

set -euo pipefail

WORKSPACE=3

echo "Initializing Workspace ${WORKSPACE}: Mixed Layout (2 Ghostty + 2 Chrome)"

# Switch to workspace
aerospace workspace ${WORKSPACE}

# Flatten any existing layout
aerospace flatten-workspace-tree

# Open 2 Ghostty terminals (narrower terminals for sides)
for i in {1..2}; do
    open -na "Ghostty"
    sleep 0.5
done

# Open 2 Chrome windows
for i in {1..2}; do
    open -na "Google Chrome" --args --new-window
    sleep 0.5
done

# Wait for windows to open
sleep 2

# Get window IDs
GHOSTTY_IDS=($(aerospace list-windows --workspace ${WORKSPACE} --app-id com.mitchellh.ghostty | awk '{print $1}'))
CHROME_IDS=($(aerospace list-windows --workspace ${WORKSPACE} --app-id com.google.Chrome | awk '{print $1}'))

echo "Found ${#GHOSTTY_IDS[@]} Ghostty windows and ${#CHROME_IDS[@]} Chrome windows"

# Set horizontal layout
aerospace layout h_tiles

# Arrange: Ghostty | Chrome | Chrome | Ghostty
# Focus and arrange windows
if [ ${#GHOSTTY_IDS[@]} -ge 1 ]; then
    aerospace focus --window-id ${GHOSTTY_IDS[0]}
fi

if [ ${#CHROME_IDS[@]} -ge 1 ]; then
    aerospace focus --window-id ${CHROME_IDS[0]}
    aerospace move right
fi

if [ ${#CHROME_IDS[@]} -ge 2 ]; then
    aerospace focus --window-id ${CHROME_IDS[1]}
    aerospace move right
fi

if [ ${#GHOSTTY_IDS[@]} -ge 2 ]; then
    aerospace focus --window-id ${GHOSTTY_IDS[1]}
    aerospace move right
fi

# Resize terminals to be narrower (20% each) and Chrome wider (30% each)
if [ ${#GHOSTTY_IDS[@]} -ge 1 ]; then
    aerospace focus --window-id ${GHOSTTY_IDS[0]}
    aerospace resize width -200
fi

if [ ${#GHOSTTY_IDS[@]} -ge 2 ]; then
    aerospace focus --window-id ${GHOSTTY_IDS[1]}
    aerospace resize width -200
fi

echo "Workspace ${WORKSPACE} initialized successfully"
