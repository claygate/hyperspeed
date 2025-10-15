#!/usr/bin/env bash
# Workspace 3: Mixed Layout (2 narrow Ghostty terminals + 2 Chrome windows in center)

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

WORKSPACE=3
TARGET_GHOSTTY=2
TARGET_CHROME=2

echo "Initializing Workspace ${WORKSPACE}: Mixed Layout (${TARGET_GHOSTTY} Ghostty + ${TARGET_CHROME} Chrome)"

# Switch to workspace
aerospace workspace "$WORKSPACE"

# Flatten any existing layout
act "aerospace flatten-workspace-tree"

# Open Ghostty terminals until we have the target count (idempotent)
open_until_count "$WORKSPACE" "Ghostty" "com.mitchellh.ghostty" "$TARGET_GHOSTTY"

# Open Chrome windows until we have the target count (idempotent)
open_until_count "$WORKSPACE" "Google Chrome" "com.google.Chrome" "$TARGET_CHROME"

# Wait for all windows to be ready
sleep 1

# Get window IDs
mapfile -t GHOSTTY_IDS < <(aerospace list-windows --workspace "$WORKSPACE" --app-id com.mitchellh.ghostty | awk '{print $1}')
mapfile -t CHROME_IDS < <(aerospace list-windows --workspace "$WORKSPACE" --app-id com.google.Chrome | awk '{print $1}')

GHOSTTY_COUNT=${#GHOSTTY_IDS[@]}
CHROME_COUNT=${#CHROME_IDS[@]}
echo "Found $GHOSTTY_COUNT Ghostty windows and $CHROME_COUNT Chrome windows"

if [ "$GHOSTTY_COUNT" -lt "$TARGET_GHOSTTY" ]; then
  echo "Warning: Expected $TARGET_GHOSTTY Ghostty windows, found $GHOSTTY_COUNT"
fi

if [ "$CHROME_COUNT" -lt "$TARGET_CHROME" ]; then
  echo "Warning: Expected $TARGET_CHROME Chrome windows, found $CHROME_COUNT"
fi

# Only arrange if we're in act mode and have windows
if [ "$ALPHA" -ge 1 ] && [ "$GHOSTTY_COUNT" -ge 1 ] && [ "$CHROME_COUNT" -ge 1 ]; then
  # Set horizontal layout
  aerospace layout h_tiles

  # Arrange: Ghostty | Chrome | Chrome | Ghostty
  if [ "$GHOSTTY_COUNT" -ge 1 ]; then
    aerospace focus --window-id "${GHOSTTY_IDS[0]}"
  fi

  if [ "$CHROME_COUNT" -ge 1 ]; then
    aerospace focus --window-id "${CHROME_IDS[0]}"
    aerospace move right 2>/dev/null || true
  fi

  if [ "$CHROME_COUNT" -ge 2 ]; then
    aerospace focus --window-id "${CHROME_IDS[1]}"
    aerospace move right 2>/dev/null || true
  fi

  if [ "$GHOSTTY_COUNT" -ge 2 ]; then
    aerospace focus --window-id "${GHOSTTY_IDS[1]}"
    aerospace move right 2>/dev/null || true
  fi

  # Resize terminals to be narrower (20% each) and Chrome wider (30% each)
  if [ "$GHOSTTY_COUNT" -ge 1 ]; then
    aerospace focus --window-id "${GHOSTTY_IDS[0]}"
    aerospace resize width -200 2>/dev/null || true
  fi

  if [ "$GHOSTTY_COUNT" -ge 2 ]; then
    aerospace focus --window-id "${GHOSTTY_IDS[1]}"
    aerospace resize width -200 2>/dev/null || true
  fi
fi

echo "Workspace ${WORKSPACE} initialized successfully"
