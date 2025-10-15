#!/usr/bin/env bash
# Workspace 7: Full Screen Tmux (Single Ghostty terminal with tmux, fullscreen)

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./common.sh
source "$SCRIPT_DIR/common.sh"

WORKSPACE=7
TARGET_COUNT=1

echo "Initializing Workspace ${WORKSPACE}: Full Screen Tmux"

# Switch to workspace
aerospace workspace "$WORKSPACE"

# Flatten any existing layout
act "aerospace flatten-workspace-tree"

# Check if we already have Ghostty window
HAVE_COUNT=$(get_window_count "$WORKSPACE" "com.mitchellh.ghostty")

if [ "$HAVE_COUNT" -lt "$TARGET_COUNT" ]; then
  echo "Opening Ghostty with tmux..."

  # Try using AppleScript to open Ghostty and start tmux
  if [ "$ALPHA" -ge 1 ]; then
    osascript <<EOF 2>/dev/null || true
tell application "Ghostty"
    activate
    delay 0.5
    tell application "System Events"
        keystroke "tmux new-session -A -s main"
        keystroke return
    end tell
end tell
EOF
  else
    plan "osascript to open Ghostty and start tmux session 'main'"
  fi

  # Wait for window to appear
  sleep 2

  HAVE_COUNT=$(get_window_count "$WORKSPACE" "com.mitchellh.ghostty")

  # Fallback: just open Ghostty normally if AppleScript failed
  if [ "$HAVE_COUNT" -eq 0 ]; then
    echo "AppleScript failed, opening Ghostty normally"
    act "open -na \"Ghostty\""
    sleep 2
    HAVE_COUNT=$(get_window_count "$WORKSPACE" "com.mitchellh.ghostty")
  fi
else
  echo "Already have $HAVE_COUNT Ghostty window(s) in workspace $WORKSPACE"
fi

# Get Ghostty window IDs
GHOSTTY_IDS=($(aerospace list-windows --workspace "$WORKSPACE" --app-id com.mitchellh.ghostty | awk '{print $1}'))
GHOSTTY_COUNT=${#GHOSTTY_IDS[@]}

echo "Found $GHOSTTY_COUNT Ghostty window(s)"

# Only arrange if we're in act mode and have a window
if [ "$ALPHA" -ge 1 ] && [ "$GHOSTTY_COUNT" -ge 1 ]; then
  # Focus Ghostty window
  aerospace focus --window-id "${GHOSTTY_IDS[0]}"

  # Set to fullscreen
  aerospace fullscreen on

  echo "Workspace ${WORKSPACE} initialized successfully"
  echo "Note: You may need to manually start tmux with 'tmux new-session -A -s main'"
elif [ "$GHOSTTY_COUNT" -eq 0 ]; then
  echo "Warning: Could not initialize Ghostty window"
else
  echo "Workspace ${WORKSPACE} initialized successfully (plan mode)"
fi
