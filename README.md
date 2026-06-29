# ~/.agents

Personal agent configuration for Christian.
This repository holds your **global** agent instructions, voice profile, opinions, and skills.
It is designed to live at `~/.agents` on your machine.

Individual projects keep their **own** `AGENTS.md` files with repo-specific context.
Agents should always read the global file first, then the project file for whatever repo you are working in.

## Two layers of instructions

```text
~/.agents/AGENTS.md          Global instructions (this repo)
        +
~/code/project-1/AGENTS.md  Project-specific instructions (each repo)
        =
Both apply when working in that project
```

| Layer | Location | What it covers |
| --- | --- | --- |
| **Global** | [`~/.agents/AGENTS.md`](./AGENTS.md) | Personal standards that apply everywhere: engineering quality, communication style, references to `VOICE.md` and `OPINIONS.md`. |
| **Project** | `AGENTS.md` in each repo root | That project's architecture, build commands, technical choices, and what is done vs still to do. |

Project `AGENTS.md` files are **not** symlinks to this repo.
They are real, version-controlled files owned by each project.
Edit global preferences here in `~/.agents`; edit project context in the project itself.

When both files exist, agents combine them.
Project-level instructions take precedence where they conflict, the same way nested `AGENTS.md` files work within a repo.

## What else is in this repo

