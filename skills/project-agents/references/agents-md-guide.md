# AGENTS.md content guide

Principles from the [agents.md](https://agents.md/) open format, adapted for the **thin index + `.agents/references/`** layout used by the project-agents skill.

AGENTS.md is a "README for agents" - agent-focused technical context that complements a human README.
It works across Cursor, Codex, Claude Code, and many other tools.

## Key principles

- **Agent-focused**: actionable instructions agents can execute, not marketing copy.
- **Complements README.md**: do not duplicate the human README; add what agents need to work in the repo.
- **Specific commands**: exact commands in backticks, verified against the repo - never vague "run the tests".
- **Living documentation**: update when scripts, CI, or conventions change.
- **Test what you document**: run every command you list before committing agent files.

## Where content goes

This repo uses a split layout.
Do not put everything in root `AGENTS.md`.

| agents.md topic | Project location |
| --- | --- |
| Project overview (brief) | Root `AGENTS.md` - Quick orientation |
| Architecture overview | `.agents/references/ARCHITECTURE.md` |
| Key technologies / frameworks | `.agents/references/STACK.md` |
| Setup, install, env, database | `.agents/references/RUNBOOK.md` - Prerequisites, Local development |
| Dev server, watch, hot reload | `.agents/references/RUNBOOK.md` - Local development |
| Testing (unit, integration, e2e) | `.agents/references/RUNBOOK.md` - Testing |
| Code style, lint, naming, imports | `.agents/references/CONVENTIONS.md` |
| Build and deployment | `.agents/references/RUNBOOK.md` - Building, Deploying |
| CI/CD pipeline | `.agents/references/RUNBOOK.md` - Deploying |
| Security, secrets, auth patterns | `.agents/references/CONVENTIONS.md` or `RUNBOOK.md` |
| PR / commit conventions | `.agents/references/CONVENTIONS.md` |
| Debugging and troubleshooting | `.agents/references/RUNBOOK.md` - Debugging |
| "We chose X because" decisions | `.agents/references/DECISIONS.md` |

Root `AGENTS.md` holds a **commands table** (the highest-frequency actions) plus pointers to reference files.

## Root AGENTS.md essentials

Keep these in the thin index even when details live in references:

1. **Quick orientation** - one sentence on what the project is, primary stack, entry points.
2. **Commands table** - install, dev, test, lint (verified commands only).
3. **Reference table** - when to read each `.agents/references/` file.
4. **Out of scope** - auto-generated paths, secrets handling.

## Content quality checklist

Before finishing, verify:

- [ ] Every command in `AGENTS.md` and `RUNBOOK.md` was run or traced from config (package.json, Makefile, CI).
- [ ] Test commands include how to run a single test or subset when the framework supports it.
- [ ] Lint/format commands match what CI runs.
- [ ] Monorepo navigation tips are documented if applicable (see below).
- [ ] PR/commit conventions match what the team actually uses.
- [ ] No secrets, tokens, or credentials in any agent markdown file.

## Monorepos

For monorepos, use **nested agent roots**:

```text
monorepo/
├── AGENTS.md              # Workspace-wide orientation + cross-package commands
├── .agents/references/    # Shared architecture, stack, conventions
└── packages/foo/
    ├── AGENTS.md          # Package-specific index (closest file wins)
    └── .agents/
        └── references/    # Optional - only if foo differs from workspace defaults
```

Rules:

- Place a main `AGENTS.md` + `.agents/` at the repository root.
- Add `AGENTS.md` in subprojects when packages have different commands or conventions.
- The **closest** `AGENTS.md` to the file being edited takes precedence.
- Shared content stays at the repo root `.agents/references/`.
- Package-specific overrides go in the package's `.agents/references/` or its `AGENTS.md` commands table.

## Example tone (from agents.md)

Good - specific and executable:

```markdown
## Commands

| Task | Command |
| --- | --- |
| Test one package | `pnpm turbo run test --filter <package_name>` |
| Test one case | `pnpm vitest run -t "<test name>"` |
| Lint after import moves | `pnpm lint --filter <package_name>` |
```

Bad - vague:

```markdown
## Testing

Run the appropriate test command for the package you are working on.
Make sure tests pass before committing.
```

## Relationship to global ~/.agents

Project agent files document **this repository**.
Global `~/.agents/AGENTS.md` documents **personal standards across all repos**.

Do not copy global content into project files.
Project files may reference global paths when relevant (e.g. voice, opinions) but should not duplicate them.
