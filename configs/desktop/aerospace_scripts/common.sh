#!/usr/bin/env bash
# Common functions for AeroSpace workspace scripts
# Source this at the top of each init_workspace_*.sh script

set -euo pipefail

# Guard: ensure command is available
guard() {
  command -v "$1" >/dev/null || {
    echo "Error: $1 not found. Install it first."
    exit 1
  }
}

# Verify required commands
guard aerospace
guard open

# Autonomy slider: 0=plan-only (safe default), 1=execute
ALPHA="${AUTONOMY:-0}"

# Plan: show what would be executed
plan() {
  echo "[PLAN] $*"
}

# Act: execute if AUTONOMY >= 1, otherwise plan
act() {
  if [ "$ALPHA" -ge 1 ]; then
    eval "$@"
  else
    plan "$@"
  fi
}

# Wait for condition to become true (with timeout)
# Usage: wait_until "command that returns 0 when ready" timeout_seconds
wait_until() {
  local cmd="$1"
  local timeout="${2:-10}"
  local elapsed=0

  while [ $elapsed -lt $timeout ]; do
    if eval "$cmd" >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
    elapsed=$((elapsed + 1))
  done

  echo "Warning: Timeout waiting for: $cmd"
  return 1
}

# Get current window count for an app in a workspace
# Usage: get_window_count workspace app_id
get_window_count() {
  local workspace="$1"
  local app_id="$2"
  aerospace list-windows --workspace "$workspace" --app-id "$app_id" 2>/dev/null | wc -l | tr -d ' '
}

# Open app instances until target count is reached (idempotent)
# Usage: open_until_count workspace app_name app_id target_count
open_until_count() {
  local workspace="$1"
  local app_name="$2"
  local app_id="$3"
  local target="$4"

  local have
  have=$(get_window_count "$workspace" "$app_id")
  local need=$((target - have))

  if [ "$need" -le 0 ]; then
    echo "Already have $have/$target $app_name windows in workspace $workspace"
    return 0
  fi

  echo "Opening $need $app_name window(s) to reach target $target..."
  for _ in $(seq 1 "$need"); do
    act "open -na \"$app_name\""
    sleep 0.3
  done

  # Wait for windows to appear
  wait_until "[ \$(get_window_count $workspace $app_id) -ge $target ]" 15 ||
    echo "Warning: May not have reached target count"
}

# Export functions so they're available to scripts
export -f guard plan act wait_until get_window_count open_until_count
