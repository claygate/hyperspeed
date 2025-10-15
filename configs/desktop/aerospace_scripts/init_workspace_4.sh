#!/usr/bin/env bash
# Workspace 4: Full Screen Safari

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

WORKSPACE=4
TARGET_COUNT=1

echo "Initializing Workspace ${WORKSPACE}: Full Screen Safari"

# Switch to workspace
aerospace workspace "$WORKSPACE"

# Flatten any existing layout
act "aerospace flatten-workspace-tree"

# Check if we already have Safari window
HAVE_COUNT=$(get_window_count "$WORKSPACE" "com.apple.Safari")

if [ "$HAVE_COUNT" -lt "$TARGET_COUNT" ]; then
  echo "Opening Safari..."
  act "open -a \"Safari\""

  # Wait for window to appear
  sleep 2

  HAVE_COUNT=$(get_window_count "$WORKSPACE" "com.apple.Safari")

  # If still no window, try to create new document
  if [ "$HAVE_COUNT" -eq 0 ]; then
    echo "Trying to create new Safari window..."
    act "osascript -e 'tell application \"Safari\" to make new document' 2>/dev/null || true"
    sleep 1
    HAVE_COUNT=$(get_window_count "$WORKSPACE" "com.apple.Safari")
  fi
else
  echo "Already have $HAVE_COUNT Safari window(s) in workspace $WORKSPACE"
fi

# Get Safari window IDs
SAFARI_IDS=($(aerospace list-windows --workspace "$WORKSPACE" --app-id com.apple.Safari | awk '{print $1}'))
SAFARI_COUNT=${#SAFARI_IDS[@]}

echo "Found $SAFARI_COUNT Safari window(s)"

# Only arrange if we're in act mode and have a window
if [ "$ALPHA" -ge 1 ] && [ "$SAFARI_COUNT" -ge 1 ]; then
  # Focus Safari window
  aerospace focus --window-id "${SAFARI_IDS[0]}"

  # Set to fullscreen
  aerospace fullscreen on

  echo "Workspace ${WORKSPACE} initialized successfully"
elif [ "$SAFARI_COUNT" -eq 0 ]; then
  echo "Warning: Could not initialize Safari window"
else
  echo "Workspace ${WORKSPACE} initialized successfully (plan mode)"
fi
