#!/usr/bin/env bash
# Workspace 6: Development Layout (VSCode 75% left + 2 Chrome stacked 25% right)

set -euo pipefail

WORKSPACE=6

echo "Initializing Workspace ${WORKSPACE}: Development Layout (VSCode + 2 Chrome)"

# Switch to workspace
aerospace workspace ${WORKSPACE}

# Flatten any existing layout
aerospace flatten-workspace-tree

# Open VSCode
open -na "Visual Studio Code"
sleep 1

# Open 2 Chrome windows
for i in {1..2}; do
    open -na "Google Chrome" --args --new-window
    sleep 0.5
done

# Wait for windows to open
sleep 2

# Get window IDs
VSCODE_IDS=($(aerospace list-windows --workspace ${WORKSPACE} --app-id com.microsoft.VSCode | awk '{print $1}'))
CHROME_IDS=($(aerospace list-windows --workspace ${WORKSPACE} --app-id com.google.Chrome | awk '{print $1}'))

echo "Found ${#VSCODE_IDS[@]} VSCode windows and ${#CHROME_IDS[@]} Chrome windows"

if [ ${#VSCODE_IDS[@]} -eq 0 ]; then
    echo "Error: No VSCode window found"
    exit 1
fi

# Set horizontal layout
aerospace layout h_tiles

# Arrange: VSCode (left, large) | Chrome | Chrome (right, stacked)
if [ ${#VSCODE_IDS[@]} -ge 1 ]; then
    aerospace focus --window-id ${VSCODE_IDS[0]}
fi

if [ ${#CHROME_IDS[@]} -ge 1 ]; then
    aerospace focus --window-id ${CHROME_IDS[0]}
    aerospace move right
fi

if [ ${#CHROME_IDS[@]} -ge 2 ]; then
    aerospace focus --window-id ${CHROME_IDS[1]}
    aerospace move right
    # Stack the second Chrome window below the first
    aerospace move down 2>/dev/null || true
fi

# Resize VSCode to be ~75% width
if [ ${#VSCODE_IDS[@]} -ge 1 ]; then
    aerospace focus --window-id ${VSCODE_IDS[0]}
    # Increase width significantly
    for i in {1..3}; do
        aerospace resize width +200
    done
fi

# Balance Chrome windows vertically
if [ ${#CHROME_IDS[@]} -ge 2 ]; then
    aerospace focus --window-id ${CHROME_IDS[0]}
    aerospace balance-sizes
fi

echo "Workspace ${WORKSPACE} initialized successfully"
