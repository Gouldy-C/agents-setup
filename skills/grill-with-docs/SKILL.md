---
name: grill-with-docs
description: >-
  A relentless one-question-at-a-time interview to sharpen a plan or design, writing
  domain vocabulary and hard decisions into .agents/references/ as you go. Use when the
  user invokes /grill-with-docs, wants to stress-test a fuzzy plan before building, or
  wants grilling that leaves a paper trail in the project's agent docs.
disable-model-invocation: true
---

# Grill With Docs

Interview the user relentlessly about a plan or design until you reach a shared understanding.
Capture resolved vocabulary and genuinely hard decisions in the project's `.agents/` docs as you go.

This skill is **stateful** - it writes into the target repo during the session.
Do not use a single monolithic `CONTEXT.md` at the repo root.
Use the **AGENTS.md + `.agents/references/`** layout instead.

## Before you start

1. Confirm you are in the **target project root** (not `~/.agents`).
2. Read root `AGENTS.md` - it is always the index; follow its reference table for what already exists.
3. Read `.agents/references/GLOSSARY.md` if it exists (canonical domain language).
4. Read `.agents/references/DECISIONS.md` if it exists (prior hard choices).
5. Read `.agents/references/DOMAIN-MAP.md` only when the repo has multiple bounded contexts.
6. Read other `.agents/references/` files only when the current topic needs them.

Create files **lazily** - only when you have something to write.

## File layout

Single-context repo (most projects):

```text
project-root/
├── AGENTS.md
└── .agents/
    └── references/
        ├── GLOSSARY.md      # Ubiquitous language - create on first resolved term
        └── DECISIONS.md     # Hard-to-reverse choices - create on first ADR-worthy decision
```

Multi-context repo (rare):

```text
project-root/
├── AGENTS.md
└── .agents/
    └── references/
        ├── DOMAIN-MAP.md    # Lists contexts, where each glossary lives, how they relate
        ├── DECISIONS.md     # System-wide decisions
        └── ...
    └── contexts/
        ├── ordering/
        │   ├── GLOSSARY.md
        │   └── DECISIONS.md   # Context-specific decisions (optional)
        └── billing/
            ├── GLOSSARY.md
            └── DECISIONS.md
```

Infer structure:

- If `.agents/references/DOMAIN-MAP.md` exists, read it to find contexts.
- Else if `.agents/references/GLOSSARY.md` exists, single context.
- Else create `.agents/references/GLOSSARY.md` lazily when the first term resolves.

When multiple contexts exist, infer which one the current topic belongs to.
If unclear, ask.

When you create a new reference file, add a row to the **Reference docs** table in root `AGENTS.md` if one is not already there.

## The grill

Interview relentlessly about every aspect of the plan.
Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

### Question discipline

- Ask **one question at a time**.
- Wait for the user's answer before continuing.
- Asking multiple questions at once is bewildering.
- If a question can be answered by exploring the codebase, explore the codebase instead of asking.
- For each question, offer your **recommended answer**.

### Domain modeling during the grill

While grilling, actively sharpen the domain model:

**Challenge against the glossary**
When the user uses a term that conflicts with `.agents/references/GLOSSARY.md`, call it out immediately.
"Your glossary defines 'cancellation' as X, but you seem to mean Y - which is it?"

**Sharpen fuzzy language**
When the user uses vague or overloaded terms, propose a precise canonical term.
"You're saying 'account' - do you mean the Customer or the User? Those are different things."

**Discuss concrete scenarios**
Stress-test domain relationships with specific scenarios.
Invent edge cases that force precision about boundaries between concepts.

**Cross-reference with code**
When the user states how something works, check whether the code agrees.
If you find a contradiction, surface it.

**Update GLOSSARY.md inline**
When a term is resolved, update the glossary right there.
Do not batch these up - capture them as they happen.
Use the format in [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md).

`GLOSSARY.md` is **vocabulary only**.
No implementation details, no spec, no scratch pad.

**Record hard decisions sparingly**
Only offer to append a decision when all three are true:

1. **Hard to reverse** - changing your mind later has meaningful cost
2. **Surprising without context** - a future reader will wonder "why did they do it this way?"
3. **Result of a real trade-off** - genuine alternatives existed and one was chosen for specific reasons

If any of the three is missing, skip it.
Append to `.agents/references/DECISIONS.md` using the entry format from the project-agents template.
For context-specific repos, append to that context's `DECISIONS.md` instead when the decision is local.

Most sessions produce a sharper glossary and few or no new decision entries.
That is the intended shape.

## Success criteria

The session is working when:

- You ask one question at a time and wait.
- Terms land in `GLOSSARY.md` the moment they resolve, in the project's own words.
- You reach into the codebase to answer your own questions where you can.
- New decision entries stay rare - reversible choices are not recorded.
- New reference files are registered in `AGENTS.md` when created.

## Related skills

- **Grilling only (no docs):** same interview discipline without writing glossary or decisions.
- **Domain modeling only:** sharpen or record vocabulary and decisions when the plan is already clear.
- **project-agents:** bootstrap or maintain the `AGENTS.md` + `.agents/` structure itself.
