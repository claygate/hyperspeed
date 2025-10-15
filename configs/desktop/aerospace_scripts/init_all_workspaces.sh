#!/usr/bin/env bash
# Initialize all workspaces automatically

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "AeroSpace Workspace Initialization"
echo "=========================================="
echo ""

# Pass through AUTONOMY environment variable
export AUTONOMY="${AUTONOMY:-0}"

if [ "$AUTONOMY" -eq 0 ]; then
  echo "Running in PLAN mode (AUTONOMY=0)"
  echo "Set AUTONOMY=1 to execute changes"
  echo ""
fi

# Array of workspace scripts to run
WORKSPACES=(1 2 3 4 5 6 7)

for ws in "${WORKSPACES[@]}"; do
  script_path="${SCRIPT_DIR}/init_workspace_${ws}.sh"

  echo ""
  echo ">>> Initializing Workspace ${ws}..."

  if [ ! -x "$script_path" ]; then
    echo "    ✗ Script not found or not executable: $script_path"
    continue
  fi

  # Run script and handle failures gracefully
  if AUTONOMY="$AUTONOMY" bash "$script_path"; then
    echo "    ✓ Workspace ${ws} initialized"
  else
    echo "    ✗ Workspace ${ws} failed (continuing anyway)"
  fi

  # Small delay between workspaces to avoid race conditions
  if [ "$AUTONOMY" -ge 1 ]; then
    sleep 2
  fi
done

echo ""
echo "=========================================="
if [ "$AUTONOMY" -eq 0 ]; then
  echo "Planning complete! Run with AUTONOMY=1 to execute."
else
  echo "All workspaces initialized!"
fi
echo "Workspace 8 left empty for flexible use"
echo "=========================================="
echo ""
echo "Quick reference:"
echo "  Workspace 1: Terminal Grid (6 Ghostty)"
echo "  Workspace 2: Terminal Grid (6 Ghostty)"
echo "  Workspace 3: Mixed (2 Ghostty + 2 Chrome)"
echo "  Workspace 4: Full Screen Safari"
echo "  Workspace 5: Chrome Grid (6 Chrome)"
echo "  Workspace 6: Development (VSCode + 2 Chrome)"
echo "  Workspace 7: Full Screen Tmux"
echo "  Workspace 8: Empty / Flexible"
echo ""
echo "Use Alt+1 through Alt+8 to switch workspaces"
echo "Use Alt+i then 'a' to re-run this script"
