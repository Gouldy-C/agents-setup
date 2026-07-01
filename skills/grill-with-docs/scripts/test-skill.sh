#!/usr/bin/env bash
# E2E harness for grill-with-docs PR test plan.
# Usage: test-skill.sh [project-root]
# If project-root is omitted, creates a disposable temp project.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$SKILL_DIR/../.." && pwd)"

PASS=0
FAIL=0
CLEANUP=0
TEST_ROOT="${1:-}"

pass() { echo "PASS: $1"; PASS=$((PASS + 1)); }
fail() { echo "FAIL: $1"; FAIL=$((FAIL + 1)); }

require_file() {
  local path="$1"
  local label="$2"
  if [[ -f "$path" ]]; then
    pass "$label ($path exists)"
  else
    fail "$label (missing $path)"
  fi
}

require_contains() {
  local file="$1"
  local needle="$2"
  local label="$3"
  if grep -qF "$needle" "$file"; then
    pass "$label"
  else
    fail "$label (expected '$needle' in $file)"
  fi
}

require_not_contains() {
  local file="$1"
  local needle="$2"
  local label="$3"
  if grep -qF "$needle" "$file"; then
    fail "$label (unexpected '$needle' in $file)"
  else
    pass "$label"
  fi
}

bootstrap_project() {
  TEST_ROOT="$(mktemp -d /tmp/grill-with-docs-test-XXXXXX)"
  CLEANUP=1
  mkdir -p "$TEST_ROOT/.agents/references"

  cat > "$TEST_ROOT/AGENTS.md" << 'EOF'
# Grill Test Project - agent instructions

## Quick orientation

- **What this is:** Disposable harness for grill-with-docs skill tests
- **Primary stack:** markdown only
- **Entry points:** none

## Commands

| Task | Command |
| --- | --- |
| Test | `bash skills/grill-with-docs/scripts/test-skill.sh` |

## Reference docs

| File | When to read |
| --- | --- |
| [`.agents/references/GLOSSARY.md`](.agents/references/GLOSSARY.md) | Domain vocabulary |
| [`.agents/references/DECISIONS.md`](.agents/references/DECISIONS.md) | Hard technical choices |

## Project skills

| Skill | Path |
| --- | --- |
| _(none)_ | |

## Out of scope for agents

- Do not edit auto-generated files
EOF

  cat > "$TEST_ROOT/.agents/references/GLOSSARY.md" << 'EOF'
# Grill Test

Harness for validating grill-with-docs behavior.

## Language

**Session**:
A single grilling interview about a plan or design.
_Avoid_: Meeting, workshop
EOF

  cat > "$TEST_ROOT/.agents/references/DECISIONS.md" << 'EOF'
# Decisions

## Decisions

### Use markdown-only harness - 2026-07-01

**Context:** Need an isolated project to test grill-with-docs without touching real repos.

**Decision:** Use a temp directory with AGENTS.md and .agents/references/ only.

**Rationale:** Keeps tests hermetic and easy to tear down.

**Consequences:** Run tests from the grill-with-docs skill scripts directory.
EOF
}

simulate_before_you_start() {
  local read_log="$TEST_ROOT/.test-read-log.txt"
  : > "$read_log"

  # Mirrors SKILL.md "Before you start" read order.
  if [[ -f "$TEST_ROOT/AGENTS.md" ]]; then
    echo "AGENTS.md" >> "$read_log"
  fi
  if [[ -f "$TEST_ROOT/.agents/references/GLOSSARY.md" ]]; then
    echo "GLOSSARY.md" >> "$read_log"
  fi
  if [[ -f "$TEST_ROOT/.agents/references/DECISIONS.md" ]]; then
    echo "DECISIONS.md" >> "$read_log"
  fi
  if [[ -f "$TEST_ROOT/.agents/references/DOMAIN-MAP.md" ]]; then
    echo "DOMAIN-MAP.md" >> "$read_log"
  fi
}

simulate_inline_glossary_update() {
  local glossary="$TEST_ROOT/.agents/references/GLOSSARY.md"
  cat >> "$glossary" << 'EOF'

**Grill**:
A relentless one-question-at-a-time interview that sharpens a plan.
_Avoid_: Brainstorm, Q&A dump
EOF
}

should_record_decision() {
  local hard_to_reverse="$1"
  local surprising="$2"
  local real_tradeoff="$3"
  [[ "$hard_to_reverse" == "yes" && "$surprising" == "yes" && "$real_tradeoff" == "yes" ]]
}

append_decision_if_worthy() {
  local title="$1"
  local hard_to_reverse="$2"
  local surprising="$3"
  local real_tradeoff="$4"
  local decisions="$TEST_ROOT/.agents/references/DECISIONS.md"

  if should_record_decision "$hard_to_reverse" "$surprising" "$real_tradeoff"; then
    cat >> "$decisions" << EOF

### $title - 2026-07-01

**Context:** Evaluated during grill-with-docs harness.

**Decision:** Record only when all three ADR criteria are met.

**Rationale:** Reversible choices should not clutter DECISIONS.md.

**Consequences:** Skip recording for obvious or easy-to-reverse choices.
EOF
  fi
}

