---
description: Scaffold a new skill directory from the template and register it in marketplace.json
argument-hint: <skill-name> [what it does / when to trigger]
---

Scaffold a new skill named `$1` in this repository. Extra context after the name: $ARGUMENTS

Follow these steps:

1. **Validate the name.** It must be lowercase with hyphens for spaces (e.g. `pdf-summarizer`) and must not collide with an existing directory under `skills/`. If it collides or is malformed, stop and tell the user.

2. **Create `skills/$1/SKILL.md`** starting from `template/SKILL.md`. Set `name: $1`. Write the `description` to cover BOTH what the skill does AND when to trigger it — this is the primary triggering mechanism, so make it specific and slightly "pushy" with concrete trigger phrases and explicit negative cases ("Do NOT use for…"). If the user gave intent after the name, draft the description from it; otherwise ask them one focused question about what the skill should do and when it should fire, then draft it.

3. **Add `skills/$1/LICENSE.txt`** matching the repo's example skills (Apache 2.0), and set `license: Complete terms in LICENSE.txt` in the frontmatter — unless the user says this is a proprietary/source-available skill.

4. **Register it in `.claude-plugin/marketplace.json`.** Add `"./skills/$1"` to the `skills` array of the appropriate plugin — default to `example-skills` unless it's clearly a document skill (`document-skills`) or API/SDK reference (`claude-api`). Keep the JSON valid.

5. **Write the body** using imperative mood. Explain *why* each step matters rather than issuing bare ALL-CAPS MUSTs. Don't re-explain file structures the model can discover itself. Keep SKILL.md under ~500 lines; if it grows, split detail into `references/*.md` and link to it.

6. **Report** the created files and remind the user that for full test/eval iteration they can run the `skill-creator` skill.

Do not commit or push unless the user asks.
