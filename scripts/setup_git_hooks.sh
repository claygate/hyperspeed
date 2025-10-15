#!/usr/bin/env bash
# Setup git hooks for this repository
# This script installs custom git hooks from .githooks/ directory

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Setting up git hooks...${NC}"

# Get repository root
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "Error: Not in a git repository"
    exit 1
}

cd "$REPO_ROOT"

# Check if .githooks directory exists
if [ ! -d ".githooks" ]; then
    echo "Error: .githooks directory not found"
    exit 1
fi

# Configure git to use .githooks directory
echo "Configuring git to use .githooks directory..."
git config core.hooksPath .githooks

# Make all hooks executable
echo "Making hooks executable..."
chmod +x .githooks/*

echo -e "${GREEN}✓ Git hooks installed successfully!${NC}"
echo ""
echo "Installed hooks:"
ls -1 .githooks/
echo ""
echo "Hooks will now run automatically with git operations."
echo ""
echo "To disable: git config --unset core.hooksPath"
echo "To re-enable: git config core.hooksPath .githooks"
