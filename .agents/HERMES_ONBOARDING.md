# Hermes Onboarding — Repo Setup

Jalankan perintah berikut di root repo untuk menyiapkan koordinasi Hermes ↔ Claude Code.

## 1. Label Koordinasi

```bash
gh label create "needs:claude" --color "0969DA" --description "Menunggu aksi Claude Code"
gh label create "needs:hermes" --color "BF8700" --description "Menunggu aksi Hermes"
gh label create "agent:review" --color "8250DF" --description "Menunggu review dari agent lain"
gh label create "agent:blocked" --color "CF222E" --description "Terblokir — butuh intervensi Fitra"
gh label create "agent:wip" --color "1A7F37" --description "Sedang dikerjakan agent"
```

## 2. Branch Protection

> **Public repos only.** Private repos require GitHub Pro/Team — setup manual di Settings → Branches → Add rule.

```bash
gh api repos/{owner}/{repo}/branches/{branch}/protection \
  --method PUT --input - << 'JSON'
{
  "required_status_checks": null,
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1
  },
  "restrictions": null,
  "required_linear_history": false,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "block_creations": false,
  "required_conversation_resolution": true,
  "lock_branch": false,
  "allow_fork_syncing": true
}
JSON
```

> Ganti `{branch}` dengan nama default branch (biasanya `main` atau `master`).

## 3. Copy `.agents/` Files

```bash
cp /tmp/skills/.agents/COLLABORATION.md .agents/
cp /tmp/skills/.agents/TOPOLOGY.md .agents/
git add .agents/ && git commit -m "chore: add agent collaboration config"
git push
```
