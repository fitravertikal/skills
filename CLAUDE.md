# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This is Anthropic's public repository of **Agent Skills** — folders of instructions, scripts, and resources that Claude loads dynamically (via progressive disclosure) to improve performance on specialized tasks. This is a content/skills repository, not an application: there is no build step, no test suite, and no package manager at the repo root. Most "development" here means authoring or editing `SKILL.md` files and their bundled scripts/resources.

## Repository structure

- `skills/` — one directory per skill (e.g. `skills/pdf`, `skills/docx`, `skills/mcp-builder`). Each is self-contained.
- `spec/` — pointer to the external Agent Skills specification (agentskills.io).
- `template/` — minimal `SKILL.md` starting point for new skills.
- `.claude-plugin/marketplace.json` — defines this repo as a Claude Code plugin marketplace with three plugins (`document-skills`, `example-skills`, `claude-api`), each listing which `skills/*` paths it bundles. **When adding, removing, or renaming a skill directory, update the corresponding plugin's `skills` array here** or the plugin will silently omit/break on the skill.
- `README.md` — user-facing overview and install instructions.
- `THIRD_PARTY_NOTICES.md` — attribution for third-party libraries used by skill scripts (e.g. imageio). Update when a skill adds a new third-party dependency with its own license.

## Anatomy of a skill

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter: name, description (required); license, compatibility, allowed-tools (optional)
│   └── Markdown instructions (body)
├── LICENSE.txt (present on most skills; states Apache 2.0 vs. proprietary/source-available)
└── Bundled resources (optional, any combination):
    ├── scripts/    - executable code for deterministic/repetitive tasks
    ├── references/ - docs loaded into context on demand (not always loaded)
    └── assets/     - files used in output (templates, icons, fonts)
```

Frontmatter conventions observed across existing skills:
- `name`: matches the directory name.
- `description`: the **primary triggering mechanism** — Claude decides whether to consult a skill based on this string alone (plus the name) before the body is ever loaded. Descriptions here are deliberately specific and slightly "pushy," listing concrete trigger phrases/file extensions and explicit negative cases ("Do NOT use for..."). See `skills/docx/SKILL.md`, `skills/pdf/SKILL.md`, `skills/xlsx/SKILL.md` for the pattern.
- `license`: short pointer string, e.g. `"Complete terms in LICENSE.txt"` or `"Proprietary. LICENSE.txt has complete terms"`.
- `allowed-tools` / `compatibility`: used sparingly (e.g. `skills/mcp-builder`, `skills/skill-creator`, `skills/web-artifacts-builder`) to restrict tools or note dependencies — only add these when actually needed.

### Progressive disclosure (three loading levels)

1. **Metadata** (`name` + `description`) — always resident in context for every installed skill (~100 words).
2. **SKILL.md body** — loaded only once the skill triggers; keep under ~500 lines. If a skill is approaching that limit, split detail into `references/*.md` and link to it from the body rather than inlining everything.
3. **Bundled resources** (`scripts/`, `references/`, `assets/`) — loaded/executed on demand, no size limit. Scripts can run without their contents ever entering context.

Large reference files (>300 lines) should include a table of contents. Skills covering multiple domains/frameworks (e.g. a hypothetical multi-cloud skill) should split by variant under `references/` (`aws.md`, `gcp.md`, `azure.md`) so Claude reads only the relevant one.

## Two source-available document skills vs. open-source example skills

- `skills/docx`, `skills/pdf`, `skills/pptx`, `skills/xlsx` are the actual skills powering Claude's built-in document creation/editing features. Their `LICENSE.txt` marks them source-available/proprietary, not Apache 2.0 — treat them as reference implementations, don't assume permissive reuse.
- Everything else under `skills/` is Apache 2.0 licensed example/demonstration content.

## Working with individual skills

There's no single test runner for the repo; each skill carries its own scripts under `scripts/` (Python or Node) that are meant to be invoked directly per that skill's `SKILL.md`, e.g.:
- `skills/pdf/scripts/`, `skills/docx/scripts/`, `skills/pptx/scripts/`, `skills/xlsx/scripts/` — document manipulation helpers.
- `skills/mcp-builder/scripts/` (has its own `requirements.txt`) — MCP server scaffolding/validation.
- `skills/slack-gif-creator/` (has its own `requirements.txt`) — GIF generation utilities.
- `skills/webapp-testing/scripts/` — Playwright-based helpers for testing local web apps.

Install a skill's Python dependencies from its own `requirements.txt` (not a repo-root one — none exists) before running its scripts.

## Creating or modifying a skill

Use the meta-skill for this rather than hand-rolling the process: `skills/skill-creator/SKILL.md` documents the full workflow — draft `SKILL.md`, write test prompts, run with-skill vs. baseline subagent comparisons, grade against assertions, iterate on user feedback, then optionally run `scripts/run_loop.py` to optimize the triggering `description` against an eval set, and finally package with `scripts/package_skill.py`. Key points if you're building a skill without going through the full loop:

- Start from `template/SKILL.md` for the minimal required frontmatter shape.
- Write the `description` to cover both *what* the skill does and *when* to use it — all triggering context belongs in frontmatter, not the body.
- Use the imperative mood in instructions; explain *why* a step matters rather than issuing bare ALL-CAPS MUSTs.
- Don't duplicate content the model can already access — read files with FILE tools directly rather than re-explaining file structures the skill will discover on its own.
- After adding a new skill directory, register it in `.claude-plugin/marketplace.json` under the appropriate plugin's `skills` array so it's actually installable.

## Collaborating with other agents

If another autonomous agent (e.g. Hermes) may also be working in this repo, read `.agents/COLLABORATION.md` before starting and follow it. In short: own the `claude/*` branch prefix (never push to `hermes/*`), treat each GitHub issue as the unit of work, open PRs as drafts, hand off explicitly via the `needs:*` / `agent:*` labels plus an assignee, and leave merges to `main` for a human. The full state machine, loop guardrails, and merge policy live in that file.