| File / directory | Purpose |
| --- | --- |
| [`VOICE.md`](./VOICE.md) | How Christian talks when an agent posts or communicates on his behalf. |
| [`OPINIONS.md`](./OPINIONS.md) | Christian's technical and product viewpoints. |
| [`skills/`](./skills/) | Installed [agent skills](https://skills.sh/) - modular packages that extend agent capabilities. |
| [`.skill-lock.json`](./.skill-lock.json) | Lock file tracking which skills are installed and where they came from. |

### Included skills

Skills are installed with the [Skills CLI](https://skills.sh/) (`npx skills`) and stored under `skills/`.

| Skill | Source | What it does |
| --- | --- | --- |
| `find-skills` | [vercel-labs/skills](https://github.com/vercel-labs/skills) | Helps discover and install skills from the open skills ecosystem. |
| `skill-creator` | [anthropics/skills](https://github.com/anthropics/skills) | Create, evaluate, and improve agent skills with benchmarks and iteration loops. |

## Installation

### 1. Clone the repository

Clone this repo to `~/.agents`.
That path is referenced throughout [`AGENTS.md`](./AGENTS.md) and is the expected home for this configuration.

**macOS / Linux**

```bash
git clone <repository-url> ~/.agents
```

**Windows (PowerShell)**

```powershell
git clone <repository-url> $env:USERPROFILE\.agents
```

**Windows (Command Prompt)**

```cmd
git clone <repository-url> %USERPROFILE%\.agents
```

Replace `<repository-url>` with the actual Git remote for this repository.

### 2. Wire up the global AGENTS.md

Each tool needs a one-time setup so it always loads `~/.agents/AGENTS.md`, regardless of which project is open.
This is done at the **user/machine level**, not inside individual project repos.

#### Symlink at your home directory (macOS / Linux)

A symlink at `~/AGENTS.md` pointing to this repo is the simplest cross-tool hook.
Tools that look for a global agents file in your home directory will find it.

```bash
ln -s ~/.agents/AGENTS.md ~/AGENTS.md
```

Verify:

```bash
ls -l ~/AGENTS.md
# /home/you/AGENTS.md -> /home/you/.agents/AGENTS.md
```

#### Windows home directory (Command Prompt, run as Administrator)

Windows requires elevated privileges or [Developer Mode](https://learn.microsoft.com/en-us/windows/apps/get-started/enable-your-device-for-development) enabled to create symlinks.

```cmd
mklink %USERPROFILE%\AGENTS.md %USERPROFILE%\.agents\AGENTS.md
```

#### Windows home directory (PowerShell, run as Administrator)

```powershell
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\AGENTS.md" -Target "$env:USERPROFILE\.agents\AGENTS.md"
```

#### Cursor

Cursor reads `AGENTS.md` from the **project root** automatically.
It does not yet have first-class support for a global `~/.agents/AGENTS.md` on every project (see [feature request](https://forum.cursor.com/t/support-global-agents-md/150406)).

Until that lands, use **Cursor Settings → Rules → User Rules** to ensure your global instructions always apply.
Paste the contents of [`AGENTS.md`](./AGENTS.md), or add a short rule that tells the agent to read `~/.agents/AGENTS.md` at the start of every session.

When you edit [`AGENTS.md`](./AGENTS.md) in this repo, update User Rules to match (or re-paste).
Project-level `AGENTS.md` files in each repo are picked up by Cursor without any extra setup.

#### Other tools

Some agents have their own global instruction paths.
You can symlink those to the same file if you use them:

| Tool | Global path | Symlink command (macOS / Linux) |
| --- | --- | --- |
| OpenAI Codex | `~/.codex/AGENTS.md` | `ln -s ~/.agents/AGENTS.md ~/.codex/AGENTS.md` |
| Claude Code | `~/.claude/CLAUDE.md` | `ln -s ~/.agents/AGENTS.md ~/.claude/CLAUDE.md` |

Only set up the tools you actually use.

### 3. Add AGENTS.md to your projects

Each project repo should have its own `AGENTS.md` at the repo root.
Write project-specific content there: what the project is, how to build and test it, architecture decisions, and what still needs to be done.

```bash
# Example: bootstrap a new project file (do not symlink to ~/.agents)
cd ~/code/project-1
# Create AGENTS.md with project-specific instructions, then commit it
git add AGENTS.md
git commit -m "Add project AGENTS.md for agent onboarding"
```

Do **not** symlink a project's `AGENTS.md` to `~/.agents/AGENTS.md`.
The global file and the project file serve different purposes and should stay separate.

### 4. Install or update skills

From `~/.agents`, use the Skills CLI to add, list, or update skills:

```bash
cd ~/.agents

# Search for skills
npx skills find react performance

# Install a skill globally (into ~/.agents/skills/)
npx skills add vercel-labs/skills@find-skills -g -y

# List installed skills
npx skills list

# Update all installed skills
npx skills update -g -y
```

The `-g` flag installs at user level so skills are available across projects.
Installed skills and their provenance are recorded in [`.skill-lock.json`](./.skill-lock.json).

## How it works in practice

```text
~/.agents/                              # This repo
├── AGENTS.md                           # Global instructions (always apply)
├── VOICE.md
├── OPINIONS.md
├── skills/
└── .skill-lock.json

~/AGENTS.md  -->  ~/.agents/AGENTS.md   # One-time user-level symlink

~/code/project-1/
└── AGENTS.md                           # Project-specific (real file, in git)

~/code/project-2/
└── AGENTS.md                           # Different project, different file
```

When you open `project-1` in Cursor:

1. Global instructions from `~/.agents/AGENTS.md` apply (via User Rules and/or the home-directory symlink).
2. Project instructions from `project-1/AGENTS.md` apply on top.
3. The agent has both your personal standards and that project's context.

Edit global behavior once in `~/.agents`.
Edit project onboarding in each repo's own `AGENTS.md`.

## Local and private files

Some files are intentionally kept out of version control.
See [`.gitignore`](./.gitignore):

- `*.local.md` - local overrides (for example `OPINIONS.local.md`)
- `secrets/` - credentials and other sensitive material
- `.env` - environment secrets

Keep machine-specific or private content in those patterns rather than in tracked files.

## Updating

Pull the latest global configuration:

```bash
cd ~/.agents
git pull
```

If you mirror global instructions into Cursor User Rules, update those after pulling changes to [`AGENTS.md`](./AGENTS.md).

To refresh skills after pulling:

```bash
cd ~/.agents
npx skills update -g -y
```

Project `AGENTS.md` files are updated independently in each repo.

## Quick reference

| Task | Command |
| --- | --- |
| Clone this repo | `git clone <repository-url> ~/.agents` |
| Wire global AGENTS.md (macOS / Linux) | `ln -s ~/.agents/AGENTS.md ~/AGENTS.md` |
| Wire global AGENTS.md (Windows PowerShell) | `New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\AGENTS.md" -Target "$env:USERPROFILE\.agents\AGENTS.md"` |
| Add project instructions | Create `AGENTS.md` in the project root (not a symlink) |
| Find a skill | `npx skills find <query>` |
| Install a skill | `npx skills add <owner/repo@skill> -g -y` |
| List installed skills | `npx skills list` |
| Update skills | `npx skills update -g -y` |
