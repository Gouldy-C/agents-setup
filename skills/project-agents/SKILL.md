---
name: project-agents
description: >-
  Bootstrap and maintain project-level agent structure following the agents.md
  open format: a thin root AGENTS.md plus a .agents/ directory for references
  and project-only skills. Keeps global ~/.agents separate from per-repo context.
  Use when creating or updating AGENTS.md, scaffolding .agents/, writing agent
  onboarding docs, refactoring an oversized AGENTS.md, adding project-only
  skills, or when the user asks to set up agent files for a repository.
---

# Project Agents

Set up and maintain **project-level** agent files in any repository.
Global personal standards live in `~/.agents/` and are already available everywhere - do not copy them into projects.

## The paradigm

Every project uses two layers:

```text
project-root/
├── AGENTS.md              # Thin index - always loaded by Cursor
└── .agents/
    ├── README.md          # What lives here
    ├── references/        # Heavy docs - read on demand
    │   ├── ARCHITECTURE.md
    │   ├── STACK.md
    │   ├── CONVENTIONS.md
    │   ├── RUNBOOK.md
    │   └── DECISIONS.md
    ├── skills/            # Project-only skills
    └── .skill-lock.json   # Optional - project skill provenance
```

**Global vs project:**

| Layer | Location | Scope |
| --- | --- | --- |
| Global | `~/.agents/` | Personal standards, voice, opinions, global skills |
| Project | `AGENTS.md` + `.agents/` | Repo architecture, commands, conventions, project skills |

Project instructions override global ones on repo-specific matters.
Never symlink a project's `AGENTS.md` to `~/.agents/AGENTS.md`.

## Before you start

1. Confirm you are in the **target project root** (not `~/.agents`).
2. Read existing `AGENTS.md` and `.agents/` if present.
3. Inspect the repo to infer stack, entry points, and commands (`package.json`, `Cargo.toml`, `pyproject.toml`, `CMakeLists.txt`, etc.).

Templates live in [references/templates/](references/templates/).
Content principles (agents.md format, command quality, monorepos) live in [references/agents-md-guide.md](references/agents-md-guide.md).
Read a template or the guide only when you need them.

## Mode selection

| Situation | Mode |
| --- | --- |
| No `AGENTS.md` or no `.agents/` | **Bootstrap** |
| `AGENTS.md` exists but is bloated or unstructured | **Refactor** |
| Structure exists, user wants additions | **Update** |
| User asks for a project skill | **Add skill** |

---

## Bootstrap workflow

Copy this checklist and track progress:

```text
- [ ] Step 1: Create .agents/ tree
- [ ] Step 2: Write reference stubs from repo inspection
- [ ] Step 3: Write thin root AGENTS.md
- [ ] Step 4: Update .gitignore for local overrides
- [ ] Step 5: Validate structure
```

### Step 1: Create `.agents/` tree

```bash
mkdir -p .agents/references .agents/skills
```

Create `.agents/README.md` from [references/templates/agents-readme.md](references/templates/agents-readme.md).

### Step 2: Write reference stubs

Follow [references/agents-md-guide.md](references/agents-md-guide.md) for what belongs in each file and content quality rules.
Create each file under `.agents/references/` from the matching template.
Fill in real content by inspecting the repo - do not leave placeholder lorem ipsum.
Verify every command you write actually works.

| File | Source template | Fill from |
| --- | --- | --- |
| `ARCHITECTURE.md` | [architecture.md](references/templates/architecture.md) | Directory layout, major modules, data flow |
| `STACK.md` | [stack.md](references/templates/stack.md) | Dependencies, versions, infra, external services |
| `CONVENTIONS.md` | [conventions.md](references/templates/conventions.md) | Naming, patterns, lint rules already in use |
| `RUNBOOK.md` | [runbook.md](references/templates/runbook.md) | Install, dev, test, lint, deploy commands |
| `DECISIONS.md` | [decisions.md](references/templates/decisions.md) | Existing ADRs, README choices, tech tradeoffs |

Omit a reference file only when clearly irrelevant (e.g. no `DECISIONS.md` for a trivial script).
If omitted, remove its row from the AGENTS.md reference table.

### Step 3: Write root `AGENTS.md`

