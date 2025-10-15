# Git Hooks Documentation

This repository uses custom git hooks to automate maintenance tasks.

## Overview

Git hooks are scripts that run automatically at specific points in the git workflow. This repository uses hooks to keep the `DIRECTORY_CONTEXT.md` file synchronized with repository changes.

## What Was Set Up

### 1. Directory Structure

```
.githooks/
├── pre-commit       # Hook that runs before each commit
└── README.md        # Hook documentation

scripts/
├── generate_context.sh    # Generates DIRECTORY_CONTEXT.md
└── setup_git_hooks.sh     # One-time setup script
```

### 2. Pre-Commit Hook

**File:** `.githooks/pre-commit`

**Runs:** Automatically before every commit

**What it does:**
1. Executes `scripts/generate_context.sh`
2. Regenerates `DIRECTORY_CONTEXT.md` with current repository state
3. Automatically stages the updated context file
4. Commits include the latest context

**Output Example:**
```
🔄 Regenerating directory context...
✓ Directory context updated and staged
```

### 3. Context Generation Script

**File:** `scripts/generate_context.sh`

**Purpose:** Creates a complete repository snapshot for LLM context

**What it includes:**
- Directory tree structure
- All file contents (respecting .gitignore)
- File separators and headers
- Generation metadata

**Manual Usage:**
```bash
./scripts/generate_context.sh
```

**Output:** `DIRECTORY_CONTEXT.md` (~132KB)

### 4. Hook Setup Script

**File:** `scripts/setup_git_hooks.sh`

**Purpose:** One-time installation of git hooks

**What it does:**
1. Configures git to use `.githooks/` directory
2. Makes all hooks executable
3. Displays installed hooks

**Usage:**
```bash
./scripts/setup_git_hooks.sh
```

## How It Works

### Normal Workflow

```bash
# Make changes to files
vim README.md

# Stage changes
git add README.md

# Commit (hook runs automatically)
git commit -m "Update README"
```

**What happens:**
1. You run `git commit`
2. Pre-commit hook triggers
3. `DIRECTORY_CONTEXT.md` is regenerated
4. Updated context file is staged
5. Commit proceeds with your changes + updated context

### First-Time Setup (Already Done)

The hooks are already configured for this repository. For new clones:

```bash
# Clone the repository
git clone <repo-url>

# Setup hooks
./scripts/setup_git_hooks.sh
```

## Managing Hooks

### Check Hook Status

```bash
# See which hooks directory is active
git config core.hooksPath

# Output: .githooks
```

### Temporarily Disable All Hooks

```bash
# Disable
git config --unset core.hooksPath

# Re-enable
git config core.hooksPath .githooks
```

### Skip Hooks for One Commit

```bash
# Use --no-verify flag
git commit --no-verify -m "Quick fix"
```

**When to use:**
- Emergency fixes
- Work-in-progress commits
- When context generation fails

### Manual Context Generation

```bash
# Generate context without committing
./scripts/generate_context.sh

# View the generated file
less DIRECTORY_CONTEXT.md
```

## Benefits

### 1. Always Up-to-Date Context
Every commit includes the current repository state in `DIRECTORY_CONTEXT.md`, making it trivial to provide complete context to external LLMs.

### 2. No Manual Steps
Developers don't need to remember to regenerate the context file - it happens automatically.

### 3. Git History Shows Full Context
Each commit includes the full repository context at that point in time, useful for debugging and understanding changes.

### 4. Easy LLM Integration
Copy `DIRECTORY_CONTEXT.md` directly into LLM conversations for complete repository awareness.

## Troubleshooting

### Hook Not Running

**Check if hooks are enabled:**
```bash
git config core.hooksPath
```

**Should output:** `.githooks`

**If empty, run:**
```bash
./scripts/setup_git_hooks.sh
```

### Hook Fails

**Symptoms:**
- Commit aborted
- Error message about generate_context.sh

**Solutions:**

1. **Script not executable:**
```bash
chmod +x scripts/generate_context.sh
chmod +x .githooks/pre-commit
```

2. **Script not found:**
```bash
# Verify script exists
ls -l scripts/generate_context.sh

# Re-create if necessary
git checkout scripts/generate_context.sh
```

