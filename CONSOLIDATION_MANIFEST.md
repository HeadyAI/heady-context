# Heady Ecosystem Consolidation Manifest

> Generated: 2026-03-21
> Purpose: Map 75 repos into a rationalized structure

## Consolidation Strategy

### Keep As-Is (12 repos) — Active, unique codebases
| Repo | Reason |
|------|--------|
| HeadyAI/Heady | Primary monorepo |
| HeadyAI/Sandbox | Development sandbox |
| HeadyConnection/Heady-Testing | Test infrastructure |
| HeadyMe/Heady-Staging | Staging environment |
| HeadyMe/latent-core-dev | Enterprise hub |
| HeadyMe/heady-production | Production deployment |
| HeadySystems/sandbox | Systems sandbox |
| HeadySystems/HeadyAutoContext | AI context packages |
| HeadySystems/HeadyEcosystem | Ecosystem orchestration |
| HeadyMe/HeadyBuddy | NanoClaw/OpenClaw agents |
| HeadyMe/HeadyWeb | Production micro-frontend |
| HeadyMe/heady-docs | Documentation hub |

### Archive Candidates (8 repos) — Monorepo clones
| Repo | Action |
|------|--------|
| HeadyConnection/Heady-Main | Archive → redirect to HeadyAI/Heady |
| HeadyMe/Heady-Main | Archive → redirect to HeadyAI/Heady |
| HeadyMe/Heady-Main-1 | Archive → redirect to HeadyAI/Heady |
| HeadyMe/Heady-Testing | Archive → redirect to HeadyConnection/Heady-Testing |
| HeadyMe/Heady-Staging | Keep as staging |
| HeadyAI/Heady-Staging | Archive → redirect to HeadyMe/Heady-Staging |
| HeadyAI/Heady-Testing | Archive → redirect to HeadyConnection/Heady-Testing |
| HeadyConnection/heady-clone | Archive → redirect to HeadyAI/Heady |

### Consolidate into Template-Driven Deploy (55 repos)

These repos share identical Node.js static-server scaffolds. Consolidate into a single
`heady-sites` monorepo with per-site configuration in `sites/{name}/site-config.json`.

**Scaffold Sites (no unique code):**
1ime1, admin-ui, headyapi, headybuddy-org, headyconnection, headyconnection-org,
headydocs, headyio, headyio-com, headymcp, headymcp-com, headymcp-production,
headyme, headyme-com, headyos, headysystems, headysystems-com, headysystems-production,
instant, ableton-edge-production, headybuddy-core (scaffold only)

**Integration Repos (minimal unique code, merge into monorepo):**
heady-atlas, heady-buddy-portal, heady-builder, heady-chrome, heady-critique,
heady-desktop, heady-discord, heady-discord-connection, heady-discord-connector,
heady-github-integration, heady-imagine, heady-jetbrains, heady-jules,
heady-kinetics, heady-logs, heady-maestro, heady-metrics, heady-mobile,
heady-montecarlo, heady-observer, heady-patterns, heady-pythia, heady-sentinel,
heady-slack, heady-stories, heady-traces, heady-vinci, heady-vscode

**Core Deploy Repos (keep as deploy targets):**
headyapi-core, headybot-core, headyconnection-core, headyio-core, headymcp-core,
headyme-core, headyos-core, headysystems-core

### Templates (3 repos) — Keep as template sources
| Repo | Purpose |
|------|--------|
| template-heady-ui | UI scaffold template |
| template-mcp-server | MCP server template |
| template-swarm-bee | Swarm agent template |

## Post-Consolidation Target

| Metric | Before | After |
|--------|--------|-------|
| Total repos | 75 | ~20 |
| Scaffold duplicates | 55 | 0 (1 monorepo) |
| CI coverage | 16% | 100% |
| .gitignore coverage | 7% | 100% |
| LICENSE coverage | 5% | 100% |
| .env.example coverage | 9% | 100% |

## Implementation Steps

1. Create `heady-sites` monorepo with Turborepo/pnpm workspaces
2. Migrate each scaffold site's `site-config.json` into `sites/{name}/`
3. Set up shared deploy workflow that reads per-site config
4. Archive old repos with redirect READMEs
5. Update DNS/CI to point to new monorepo
