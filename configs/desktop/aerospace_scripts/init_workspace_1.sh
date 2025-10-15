#!/usr/bin/env bash
# Workspace 1: Terminal Grid (6 Ghostty terminals in 3×2 grid)

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

WORKSPACE=1
TARGET_COUNT=6

echo "Initializing Workspace ${WORKSPACE}: Terminal Grid (${TARGET_COUNT} terminals)"

# Switch to workspace
aerospace workspace "$WORKSPACE"

# Flatten any existing layout
act "aerospace flatten-workspace-tree"

# Open Ghostty terminals until we have the target count (idempotent)
open_until_count "$WORKSPACE" "Ghostty" "com.mitchellh.ghostty" "$TARGET_COUNT"

# Wait for all windows to be ready
sleep 1

# Get all Ghostty window IDs in this workspace
WINDOW_IDS=($(aerospace list-windows --workspace "$WORKSPACE" --app-id com.mitchellh.ghostty | awk '{print $1}'))

WINDOW_COUNT=${#WINDOW_IDS[@]}
echo "Found $WINDOW_COUNT Ghostty windows in workspace $WORKSPACE"

if [ "$WINDOW_COUNT" -lt "$TARGET_COUNT" ]; then
  echo "Warning: Expected $TARGET_COUNT windows, found $WINDOW_COUNT"
fi

# Only arrange if we're in act mode and have windows
if [ "$ALPHA" -ge 1 ] && [ "$WINDOW_COUNT" -ge 3 ]; then
  # Focus first window
  aerospace focus --window-id "${WINDOW_IDS[0]}" 2>/dev/null || true

  # Set to horizontal tiles layout for the root
  aerospace layout h_tiles

  # Create 3×2 grid structure
  # Row 1: 3 windows side by side (default horizontal layout)
  # Row 2: 3 windows side by side (need to arrange)

  if [ "$WINDOW_COUNT" -ge 4 ]; then
    aerospace focus --window-id "${WINDOW_IDS[3]}"
    aerospace move left 2>/dev/null || true
    aerospace move down 2>/dev/null || true
  fi

  if [ "$WINDOW_COUNT" -ge 5 ]; then
    aerospace focus --window-id "${WINDOW_IDS[4]}"
    aerospace move right 2>/dev/null || true
  fi

  if [ "$WINDOW_COUNT" -ge 6 ]; then
    aerospace focus --window-id "${WINDOW_IDS[5]}"
    aerospace move right 2>/dev/null || true
  fi

  # Balance the layout
  aerospace balance-sizes
fi

echo "Workspace ${WORKSPACE} initialized successfully"
