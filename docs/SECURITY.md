# Security Guide

## Secret Management

**Never commit secrets to git.** This repository uses secure secret management:

### API Keys and Credentials

Secrets are stored in macOS Keychain, not in files:

```bash
# Store a secret
security add-generic-password -a "$USER" -s SECRET_NAME -w 'secret-value' -U

# Retrieve in shell (automatic via .zshrc)
export API_KEY="${API_KEY:-$(security find-generic-password -w -s API_KEY 2>/dev/null || true)}"
```

### Rotating Leaked Secrets

If a secret was committed:

1. **Rotate immediately** - invalidate the old secret
2. **Purge from history**:
   ```bash
   # Option 1: BFG Repo-Cleaner (recommended)
   bfg --replace-text secrets.txt repo.git

   # Option 2: git-filter-repo
   git filter-repo --path configs/shell/zshrc --invert-paths
   ```
3. **Force push** (coordinate with team):
   ```bash
   git push --force-with-lease
   ```
4. **Notify** affected systems/users

### Pre-commit Secret Scanning

Gitleaks runs automatically on every commit:

```bash
# Manual scan
just verify

# Or directly
pre-commit run gitleaks --all-files
```

**Blocked patterns:**
- API keys (OpenAI, AWS, etc.)
- Private keys (SSH, PGP)
- Passwords and tokens
- Connection strings with credentials

### Emergency: Bypass for False Positives

```bash
# Skip pre-commit hooks (use sparingly)
git commit --no-verify -m "message"
```

## Safe Defaults

### AUTONOMY Slider

Scripts default to plan-only mode:

```bash
# Safe: shows what would happen
AUTONOMY=0 just init-workspaces

# Execute changes
AUTONOMY=1 just init-workspaces
```

### DRYRUN Mode

Installers default to dry-run:

```bash
# Safe: shows what would be installed
DRYRUN=1 just install

# Execute installation
DRYRUN=0 just install
```

## Verification Gates

### Pre-commit Checks

Every commit is verified:

- ✅ ShellCheck (shell script linting)
- ✅ shfmt (shell formatting)
- ✅ Gitleaks (secret scanning)
- ✅ Trailing whitespace/EOF fixes

### CI Pipeline

Pull requests are blocked until:

- ✅ All pre-commit hooks pass
- ✅ No secrets detected
- ✅ Shell scripts pass linting

## Reporting Security Issues

**Do not** open public issues for security vulnerabilities.

Instead:
1. Rotate affected secrets immediately
2. Contact maintainer privately
3. Allow time for fix before disclosure

## Best Practices

1. **Never hardcode secrets** - use environment variables or Keychain
2. **Use DRYRUN/AUTONOMY=0** for testing scripts
3. **Review diffs** before committing (`git diff --cached`)
4. **Enable pre-commit hooks** (`just hooks`)
5. **Rotate secrets periodically** (every 90 days)
6. **Audit access** to systems using these configs

## Threat Model

### In Scope

- ✅ Secret leakage via git commits
- ✅ Destructive automation without approval
- ✅ Malicious code injection via scripts
- ✅ Privilege escalation via LaunchAgents

### Out of Scope

- ⚠️ Physical access to unlocked machine
- ⚠️ Compromised package managers (brew, npm)
- ⚠️ OS-level vulnerabilities
- ⚠️ Supply chain attacks on dependencies

## Incident Response

If secrets are exposed:

1. **Contain**: Rotate all affected secrets immediately
2. **Assess**: Determine scope of exposure
3. **Remediate**: Purge from git history, update systems
4. **Document**: Record in incident log
5. **Prevent**: Add to gitleaks config if pattern missed

---

**Last Updated:** 2025-10-15
**Security Contact:** See README for maintainer contact
