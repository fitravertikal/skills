# Subagents

Project subagents available when working in this repo (all Claude Code surfaces,
including web/phone, once merged to the default branch).

## `skill-reviewer.md`
First-party agent for qualitative skill review (see its frontmatter).

## Vendored: Agency Agents (243 files)

The remaining agent files are vendored from
[msitarzewski/agency-agents](https://github.com/msitarzewski/agency-agents)
(MIT License — see `AGENCY-AGENTS-LICENSE.txt`; Copyright (c) 2025 AgentLand
Contributors). They are a curated agency of specialist personas across
engineering, design, finance, security, marketing, and more.

Notes:
- Imported **as-is**. Their frontmatter carries extra fields (`color`, `emoji`,
  `vibe`) beyond Claude Code's `name`/`description`; these are ignored and
  harmless.
- `name` values are human-readable (e.g. "Incident Response Commander"), not
  slugs — invoke an agent by describing the task/role rather than a hyphen-slug.
- Files are flattened here (no name collisions) so every client discovers them,
  including phone/web. Original division was by folder; the filename prefix
  (`engineering-…`, `security-…`) preserves that grouping when sorted.
- Non-agent docs from the source (the `strategy/` playbooks and runbooks that
  lacked `name`/`description` frontmatter) were intentionally excluded.
