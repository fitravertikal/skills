# Agent Collaboration Setup — Final Report

> Generated: 2026-07-09 by Hermes
> Canonical source: `fitravertikal/skills` → `.agents/`

---

## Ringkasan

12 repo dikonfigurasi untuk kolaborasi Hermes ↔ Claude Code via GitHub.
7 **public** berhasil penuh (`.agents/` + labels + branch protection).
5 **private** berhasil sebagian — branch protection perlu GitHub Pro.

---

## ✅ Full Success (7 repos)

| Repo | Visibility | Default Branch | `.agents/` | Labels (5) | Branch Protection |
|---|---|---|---|---|---|
| `fitravertikal/skills` | public | `main` | ✅ | ✅ | ✅ |
| `fitravertikal/Agent-Reach` | public | `main` | ✅ | ✅ | ✅ |
| `fitravertikal/loki` | public | `main` | ✅ | ✅ | ✅ |
| `fitravertikal/ai-engineering-from-scratch` | public | `main` | ✅ | ✅ | ✅ |
| `fitravertikal/bibliometrix` | public | `master` | ✅ | ✅ | ✅ |
| `fitravertikal/odoo` | public | `19.0` | ✅ | ✅ | ✅ |
| `fitravertikal/office` | public | `main` | ✅ | ✅ | ✅ |

---

## ⚠️ Partial — Branch Protection Gagal (5 private repos)

| Repo | Branch | `.agents/` | Labels | Branch Protection |
|---|---|---|---|---|
| `fitravertikal/edss` | `main` | ✅ | ✅ | ❌ HTTP 403 — perlu GitHub Pro |
| `fitravertikal/epslab_server` | `main` | ✅ | ✅ | ❌ HTTP 403 — perlu GitHub Pro |
| `fitravertikal/hermes-mirror` | `master` | ✅ | ✅ | ❌ HTTP 403 — perlu GitHub Pro |
| `fitravertikal/slr-engine` | `main` | ✅ | ✅ | ❌ HTTP 403 — perlu GitHub Pro |
| `fitravertikal/ssds` | `main` | ✅ | ✅ | ❌ HTTP 403 — perlu GitHub Pro |

### Cara resolve

Opsi:
1. **GitHub Pro** ($4/bln) — enable branch protection di semua private repo via API atau UI.
2. **Bikin repo jadi public** — kalau tidak ada data sensitif.

Setelah Pro aktif, jalankan dari `HERMES_ONBOARDING.md`:

```bash
gh api repos/fitravertikal/{repo}/branches/{branch}/protection   --method PUT --input - << 'JSON'
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

Atau setup manual: Settings → Branches → Add rule → target branch, centang "Require a pull request before merging" + "Require approvals" (1).

---

## Repo yang Tidak Dikonfigurasi

| Repo | Alasan |
|---|---|
| `fitravertikal/epslab-backups` | Backup repo — bukan development |
| `fitravertikal/desktop-tutorial` | Tutorial — bukan development |
| `fitravertikal/metadata-bulk-operations-sample-for-aws-iot-sitewise` | Sample project |
| `fitravertikal/Inventor-Training-Material` | Training material |

---

## File Kanonik

Semua file di `fitravertikal/skills/.agents/`:

| File | Isi |
|---|---|
| `COLLABORATION.md` | Protokol handoff, identitas, branch ownership, loop guard, merge gate |
| `TOPOLOGY.md` | Daftar agent, branch prefix, repo roster |
| `HERMES_ONBOARDING.md` | Perintah setup: labels + branch protection (format API benar) |

---

## Labels Koordinasi (berlaku di semua repo)

| Label | Warna | Arti |
|---|---|---|
| `needs:claude` | `#0969DA` | Menunggu aksi Claude Code |
| `needs:hermes` | `#BF8700` | Menunggu aksi Hermes |
| `agent:review` | `#8250DF` | Menunggu review dari agent lain |
| `agent:blocked` | `#CF222E` | Terblokir — butuh intervensi Fitra |
| `agent:wip` | `#1A7F37` | Sedang dikerjakan agent |

---

## Catatan Teknis

- **Format API branch protection** di `HERMES_ONBOARDING.md` v1 salah: pakai `-F` (form/string) → selalu HTTP 422. v2 sudah benar: `--input -` dengan JSON object.
- **`odoo`** punya `.gitignore` yang memblokir `.agents/` — perlu `git add -f .agents/`.
- **`hermes-mirror`** dan **`bibliometrix`** pakai `master`, bukan `main`.
- **`odoo`** default branch `19.0`, bukan `main`.
