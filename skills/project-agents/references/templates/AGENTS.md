# [Project name] - agent instructions

Project-specific context for agents working in this repository.
Global personal standards live in `~/.agents/AGENTS.md` and apply on top of this file.
Where they conflict on project matters, **this file wins**.

## Quick orientation

- **What this is:** [one sentence describing the project]
- **Primary stack:** [language, framework, runtime]
- **Entry points:** [main app path, key packages, binaries]

## Commands

| Task | Command |
| --- | --- |
| Install | `[verified install command]` |
| Dev | `[verified dev command]` |
| Test | `[verified test command]` |
| Lint | `[verified lint command]` |

## Reference docs

Read only what the current task needs.
Do not load all of these up front.

| File | When to read |
| --- | --- |
| [`.agents/references/ARCHITECTURE.md`](.agents/references/ARCHITECTURE.md) | Structural changes, new modules, data flow |
| [`.agents/references/STACK.md`](.agents/references/STACK.md) | Dependencies, versions, infrastructure |
| [`.agents/references/CONVENTIONS.md`](.agents/references/CONVENTIONS.md) | Naming, patterns, code style |
| [`.agents/references/RUNBOOK.md`](.agents/references/RUNBOOK.md) | Build, test, deploy, debugging |
| [`.agents/references/DECISIONS.md`](.agents/references/DECISIONS.md) | Why we chose X over Y |

## Project skills

Skills in `.agents/skills/` apply **only in this repository**.
Read `SKILL.md` when the task matches the skill description.

| Skill | Path |
| --- | --- |
| _(none yet)_ | |

## Out of scope for agents

- Do not edit auto-generated files: [list paths or patterns]
- Secrets: never commit; see `.env.example` if present
