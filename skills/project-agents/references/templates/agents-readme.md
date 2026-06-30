# Project agent files

This directory holds **repository-specific** agent context.
It is intentionally separate from `~/.agents/` (global).

## Layout

| Path | Purpose |
| --- | --- |
| `references/` | Markdown docs loaded on demand via pointers in root `AGENTS.md` |
| `skills/` | Project-only Agent Skills (`SKILL.md` per skill) |
| `.skill-lock.json` | Optional lock file for project skill provenance |
| `*.local.md` | Gitignored machine-specific overrides |

## Global vs project

- **Global** (`~/.agents/`): personal standards, voice, opinions, cross-project skills.
- **Project** (this directory + root `AGENTS.md`): repo architecture, commands, conventions, project skills.

Edit global preferences in `~/.agents`.
Edit project context here and in root `AGENTS.md`.
