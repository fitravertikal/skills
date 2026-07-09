# Multi-Agent Collaboration Protocol

How autonomous agents — **Hermes** (full authority across all repos) and
**Claude Code** (scoped per session) — collaborate using **GitHub as the single
source of truth**. No agent-to-agent channel exists outside GitHub: every intent,
handoff, and result is a branch, commit, PR, issue, label, or comment. If it
isn't on GitHub, it didn't happen.

This file is a portable template. Copy it into any repo where the two agents
should collaborate, and keep it identical across repos so both agents can rely on
one protocol everywhere.

---

## Roles and authority

| | Hermes | Claude Code |
|---|---|---|
| GitHub scope | All repos, full authority | The repos attached to the current session |
| Can merge to `main`? | Technically yes — **but must not** (see Merge policy) | No |
| Branch prefix it owns | `hermes/*` | `claude/*` |
| Typical strengths | Cross-repo orchestration, always-on, reacting to events | Deep single-repo work, interactive with the human, review |

**Authority ≠ permission.** Hermes *can* do anything, so the guardrails below are
policy, not enforcement. Hermes honors them the same way a trusted senior engineer
honors process even with admin rights. Where they *can* be enforced (branch
protection, required reviews), configure them — see "Human setup checklist".

---

## Core rules

1. **Own your branch, never push to the other agent's.** Hermes commits only to
   `hermes/*`, Claude only to `claude/*`. Neither force-pushes a branch it doesn't
   own. This alone eliminates most conflicts.
2. **One unit of work = one GitHub issue.** The issue is the durable task record.
   Branches and PRs reference it (`Fixes #123`). Coordination happens on the issue
   and its PR, not in ephemeral agent memory.
3. **All PRs start as draft.** A draft PR means "in progress, do not merge." Mark
   it *ready for review* only when you believe it's mergeable.
4. **Handoff is explicit and labeled.** You never assume the other agent is
   watching. You transfer the baton with a label + assignee + a comment stating
   what you did and what you want next (see Handoff protocol).
5. **The human holds the merge gate.** Agents prepare and review; a human merges to
   `main`. (Adjustable — see Merge policy.)

---

## Label taxonomy (the handoff state machine)

Create these labels once per repo (see Human setup checklist). They encode whose
turn it is:

| Label | Meaning | Who applies it | Who acts next |
|---|---|---|---|
| `needs:claude` | Claude Code should pick this up | Hermes or human | Claude Code |
| `needs:hermes` | Hermes should pick this up | Claude or human | Hermes |
| `agent:review` | Ready for the *other* agent to review the PR | Author agent | Reviewer agent |
| `agent:blocked` | Stuck — needs a human decision | Either agent | Human |
| `agent:wip` | Actively being worked; do not touch | Working agent | (nobody) |

**Golden rule to prevent loops:** an agent acts only on the label addressed to it,
and *removes that label* when it takes the work (replacing it with `agent:wip`).
An agent never re-applies a label addressed to itself.

---

## Handoff protocol

When agent A finishes its part and wants agent B to continue:

1. Push your work to your own branch (`A-prefix/...`) and update the draft PR.
2. Write **one** handoff comment on the issue or PR containing:
   - **Done:** what you changed (link the commits/PR).
   - **Want:** the specific next action you're requesting.
   - **Context:** anything B needs that isn't obvious from the diff.
3. Remove your `agent:wip` label, add `needs:B` (or `agent:review` if it's a review
   request), and set B as assignee.
4. Stop. Do not keep working on that issue until B hands it back.

When agent B receives it (via label/assignment; Claude Code can also `subscribe` to
the PR to get events pushed into its session): B swaps `needs:B` → `agent:wip`,
does the work on B's own branch, then either hands back or escalates.

### Loop and progress guardrails

- **Ping-pong limit:** if a single issue bounces between the two agents **3 times**
  without reaching *ready for review*, the next agent adds `agent:blocked`, writes a
  short "here's where we're stuck" comment, and waits for the human. Two agents must
  never trade a task indefinitely.
- **No self-reply loops:** never respond to a comment authored by yourself, and
  never act on a label your own last action created.
- **Idempotent reactions:** before acting on an event, check the current issue/PR
  state — it may already be resolved. React to *state*, not to stale notifications.

---

## Merge policy — human-gated (default)

- Agents may open, fill, review, and mark PRs *ready*. **Only a human merges to
  `main`.**
- Enforce with branch protection on `main`: require a PR, require the CI checks to
  pass, and require at least one approving review.
- **Alternative (opt-in):** allow agent auto-merge only when *all* hold: CI green,
  one approving review from the *other* agent, and the PR carries an
  `auto-merge-ok` label a human added to that specific PR. Never a blanket
  auto-merge. If you switch to this, say so here and tighten branch protection
  accordingly.

---

## Conflicts and attribution

- **Conflicts:** rebase *your own* branch onto the updated base; resolve; force-push
  *your own* branch only. If the conflict is in logic you don't own, hand back with
  `needs:<other>` rather than guessing.
- **Attribution:** each agent commits under a distinct identity and adds a trailer so
  history is auditable, e.g. `Co-Authored-By: Hermes <hermes@…>` /
  `Co-Authored-By: Claude <noreply@anthropic.com>`. Never impersonate the other
  agent or edit its commits.

---

## Replicating to another repo

1. Copy this file to `.agents/COLLABORATION.md` in the target repo (keep it byte-identical).
2. Create the label set (Human setup checklist).
3. Add the branch-protection rules on `main`.
4. Point both agents at the repo. Both read this file first when they start work there.

---

## Human setup checklist (you do this once per repo)

- [ ] Create labels: `needs:claude`, `needs:hermes`, `agent:review`, `agent:blocked`, `agent:wip` (and `auto-merge-ok` only if you enable agent auto-merge).
- [ ] Branch protection on `main`: require PR, require CI to pass, require ≥1 review.
- [ ] Configure Hermes to: honor branch ownership (`hermes/*` only), read this file before acting, and never merge to `main`.
- [ ] Decide the merge policy (human-gated vs opt-in auto-merge) and record it above.
- [ ] Give each agent a distinct commit identity for clean attribution.