3. **Skip problematic commit:**
```bash
git commit --no-verify -m "Your message"
```

### Context File Too Large

**If DIRECTORY_CONTEXT.md becomes very large:**

1. **Check file size:**
```bash
du -h DIRECTORY_CONTEXT.md
```

2. **Modify generation script to exclude large files:**
Edit `scripts/generate_context.sh` and adjust the size threshold:
```bash
# Current: 1MB
if [ "$FILE_SIZE" -lt 1048576 ]; then

# Change to 500KB
if [ "$FILE_SIZE" -lt 524288 ]; then
```

3. **Exclude specific directories:**
Add to `.gitignore`:
```
large-data/
assets/images/
```

### Hook Runs But Doesn't Stage Context

**Check hook permissions:**
```bash
ls -l .githooks/pre-commit
# Should show: -rwxr-xr-x
```

**Check hook contents:**
```bash
cat .githooks/pre-commit
# Should include: git add DIRECTORY_CONTEXT.md
```

## Advanced Usage

### Adding More Hooks

Create new hooks in `.githooks/` directory:

```bash
# Example: pre-push hook
cat > .githooks/pre-push <<'EOF'
#!/usr/bin/env bash
echo "Running tests before push..."
npm test
EOF

chmod +x .githooks/pre-push
```

### Conditional Context Generation

Modify `.githooks/pre-commit` to only regenerate for certain files:

```bash
#!/usr/bin/env bash
# Only regenerate if code files changed

CHANGED_FILES=$(git diff --cached --name-only)

if echo "$CHANGED_FILES" | grep -E '\.(sh|md|toml|json|lua)$' > /dev/null; then
    echo "🔄 Code files changed, regenerating context..."
    ./scripts/generate_context.sh > /dev/null 2>&1
    git add DIRECTORY_CONTEXT.md
fi
```

### Hook Logging

Add logging to debug hook behavior:

```bash
# In .githooks/pre-commit
LOG_FILE="/tmp/git-hooks.log"
echo "[$(date)] Pre-commit hook running" >> "$LOG_FILE"
./scripts/generate_context.sh >> "$LOG_FILE" 2>&1
```

## Best Practices

### 1. Keep Hooks Fast
- Pre-commit hooks should complete in < 5 seconds
- Current context generation: ~1-2 seconds
- For slower operations, use `post-commit` hooks

### 2. Handle Failures Gracefully
- Hooks should exit 0 (success) even if non-critical operations fail
- Use warning messages instead of blocking commits
- Reserve exit 1 for critical failures only

### 3. Make Hooks Optional
- Always provide `--no-verify` option documentation
- Don't force hooks on contributors (they run `setup_git_hooks.sh` if desired)
- Keep hooks in `.githooks/` not `.git/hooks/` (easier to version control)

### 4. Document Everything
- Each hook should have comments explaining what it does
- Maintain this documentation file
- Include setup instructions in README

## Integration with CI/CD

The context file can be used in automated workflows:

```yaml
# .github/workflows/context-check.yml
name: Verify Context

on: [pull_request]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Regenerate context
        run: ./scripts/generate_context.sh
      - name: Check if context is current
        run: |
          if ! git diff --quiet DIRECTORY_CONTEXT.md; then
            echo "Error: DIRECTORY_CONTEXT.md is out of date"
            exit 1
          fi
```

## Files Modified by Hooks

The following files are automatically generated/modified:

- `DIRECTORY_CONTEXT.md` - Regenerated on every commit

These files should be committed to the repository to keep them in sync.

## Uninstalling Hooks

To completely remove hooks:

```bash
# Disable hooks directory
git config --unset core.hooksPath

# Optional: Remove hook files
rm -rf .githooks/
rm scripts/generate_context.sh
rm scripts/setup_git_hooks.sh
rm DIRECTORY_CONTEXT.md
```

## Resources

- [Git Hooks Documentation](https://git-scm.com/docs/githooks)
- [Pro Git Book - Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks)
- [Atlassian Git Hooks Tutorial](https://www.atlassian.com/git/tutorials/git-hooks)

---

**Last Updated:** 2025-10-15
**Maintained By:** Peter Campbell Clarke
