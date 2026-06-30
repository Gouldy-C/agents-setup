#!/usr/bin/env bash
# Validate project agent structure.
# Usage: validate-project-agents.sh [project-root]
# Exit 0 when valid; non-zero with messages when gaps exist.

set -euo pipefail

ROOT="${1:-.}"
errors=0

warn() {
  echo "WARN: $*" >&2
}

fail() {
  echo "ERROR: $*" >&2
  errors=$((errors + 1))
}

if [[ ! -d "$ROOT" ]]; then
  echo "ERROR: not a directory: $ROOT" >&2
  exit 1
fi

# Required: root AGENTS.md
if [[ ! -f "$ROOT/AGENTS.md" ]]; then
  fail "missing AGENTS.md at project root"
fi

# Required: .agents/README.md
if [[ ! -f "$ROOT/.agents/README.md" ]]; then
  fail "missing .agents/README.md"
fi

# Required: references directory
if [[ ! -d "$ROOT/.agents/references" ]]; then
  fail "missing .agents/references/"
fi

# Required reference files
for ref in ARCHITECTURE.md STACK.md CONVENTIONS.md RUNBOOK.md DECISIONS.md; do
  if [[ ! -f "$ROOT/.agents/references/$ref" ]]; then
    fail "missing .agents/references/$ref"
  fi
done

# Skills directory (may be empty)
if [[ ! -d "$ROOT/.agents/skills" ]]; then
  fail "missing .agents/skills/ (create empty directory if no skills yet)"
fi

# AGENTS.md should point at .agents/references
if [[ -f "$ROOT/AGENTS.md" ]] && ! grep -q '.agents/references' "$ROOT/AGENTS.md"; then
  fail "AGENTS.md should link to .agents/references/"
fi

# AGENTS.md should not be huge (soft check)
if [[ -f "$ROOT/AGENTS.md" ]]; then
  line_count=$(wc -l < "$ROOT/AGENTS.md" | tr -d ' ')
  if [[ "$line_count" -gt 120 ]]; then
    warn "AGENTS.md is $line_count lines - consider moving prose into .agents/references/"
  fi
fi

# .gitignore should cover local agent overrides (soft check)
if [[ -f "$ROOT/.gitignore" ]]; then
  if ! grep -qE '\.agents/.*\.local\.md|\.agents/\*\.local\.md' "$ROOT/.gitignore"; then
    warn ".gitignore should include .agents/*.local.md for machine-specific overrides"
  fi
else
  warn "no .gitignore found - add .agents/*.local.md when you create one"
fi

if [[ "$errors" -gt 0 ]]; then
  echo "" >&2
  echo "$errors error(s) found." >&2
  exit 1
fi

echo "OK: project agent structure is valid."
exit 0
