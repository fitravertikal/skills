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

## 2. Branch Protection (main)

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  -F required_status_checks='{"strict":true,"contexts":[]}' \
  -F enforce_admins=false \
  -F required_pull_request_reviews='{"required_approving_review_count":1}' \
  -F restrictions=null \
  -F required_linear_history=false \
  -F allow_force_pushes=false \
  -F allow_deletions=false \
  -F block_creations=false \
  -F required_conversation_resolution=true \
  -F lock_branch=false \
  -F allow_fork_syncing=true
```

> Catatan: Branch protection via API memerlukan repo **public** atau GitHub **Pro/Team**. Jika gagal (HTTP 403/422), setup manual di Settings → Branches → Add rule.

## 3. Copy `.agents/` Files

```bash
cp /tmp/skills/.agents/COLLABORATION.md .agents/
cp /tmp/skills/.agents/TOPOLOGY.md .agents/
git add .agents/ && git commit -m "chore: add agent collaboration config"
git push
```
