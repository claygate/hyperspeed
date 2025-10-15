# Git Hooks

This directory contains custom git hooks for the mac_dev_setup repository.

## Setup

To enable these hooks, run:

```bash
./scripts/setup_git_hooks.sh
```

This configures git to use `.githooks/` instead of the default `.git/hooks/` directory.

## Available Hooks

### pre-commit

**Purpose:** Automatically regenerates `DIRECTORY_CONTEXT.md` before each commit.

**What it does:**
1. Runs `scripts/generate_context.sh`
2. Updates `DIRECTORY_CONTEXT.md` with current repository state
3. Automatically stages the updated context file
4. Ensures the context is always current in the repository

**Why:** This keeps the LLM context file synchronized with repository changes, making it easy to provide up-to-date context to external LLMs.

## Disabling Hooks

To temporarily disable all hooks:
```bash
git config --unset core.hooksPath
```

To re-enable:
```bash
git config core.hooksPath .githooks
```

To skip hooks for a single commit:
```bash
git commit --no-verify
```

## Adding New Hooks

1. Create a new executable script in `.githooks/` (e.g., `pre-push`, `commit-msg`, etc.)
2. Make it executable: `chmod +x .githooks/your-hook`
3. The hook will automatically be used on the next git operation

## Standard Git Hooks

Available git hooks you can create:
- `pre-commit` - Run before commit is created
- `prepare-commit-msg` - Edit default commit message
- `commit-msg` - Validate commit message
- `post-commit` - Run after commit is created
- `pre-push` - Run before push
- `post-merge` - Run after merge
- `post-checkout` - Run after checkout

See: https://git-scm.com/docs/githooks