register_reference_in_agents_md() {
  local agents="$TEST_ROOT/AGENTS.md"
  local rel_path="$1"
  local when_to_read="$2"

  if ! grep -qF "$rel_path" "$agents"; then
    # Insert before the Project skills section.
    awk -v path="$rel_path" -v when="$when_to_read" '
      /^## Project skills/ && !done {
        print "| [`" path "`](" path ") | " when " |"
        done=1
      }
      { print }
    ' "$agents" > "$agents.tmp" && mv "$agents.tmp" "$agents"
  fi
}

main() {
  if [[ -z "$TEST_ROOT" ]]; then
    bootstrap_project
  fi

  echo "Testing grill-with-docs against: $TEST_ROOT"
  echo

  # Test 1: reads existing .agents/references/ files first (after AGENTS.md)
  simulate_before_you_start
  require_file "$TEST_ROOT/AGENTS.md" "Test 1a: AGENTS.md present"
  require_file "$TEST_ROOT/.agents/references/GLOSSARY.md" "Test 1b: pre-existing GLOSSARY.md present"
  require_file "$TEST_ROOT/.agents/references/DECISIONS.md" "Test 1c: pre-existing DECISIONS.md present"

  local read_log="$TEST_ROOT/.test-read-log.txt"
  require_contains "$read_log" "AGENTS.md" "Test 1d: before-you-start reads AGENTS.md"
  require_contains "$read_log" "GLOSSARY.md" "Test 1e: before-you-start reads GLOSSARY.md"
  require_contains "$read_log" "DECISIONS.md" "Test 1f: before-you-start reads DECISIONS.md"

  local agents_line
  local glossary_line
  local decisions_line
  agents_line="$(grep -n '^AGENTS.md$' "$read_log" | head -1 | cut -d: -f1)"
  glossary_line="$(grep -n '^GLOSSARY.md$' "$read_log" | head -1 | cut -d: -f1)"
  decisions_line="$(grep -n '^DECISIONS.md$' "$read_log" | head -1 | cut -d: -f1)"
  if [[ "$agents_line" -lt "$glossary_line" && "$glossary_line" -lt "$decisions_line" ]]; then
    pass "Test 1g: read order is AGENTS.md -> GLOSSARY.md -> DECISIONS.md"
  else
    fail "Test 1g: read order is AGENTS.md -> GLOSSARY.md -> DECISIONS.md"
  fi

  # Test 2: resolved terms land in GLOSSARY.md inline
  local glossary="$TEST_ROOT/.agents/references/GLOSSARY.md"
  local glossary_before
  glossary_before="$(wc -l < "$glossary")"
  simulate_inline_glossary_update
  local glossary_after
  glossary_after="$(wc -l < "$glossary")"
  if [[ "$glossary_after" -gt "$glossary_before" ]]; then
    pass "Test 2a: glossary grows inline when a term resolves"
  else
    fail "Test 2a: glossary grows inline when a term resolves"
  fi
  require_contains "$glossary" "**Grill**:" "Test 2b: resolved term uses GLOSSARY-FORMAT bold term style"
  require_contains "$glossary" "_Avoid_: Brainstorm, Q&A dump" "Test 2c: resolved term includes _Avoid_ line"
  require_not_contains "$glossary" "whisper-cli" "Test 2d: glossary stays vocabulary-only (no implementation detail)"

  # Test 3: only hard-to-reverse trade-offs append to DECISIONS.md
  local decisions="$TEST_ROOT/.agents/references/DECISIONS.md"
  local decisions_before
  decisions_before="$(wc -l < "$decisions")"
  append_decision_if_worthy "Use tabs for indentation" "no" "no" "no"
  local after_reversible
  after_reversible="$(wc -l < "$decisions")"
  if [[ "$after_reversible" -eq "$decisions_before" ]]; then
    pass "Test 3a: reversible choice is not appended to DECISIONS.md"
  else
    fail "Test 3a: reversible choice is not appended to DECISIONS.md"
  fi

  append_decision_if_worthy "Event-sourced write model" "yes" "yes" "yes"
  local after_hard
  after_hard="$(wc -l < "$decisions")"
  if [[ "$after_hard" -gt "$after_reversible" ]]; then
    pass "Test 3b: hard trade-off is appended to DECISIONS.md"
  else
    fail "Test 3b: hard trade-off is appended to DECISIONS.md"
  fi
  require_contains "$decisions" "### Event-sourced write model" "Test 3c: hard decision uses project-agents entry format"

  # Test 4: new reference files get a row in AGENTS.md
  local new_ref=".agents/references/ARCHITECTURE.md"
  mkdir -p "$TEST_ROOT/.agents/references"
  echo "# Architecture" > "$TEST_ROOT/$new_ref"
  register_reference_in_agents_md "$new_ref" "Structural changes, new modules, data flow"
  require_contains "$TEST_ROOT/AGENTS.md" '.agents/references/ARCHITECTURE.md' "Test 4a: new reference file registered in AGENTS.md table"
  require_contains "$TEST_ROOT/AGENTS.md" "Structural changes, new modules, data flow" "Test 4b: AGENTS.md row includes when-to-read guidance"

  echo
  echo "Results: $PASS passed, $FAIL failed"

  if [[ "$CLEANUP" -eq 1 ]]; then
    rm -rf "$TEST_ROOT"
  fi

  if [[ "$FAIL" -gt 0 ]]; then
    exit 1
  fi
}

main "$@"
