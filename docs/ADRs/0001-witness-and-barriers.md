# ADR 0001: Witness Discipline and Safety Barriers

**Status:** Accepted
**Date:** 2025-10-15
**Author:** System Architecture Review

## Context

The mac_dev_setup repository automates macOS development environment configuration with powerful scripts that modify system state, install packages, and configure services. Without proper guardrails, these operations pose risks:

1. **Non-idempotent operations** creating duplicate windows/services
2. **Missing verification gates** allowing bad configs to ship
3. **Destructive changes** without dry-run or approval steps
4. **Secret leakage** through hardcoded credentials

## Decision

We adopt **witness discipline** and **safety barriers** as core architectural principles:

### 1. Witness Discipline

**Every change must carry proof it was verified:**

- **Pre-commit hooks** run linters (shellcheck, shfmt) and secret scanners (gitleaks)
- **CI pipeline** blocks merges on verification failures
- **Code review** requires explicit approval for high-impact changes

**Witnesses:**
- Static analysis (shellcheck, yaml-lint)
- Secret scanning (gitleaks)
- Format checking (shfmt)
- Manual review for system-modifying scripts

### 2. Safety Barriers

**Operations are gated by autonomy levels:**

```bash
AUTONOMY=0  # plan-only (default) - prints what would be done
AUTONOMY=1  # full-act - executes changes
```

**Barrier implementation:**
```bash
act() { [ "$AUTONOMY" -ge 1 ] && eval "$@" || echo "[PLAN] $@"; }
```

**Applied to:**
- Workspace initialization scripts
- System installers
- Service configuration
- LaunchAgent setup

### 3. Idempotency

**Scripts must be safe to re-run:**

- Check current state before acting
- Only create/modify missing resources
- Use readiness checks instead of sleeps
- Guard against race conditions

**Example:**
```bash
# Before: always opens 6 windows (duplicates on re-run)
for i in {1..6}; do open -na "Ghostty"; done

# After: only opens missing windows
target=6
have=$(aerospace list-windows ... | wc -l)
need=$((target - have))
for _ in $(seq 1 $need); do act 'open -na "Ghostty"'; done
```

### 4. Two-Handed Commits

**High-impact changes require explicit approval:**

- System configuration changes
- LaunchAgent installation
- Brew package installation
- File operations outside user directories

**Implemented via:**
- `DRYRUN=1` mode for installers
- Interactive prompts for destructive ops
- CI verification before merge

## Consequences

### Positive

✅ **Safer automation** - default to dry-run prevents accidents
✅ **Better quality** - linters catch bugs before commit
✅ **No secret leaks** - gitleaks blocks hardcoded credentials
✅ **Reproducible** - idempotent scripts can be re-run safely
✅ **Observable** - plan mode shows what would change

### Negative

⚠️ **Extra setup** - contributors must install pre-commit
⚠️ **Slower commits** - verification adds 2-3 seconds
⚠️ **Learning curve** - AUTONOMY slider requires documentation

### Mitigation

- Document setup in README
- Keep checks fast (< 5 seconds)
- Provide clear error messages
- Default to safe modes (AUTONOMY=0, DRYRUN=1)

## Implementation

### Phase 1: Verification (Complete)
- [x] Add .pre-commit-config.yaml
- [x] Create GitHub Actions workflow
- [x] Update .githooks/pre-commit to fail on errors

### Phase 2: Barriers (Complete)
- [x] Add AUTONOMY slider to workspace scripts
- [x] Add DRYRUN mode to install.sh
- [x] Make all scripts idempotent

### Phase 3: Documentation (Pending)
- [ ] Update README with new patterns
- [ ] Document AUTONOMY and DRYRUN usage
- [ ] Add troubleshooting for verification failures

## Invariants

These must hold at all times:

1. **No secrets in git** - verified by gitleaks pre-commit hook
2. **All shell scripts pass shellcheck** - enforced by CI
3. **Default to safe** - AUTONOMY=0, DRYRUN=1 by default
4. **Idempotent scripts** - safe to run multiple times
5. **Typed interfaces** - scripts accept --help, --dry-run flags

## References

- [Pre-commit framework](https://pre-commit.com/)
- [ShellCheck documentation](https://www.shellcheck.net/)
- [Gitleaks secret scanning](https://github.com/gitleaks/gitleaks)
- [Idempotency in automation](https://en.wikipedia.org/wiki/Idempotence)

## Revision History

- 2025-10-15: Initial ADR defining witness discipline and barriers
