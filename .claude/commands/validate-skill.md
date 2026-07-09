---
description: Check a skill's structure, frontmatter, and marketplace registration for consistency
argument-hint: <skill-name> (omit to validate all skills)
---

Validate skill(s) in this repository. Target: `$1` (if empty, validate every directory under `skills/`).

For each targeted skill, check and report PASS/FAIL on:

1. **`SKILL.md` exists** in the skill directory.

2. **Frontmatter is well-formed** — has a `name` and a `description` field between the opening/closing `---` lines.

3. **`name` matches the directory name.** A mismatch breaks the convention every other skill follows; flag it.

4. **`description` is substantive** — it should say both what the skill does and when to trigger it, not just a bare label. Flag descriptions that are one short generic phrase.

5. **Registered in `.claude-plugin/marketplace.json`** — the path `./skills/<name>` must appear in exactly one plugin's `skills` array. Flag skills that are missing (won't be installable) or listed in more than one plugin.

6. **`LICENSE.txt` present** — most skills carry one. Note its absence.

7. **`requirements.txt` awareness** — if the skill bundles a `requirements.txt`, confirm it's covered by the SessionStart hook (`.claude/hooks/session-start.sh` picks up any `skills/**/requirements.txt` automatically, so this passes by default — just note new dependency files so THIRD_PARTY_NOTICES.md stays accurate).

Present results as a concise table (skill → check → status), then summarize the concrete fixes needed. Do not modify any files unless the user asks you to fix the issues.
