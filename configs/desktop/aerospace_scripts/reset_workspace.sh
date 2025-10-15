#!/usr/bin/env bash
# Reset current workspace (close all windows and flatten)

set -euo pipefail

# Get current workspace
CURRENT_WS=$(aerospace list-workspaces --focused)

echo "Resetting workspace: ${CURRENT_WS}"

# Get all windows in current workspace
mapfile -t WINDOW_IDS < <(aerospace list-windows --workspace "${CURRENT_WS}" | awk '{print $1}')

if [ ${#WINDOW_IDS[@]} -eq 0 ]; then
    echo "No windows to close in workspace ${CURRENT_WS}"
else
    echo "Closing ${#WINDOW_IDS[@]} windows..."

    # Close all windows
    for wid in "${WINDOW_IDS[@]}"; do
        aerospace close --window-id "${wid}" 2>/dev/null || true
    done
fi

# Flatten workspace tree
aerospace flatten-workspace-tree

echo "Workspace ${CURRENT_WS} has been reset"
echo "Run 'Alt+i then ${CURRENT_WS}' to reinitialize this workspace"
