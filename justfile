default: help

set shell := ["bash", "-euo", "pipefail", "-c"]

# Show available commands
help:
    @just --list

# Install development environment (DRYRUN=1 for plan-only, DRYRUN=0 to execute)
install DRYRUN="1":
    DRYRUN={{DRYRUN}} scripts/install.sh

# Setup AeroSpace workspace automation (AUTONOMY=0 for plan, AUTONOMY=1 to execute)
aero AUTONOMY="0":
    AUTONOMY={{AUTONOMY}} scripts/setup_aerospace_automation.sh

# Setup git hooks for automatic verification
hooks:
    scripts/setup_git_hooks.sh

# Run all verification checks (linters, secret scanning, etc.)
verify:
    pre-commit run --all-files

# Generate directory context for LLMs
context:
    scripts/generate_context.sh

# Initialize all AeroSpace workspaces (AUTONOMY=0 for plan, AUTONOMY=1 to execute)
init-workspaces AUTONOMY="0":
    AUTONOMY={{AUTONOMY}} ~/.config/aerospace/scripts/init_all_workspaces.sh

# Initialize specific workspace (AUTONOMY=0 for plan, AUTONOMY=1 to execute)
init-workspace WS AUTONOMY="0":
    AUTONOMY={{AUTONOMY}} ~/.config/aerospace/scripts/init_workspace_{{WS}}.sh

# Format all shell scripts
format:
    shfmt -i 2 -s -ci -w scripts/ configs/desktop/aerospace_scripts/

# Check shell scripts for errors
lint:
    shellcheck scripts/*.sh configs/desktop/aerospace_scripts/*.sh

# Update all dependencies
update:
    brew update && brew upgrade && brew cleanup
    mise upgrade
    pipx upgrade-all
    pre-commit autoupdate
