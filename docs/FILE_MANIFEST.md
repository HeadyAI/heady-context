# Tier A — File-Level Manifest (heady-ai @ rebuild)

> Companion to `ECOSYSTEM_AUDIT.md`. Result of running the canonical repo's own
> scanners (deps installed via `pnpm install --frozen-lockfile`). Read-only; no
> files deleted.

## Scanners run

| Scanner | Result |
|---------|--------|
| `tooling/coherence/src/coherence.mjs all` | **PASS** — system map 269 nodes / 51 edges; variable registry 370 entries (12 env · 26 secret · 21 const · 45 fact · 57 term · 8 agent · 35 bee · 135 skill · 31 decision); **0 contradictions**, 1 incomplete. No duplicate-source-of-truth conflicts. |
| `pnpm exec knip` (orphan/dead-export) | **NOT AVAILABLE** — `knip` is not a dependency. Orphan-export detection is unwired. |
| `pnpm run scan:stale` | **BROKEN on rebuild** — `MODULE_NOT_FOUND` (legacy `scripts/stale-scanner.js` not ported to the rebuild layout). |
| static pass (archive dirs · dup hashes · large blobs) | see below |

## Findings — canonical repo is clean

- **KEEP / intentional:** `governance/legacy/` (7 files) — the deliberate provenance freeze from the governance-corpus transfer. Not cruft.
- **KEEP (consider Git LFS):** `docs/patents/*` — the largest tracked files are patent PDFs/ZIPs (legitimate IP, ~0.8–1.6 MB each). They dominate repo weight; migrating to Git LFS would slim clones without losing the assets.
- **REVIEW:** **42 content-hash groups shared by ≥2 files** — duplicate-content sets. Most are likely legitimate (repeated templates/configs), but this is the list to eyeball for genuine duplication.
- **No `_archive`/`deprecated`/`backup` dead-weight** inside `rebuild` (unlike legacy `main`, which carries `_archive/`, `heady-monorepo/`, and `remotes/` copies).

**Conclusion:** there is essentially nothing to *eliminate* inside the canonical
`rebuild` repo — it is coherent and lean. The eliminate/archive action is almost
entirely at the **org level** (the ~110 repos + duplicate Workers), which is what
`scripts/ecosystem-cleanup.sh` (Tier C) targets.

## Gaps to close (wire real orphan-detection into the gate)

Per the consistency-engine plan, the rebuild should gain genuine dead-code
detection so this manifest can be regenerated mechanically:
1. Add `knip` + `dependency-cruiser` as dev deps with configs; `knip ∩ depcruise` = orphan.
2. Port `scan:stale` to the rebuild layout (or retire it in favour of knip).
3. Add a `governance` CI step running them in `--diff` so orphans fail new PRs.

Until then, **coherence (0 contradictions)** is the trustworthy file-level signal,
and the org-level cleanup (Tier C) is where the real reclamation is.
