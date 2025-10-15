#!/usr/bin/env bash
# Generate DIRECTORY_CONTEXT.md for external LLM context
# This script concatenates all files in the repository (respecting .gitignore)
# into a single markdown file for easy copy-paste to LLMs

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get to repository root
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
cd "$REPO_ROOT"

OUTPUT_FILE="DIRECTORY_CONTEXT.md"

echo -e "${YELLOW}Generating directory context...${NC}"

# Start the output file
cat > "$OUTPUT_FILE" <<'EOF'
# Directory Context for LLM

This file contains the complete contents of the mac_dev_setup repository.
Generated for providing full context to external LLMs.

---

## Directory Tree

```
EOF

# Generate directory tree (excluding .git and respecting .gitignore)
echo "Generating directory tree..."
if command -v tree >/dev/null 2>&1; then
    tree -a -I '.git' --gitignore >> "$OUTPUT_FILE"
else
    # Fallback if tree is not installed
    find . -path ./.git -prune -o -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g' >> "$OUTPUT_FILE"
fi

cat >> "$OUTPUT_FILE" <<'EOF'
```

---

## File Contents

Each file is separated by a header showing its path.

---

EOF

# Get list of all files, respecting .gitignore
echo "Collecting files..."
if command -v git >/dev/null 2>&1 && [ -d .git ]; then
    # Use git ls-files if in a git repo (respects .gitignore)
    FILES=$(git ls-files)
else
    # Fallback: use find (won't respect .gitignore as well)
    FILES=$(find . -type f -not -path '*/\.git/*' -not -name '.DS_Store')
fi

# Counter for progress
TOTAL_FILES=$(echo "$FILES" | wc -l | tr -d ' ')
CURRENT=0

# Iterate through each file
while IFS= read -r file; do
    CURRENT=$((CURRENT + 1))
    echo -ne "\rProcessing files: $CURRENT/$TOTAL_FILES"

    # Skip the output file itself and the script
    if [[ "$file" == "$OUTPUT_FILE" ]] || [[ "$file" == "scripts/generate_context.sh" ]]; then
        continue
    fi

    # Skip binary files and very large files
    if file "$file" | grep -q 'text'; then
        # Check file size (skip if larger than 1MB)
        FILE_SIZE=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0)
        if [ "$FILE_SIZE" -lt 1048576 ]; then
            # Add file header
            # shellcheck disable=SC2129
            cat >> "$OUTPUT_FILE" <<EOF

### File: \`$file\`

\`\`\`
EOF
            # Add file contents
            cat "$file" >> "$OUTPUT_FILE"

            # Close code block
            cat >> "$OUTPUT_FILE" <<'EOF'
```

---

EOF
        else
            # Note that file was skipped
            cat >> "$OUTPUT_FILE" <<EOF

### File: \`$file\`

_[Skipped: File too large ($(numfmt --to=iec "$FILE_SIZE" 2>/dev/null || echo "$FILE_SIZE bytes"))]_

---

EOF
        fi
    fi
done <<< "$FILES"

echo -e "\n"

# Add metadata at the end
cat >> "$OUTPUT_FILE" <<EOF

---

## Generation Metadata

- **Generated:** $(date '+%Y-%m-%d %H:%M:%S')
- **Repository:** $(basename "$REPO_ROOT")
- **Files processed:** $TOTAL_FILES
- **Generator:** scripts/generate_context.sh

---

## Usage

This file is intended to be copy-pasted into LLM conversations for full repository context.

**Tips:**
1. Some LLMs have token limits - check the file size before pasting
2. You can remove unnecessary sections if needed
3. Regenerate this file after significant changes: \`./scripts/generate_context.sh\`

EOF

# Calculate file size
if command -v numfmt >/dev/null 2>&1; then
    SIZE=$(stat -f%z "$OUTPUT_FILE" 2>/dev/null || stat -c%s "$OUTPUT_FILE")
    SIZE_HUMAN=$(numfmt --to=iec "$SIZE")
else
    SIZE_HUMAN=$(du -h "$OUTPUT_FILE" | cut -f1)
fi

echo -e "${GREEN}✓ Context file generated successfully!${NC}"
echo ""
echo "Output: $OUTPUT_FILE"
echo "Size: $SIZE_HUMAN"
echo ""
echo "You can now copy the contents of $OUTPUT_FILE to provide full repository context to an LLM."

exit 0
