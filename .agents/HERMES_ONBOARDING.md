# Message to Hermes — collaboration onboarding

> Paste this to Hermes. It onboards Hermes into the GitHub-mediated workspace it
> now shares with Claude Code. Reusable across every repo you want in the workspace.

---

Hermes — you're now collaborating with **Claude Code** inside my repos, and
**GitHub is our only shared channel**. There is no direct agent-to-agent link:
every intent, handoff, and result must be a branch, commit, PR, issue, label, or
comment. If it isn't on GitHub, the other agent can't see it.

**Before you act in any repo, read `.agents/COLLABORATION.md` and
`.agents/TOPOLOGY.md` in that repo and follow them.** They are the source of
truth; this message is just the summary.

## Your role and boundaries

- **Identity:** commit as Hermes and add a trailer `Co-Authored-By: Hermes <…>`
  so history is auditable. Never impersonate or edit Claude's commits.
- **Branch ownership:** you own `hermes/*` and commit only there. **Never push to
  `claude/*`** and never force-push a branch you don't own.
- **Authority ≠ permission.** You have full authority across my repos, but you
  honor these rules as policy — like a trusted senior engineer who has admin but
  still follows process.

## How we work

1. **One task = one GitHub issue.** Branches and PRs reference it (`Fixes #123`).
2. **All PRs start as draft.** Mark *ready for review* only when you believe it's
   mergeable.
3. **Hand off explicitly.** When you want Claude Code to act, post one comment with
   **Done** (what you changed), **Want** (the exact next action), **Context**
   (anything not obvious from the diff); then remove your `agent:wip` label, add
   `needs:claude` (or `agent:review` for a review request), and assign it. Then
   stop working that issue until it's handed back.
4. **Act only on your labels.** Take work labeled `needs:hermes` (swap it to
   `agent:wip` when you start). Never act on a label your own last action created,
   and never reply to your own comments.
5. **Loop guard:** if one issue bounces between us **3 times** without reaching
   *ready for review*, add `agent:blocked`, write a short "where we're stuck" note,
   and wait for me. Never trade a task indefinitely.
6. **Merge gate:** **do not merge to `main`.** Prepare and review PRs; I merge.
   (Even though you technically can — don't.)
7. **React to state, not stale notifications.** Re-read the current issue/PR state
   before acting; the baton may have already moved.

## Setup tasks I'm asking you to do now

For each repo you should join to this workspace:

1. **Create the coordination labels:**
   ```bash
   gh label create "needs:claude"  --repo <owner>/<repo> --color 6f42c1 --description "Claude Code should pick this up" --force
   gh label create "needs:hermes"  --repo <owner>/<repo> --color d93f0b --description "Hermes should pick this up"      --force
   gh label create "agent:review"  --repo <owner>/<repo> --color fbca04 --description "Ready for the other agent to review the PR" --force
   gh label create "agent:blocked" --repo <owner>/<repo> --color b60205 --description "Stuck — needs a human decision"   --force
   gh label create "agent:wip"     --repo <owner>/<repo> --color 0e8a16 --description "Actively being worked; do not touch" --force
   ```
2. **Enable branch protection on `main`:** require a PR, require status checks to
   pass, and require at least one approving review.
3. **Copy the protocol files** (`.agents/COLLABORATION.md`, `.agents/TOPOLOGY.md`)
   into any repo that doesn't have them yet, keeping them byte-identical to the
   canonical copy in `fitravertikal/skills`.

Report back with the list of repos you configured and any where branch protection
couldn't be set, so I can finish those manually.
