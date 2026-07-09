# Agent Collaboration Protocol

GitHub adalah satu-satunya kanal bersama antara Hermes dan Claude Code.
Tidak ada link antar-agent langsung — setiap intent, handoff, dan hasil harus
berupa branch, commit, PR, issue, label, atau komentar.

## Identitas & Batas

| Aturan | Detail |
|---|---|
| **Commit identity** | Hermes: commit sebagai Hermes + trailer `Co-Authored-By: Hermes <hermes@epslab.id>`. Jangan menyamar/mengedit commit Claude. |
| **Branch ownership** | Hermes memiliki `hermes/*`, Claude memiliki `claude/*`. Hanya commit di branch milik sendiri. Jangan pernah push ke branch agent lain. |
| **Force-push** | Jangan force-push branch yang bukan milikmu. |

## Workflow: Satu Tugas = Satu Issue

```
Issue → Branch → PR (draft) → Handoff → Review → Ready → Merge (Fitra)
```

1. **Satu tugas = satu GitHub issue.** Branch & PR merujuk padanya (`Fixes #N`).
2. **Semua PR mulai sebagai draft.** Tandai `ready for review` hanya saat yakin mergeable.
3. **Handoff eksplisit.** Saat ingin agent lain bertindak:
   - Posting komentar berisi:
     - **Done**: apa yang kamu ubah
     - **Want**: aksi berikutnya yang diminta
     - **Context**: yang tak jelas dari diff
   - Lepas label `agent:wip`
   - Tambah `needs:claude` / `needs:hermes` / `agent:review`
   - Assign ke agent berikutnya
   - **Berhenti** sampai dikembalikan.
4. **Bertindak hanya atas labelmu.** Ambil kerjaan berlabel `needs:hermes` (ganti jadi `agent:wip` saat mulai). Jangan bertindak atas label buatan aksimu sendiri, jangan balas komentarmu sendiri.

## Loop Guard

Jika satu issue bolak-balik **3× tanpa jadi ready**:
- Tambah label `agent:blocked`
- Tulis catatan singkat "di mana macetnya"
- Tunggu Fitra. Jangan lempar tugas tanpa henti.

## Merge Gate

- **Jangan merge ke main.** Siapkan & review PR; Fitra yang merge.
- Ini kebijakan, bukan batasan teknis.

## Reaksi ke State

Baca ulang state issue/PR terkini sebelum bertindak. Jangan mengandalkan notifikasi basi atau asumsi.

## Label Reference

| Label | Arti |
|---|---|
| `needs:claude` | Menunggu aksi Claude Code |
| `needs:hermes` | Menunggu aksi Hermes |
| `agent:review` | Menunggu review dari agent lain |
| `agent:blocked` | Terblokir — butuh intervensi Fitra |
| `agent:wip` | Sedang dikerjakan agent |
