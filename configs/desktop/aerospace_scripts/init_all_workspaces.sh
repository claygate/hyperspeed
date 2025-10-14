#!/usr/bin/env bash
# Initialize all workspaces automatically

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "AeroSpace Workspace Initialization"
echo "=========================================="
echo ""

# Array of workspace scripts to run
WORKSPACES=(1 2 3 4 5 6 7)

for ws in "${WORKSPACES[@]}"; do
    echo ""
    echo ">>> Initializing Workspace ${ws}..."
    if [ -f "${SCRIPT_DIR}/init_workspace_${ws}.sh" ]; then
        bash "${SCRIPT_DIR}/init_workspace_${ws}.sh"
        echo "    ✓ Workspace ${ws} initialized"
        # Small delay between workspaces
        sleep 2
    else
        echo "    ✗ Script not found for workspace ${ws}"
    fi
done

echo ""
echo "=========================================="
echo "All workspaces initialized!"
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
