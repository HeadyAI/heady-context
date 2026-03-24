# Auto-extract pipeline — implementation tasks

1. Implement `scripts/merge-auto-extracted-tasks.mjs` to merge reviewed rows from `data/auto-extracted-tasks.json` into `configs/hcfullpipeline-tasks.json` with title deduplication and per-prefix ID assignment.
2. Document the `docs/incoming/` drop zone in root `README.md` or developer docs and standardize running `npm run extract:tasks` after adding sources here.
3. Append a dated summary block to `docs/extracted-report-tasks.md` when merge runs with `--write` so the log stays aligned with JSON changes.
4. Add an optional GitHub Actions workflow that runs `npm run extract:tasks` on pull requests touching `docs/**/*.md` or `docs/incoming/**` and uploads `data/auto-extracted-tasks.json` as an artifact for human review.
5. Extend `scripts/auto-extract-tasks.mjs` to capture standalone lines containing **should** or **must** as actionable items when they are not already covered by numbered or bulleted patterns.
