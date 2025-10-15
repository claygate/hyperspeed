#!/usr/bin/env bash
# Workspace 6: Development Layout (VSCode 75% left + 2 Chrome stacked 25% right)

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

WORKSPACE=6
TARGET_VSCODE=1
TARGET_CHROME=2

echo "Initializing Workspace ${WORKSPACE}: Development Layout (${TARGET_VSCODE} VSCode + ${TARGET_CHROME} Chrome)"

# Switch to workspace
aerospace workspace "$WORKSPACE"

# Flatten any existing layout
act "aerospace flatten-workspace-tree"

# Open VSCode until we have the target count (idempotent)
open_until_count "$WORKSPACE" "Visual Studio Code" "com.microsoft.VSCode" "$TARGET_VSCODE"

# Open Chrome windows until we have the target count (idempotent)
open_until_count "$WORKSPACE" "Google Chrome" "com.google.Chrome" "$TARGET_CHROME"

# Wait for all windows to be ready
sleep 1

# Get window IDs
mapfile -t VSCODE_IDS < <(aerospace list-windows --workspace "$WORKSPACE" --app-id com.microsoft.VSCode | awk '{print $1}')
mapfile -t CHROME_IDS < <(aerospace list-windows --workspace "$WORKSPACE" --app-id com.google.Chrome | awk '{print $1}')

VSCODE_COUNT=${#VSCODE_IDS[@]}
CHROME_COUNT=${#CHROME_IDS[@]}
echo "Found $VSCODE_COUNT VSCode window(s) and $CHROME_COUNT Chrome windows"

if [ "$VSCODE_COUNT" -lt "$TARGET_VSCODE" ]; then
  echo "Warning: Expected $TARGET_VSCODE VSCode window, found $VSCODE_COUNT"
fi

if [ "$CHROME_COUNT" -lt "$TARGET_CHROME" ]; then
  echo "Warning: Expected $TARGET_CHROME Chrome windows, found $CHROME_COUNT"
fi

# Only arrange if we're in act mode and have windows
if [ "$ALPHA" -ge 1 ] && [ "$VSCODE_COUNT" -ge 1 ] && [ "$CHROME_COUNT" -ge 1 ]; then
  # Set horizontal layout
  aerospace layout h_tiles

  # Arrange: VSCode (left, large) | Chrome | Chrome (right, stacked)
  if [ "$VSCODE_COUNT" -ge 1 ]; then
    aerospace focus --window-id "${VSCODE_IDS[0]}"
  fi

  if [ "$CHROME_COUNT" -ge 1 ]; then
    aerospace focus --window-id "${CHROME_IDS[0]}"
    aerospace move right 2>/dev/null || true
  fi

  if [ "$CHROME_COUNT" -ge 2 ]; then
    aerospace focus --window-id "${CHROME_IDS[1]}"
    aerospace move right 2>/dev/null || true
    # Stack the second Chrome window below the first
    aerospace move down 2>/dev/null || true
  fi

  # Resize VSCode to be ~75% width
  if [ "$VSCODE_COUNT" -ge 1 ]; then
    aerospace focus --window-id "${VSCODE_IDS[0]}"
    # Increase width significantly
    for _ in {1..3}; do
      aerospace resize width +200 2>/dev/null || true
    done
  fi

  # Balance Chrome windows vertically
  if [ "$CHROME_COUNT" -ge 2 ]; then
    aerospace focus --window-id "${CHROME_IDS[0]}"
    aerospace balance-sizes
  fi
fi

echo "Workspace ${WORKSPACE} initialized successfully"
