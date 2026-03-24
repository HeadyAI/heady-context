# docs/incoming — task extraction drop zone

Drop markdown notes, audit snippets, or handoff bullets here. Numbered lists and action-verb bullets are parsed by `scripts/auto-extract-tasks.mjs`.

```bash
npm run extract:tasks
```

Writes `data/auto-extracted-tasks.json`. After review, merge into the canonical queue:

```bash
node scripts/merge-auto-extracted-tasks.mjs --dry-run
node scripts/merge-auto-extracted-tasks.mjs --write
```

See `.agents/workflows/auto-extract-tasks.md` for the full workflow.