Create `AGENTS.md` at the project root from [references/templates/AGENTS.md](references/templates/AGENTS.md).
Follow the [agents.md open format](https://agents.md/) - agent-focused, complements README.md, actionable commands.
Keep it under ~80 lines.
It is an **index**, not an encyclopedia.
Detailed sections from the agents.md spec (testing patterns, PR rules, debugging) belong in `.agents/references/`, not inlined here.

Required sections:

- Quick orientation (what, stack, entry points)
- Commands table (exact, verified commands - see agents-md-guide)
- Reference docs table (links into `.agents/references/`)
- Project skills table (empty until skills exist)
- Out of scope / do-not-edit list

Do **not** duplicate content from `~/.agents/AGENTS.md`.
A single line noting that global standards apply is enough.

For monorepos, also read the **Monorepos** section in agents-md-guide.md.
Add nested `AGENTS.md` files in subprojects when packages have different commands or conventions.

### Step 4: Update `.gitignore`

Ensure these patterns exist (add if missing):

```gitignore
# Local agent overrides (machine-specific, not shared)
.agents/*.local.md
.agents/references/*.local.md
```

### Step 5: Validate

```bash
bash ~/.agents/skills/project-agents/scripts/validate-project-agents.sh .
```

Fix any reported gaps before finishing.

---

## Refactor workflow

When `AGENTS.md` is long or `.agents/` is missing:

1. Read the full existing `AGENTS.md`.
2. Create `.agents/references/` if missing.
3. Move prose into the appropriate reference file:
   - Architecture / module descriptions → `ARCHITECTURE.md`
   - Dependencies / versions → `STACK.md`
   - Style / naming / patterns → `CONVENTIONS.md`
   - Build / test / deploy → `RUNBOOK.md`
   - "We chose X because" → `DECISIONS.md`
4. Replace moved content in `AGENTS.md` with a one-line pointer in the reference table.
5. Run validation.

Preserve information - refactor is a move, not a delete.

---

## Update workflow

When structure already exists:

1. Re-inspect the repo for changes since last update.
2. Update the relevant reference file(s), not `AGENTS.md` bulk.
3. Touch `AGENTS.md` only for: new commands, new skills, new reference files, changed entry points.
4. Run validation.

---

## Add project skill workflow

Project skills live in `.agents/skills/<name>/SKILL.md`.
They apply **only in this repository**.

1. Create `.agents/skills/<skill-name>/SKILL.md` following skill conventions (YAML frontmatter with `name` and `description`).
2. Register the skill in the **Project skills** table in root `AGENTS.md`.
3. Do **not** install repo-specific skills globally (`npx skills add -g`).

To install from the open skills ecosystem into this project:

```bash
cd /path/to/project
npx skills add <owner/repo@skill> -y
```

Verify the skill landed under `.agents/skills/` or move it there.
Record provenance in `.agents/.skill-lock.json` if the CLI created one.

---

## Progressive disclosure rules

Agents should **not** load every reference file up front.

- Root `AGENTS.md` is always in context (Cursor loads it automatically).
- Reference files are read only when the current task needs them.
- Project skill bodies load only when the task matches the skill description.

When writing reference files, put each full sentence on its own line (same rule as global `AGENTS.md`).

## agents.md content principles (summary)

These come from the GitHub [create-agentsmd](https://agents.md/) guidance, mapped to this layout:

- **Be specific**: exact commands in backticks, not vague descriptions.
- **Agent-focused**: what an agent needs to build, test, and submit - not a second README.
- **Complements README**: link to README for product context; document technical workflow here.
- **Test commands**: run or trace every command from package.json, Makefile, or CI before documenting.
- **Monorepos**: nested `AGENTS.md` per package; closest file wins; shared refs at repo root.
- **Living docs**: update references when scripts or CI change.

Full mapping and checklist: [references/agents-md-guide.md](references/agents-md-guide.md).

---

## What never goes in a project

| Content | Belongs in |
| --- | --- |
| Personal engineering standards | `~/.agents/AGENTS.md` |
| Voice / identity | `~/.agents/VOICE.md` |
| Personal viewpoints | `~/.agents/OPINIONS.md` |
| Skills used across all projects | `~/.agents/skills/` |
| Secrets or credentials | `.env`, secret managers - never agent markdown |

---

## Handoff summary

When done, tell the user:

1. What was created or updated.
2. What you inferred vs what they should fill in manually.
3. Suggested next commit message:

```text
Add project agent structure for [project name]

Bootstrap AGENTS.md and .agents/ references for agent onboarding.
```
