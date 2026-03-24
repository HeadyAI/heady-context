# Heady™ Project Context Repository

> **Comprehensive, synced source of truth** for the entire Heady ecosystem — architecture, patents, research, prompts, configs, and documentation.

## Purpose
This repo is a **living mirror** of all meaningful documentation from the [HeadyAI/Heady](https://github.com/HeadyAI/Heady) monorepo. It serves as:

- 📚 **NotebookLM source** — Upload files directly for AI-generated audio/video overviews
- 🤖 **AI assistant context** — Feed to any LLM for deep Heady knowledge
- 🎓 **Developer onboarding** — Comprehensive reference for new contributors
- 📋 **IP evidence** — Patent documentation with code-to-claim mappings

## Stats
| Metric | Value |
|--------|-------|
| Total markdown docs | 2,527 |
| Config/data files | 164 JSON |
| Total size | ~39 MB |
| Source repo | HeadyAI/Heady |
| Last synced | March 24, 2026 |

## Structure

```
├── docs/                    # Primary documentation
│   ├── architecture/        # System architecture (45 docs)
│   ├── patents/             # Patent portfolio (17 docs)
│   ├── research/            # Deep research sections (7 docs)
│   ├── adr/                 # Architecture Decision Records (121 docs)
│   ├── notebook-sources/    # NotebookLM-optimized sources (6 docs)
│   ├── csl-specs/           # CSL gate specifications
│   ├── prompts/             # System prompts & agent prompts
│   ├── super-prompts/       # Heady Super Prompt versions
│   └── ...
├── configs/                 # System configurations
│   ├── agent-profiles/      # AI agent system prompts
│   ├── prompts/             # Extended prompt library
│   ├── hcfullpipeline-tasks.json  # 22-stage pipeline config
│   └── swarm-definitions.json     # 17-swarm taxonomy
├── research/                # Research papers & analysis
├── audit/                   # Security audits & analysis reports
├── patents/                 # Patent filings (mirror)
├── heady-skills/            # Agent skill definitions
├── heady-implementation/    # Implementation guides
├── context/                 # Perplexity/external context
├── dropzone/                # AI prompt collections
├── services/                # Service-level documentation
├── headybuddy/              # HeadyBuddy companion docs
├── notebooks/               # Jupyter/NotebookLM templates
├── BUDDY_KERNEL.md          # Liquid Latent OS boot kernel
└── site-registry.json       # 12-domain registry
```

## Quick Start for NotebookLM

Upload these key files for a comprehensive overview:

1. `docs/notebook-sources/01-heady-executive-overview.md`
2. `docs/notebook-sources/02-heady-apex-trading-intelligence.md`
3. `docs/notebook-sources/03-heady-ip-portfolio-and-valuation.md`
4. `docs/notebook-sources/04-heady-service-catalog-and-capabilities.md`
5. `docs/notebook-sources/05-heady-architecture-and-patterns.md`
6. `docs/notebook-sources/06-heady-infrastructure-and-operations.md`

For maximum depth, upload everything in `docs/`, `configs/`, and `research/`.

## Key Documents

| Document | Description |
|----------|-------------|
| `BUDDY_KERNEL.md` | The Liquid Latent OS initialization kernel |
| `docs/architecture/MICROKERNEL_ARCHITECTURE.md` | Microkernel theory → Heady mapping |
| `docs/architecture/sovereign-heady-blueprint.md` | Six-layer zero-trust mesh |
| `docs/HEADY_SUPER_PROMPT_v9.0.md` | Latest super prompt |
| `docs/patents/patent_portfolio_full.md` | Complete patent portfolio |
| `configs/hcfullpipeline-tasks.json` | 22-stage pipeline task definitions |
| `configs/swarm-definitions.json` | 17-swarm taxonomy |

## Sync
This repo is synced from the main Heady monorepo. To refresh:
```bash
cd ~/Heady && bash ~/heady-context/copy-context.sh
cd ~/heady-context && git add -A && git commit -m "sync: $(date +%Y-%m-%d)" && git push
```

---
**HeadySystems Inc.** | © 2026 | [headyme.com](https://headyme.com)
