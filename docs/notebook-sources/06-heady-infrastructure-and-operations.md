# Heady™ Infrastructure & Operations — NotebookLM Source
**Version:** 8.0 | **Updated:** March 24, 2026

## Multi-Remote Git Topology (16 Remotes)
The Heady codebase is distributed across 16 git remotes — a deliberate sovereign redundancy mesh:

### GitHub Organizations (4)
| Org | Main | Staging | Testing |
|-----|------|---------|---------|
| HeadyAI | headyai/main | headyai-staging/main | headyai-testing/main |
| HeadyMe | production/main | staging/main | heady-testing/main |
| HeadySystems | hs-main/main | hs-staging/main | hs-testing/main |
| HeadyConnection | hc-main/main | — | hc-testing/main |

### Azure DevOps
| Remote | Repository |
|--------|-----------|
| azure-main | Heady-AI/Heady |
| azure-staging | Heady-AI/Heady-Staging |
| azure-testing | Heady-AI/Heady-Testing |

### Additional
| Remote | Repository |
|--------|-----------|
| hs-ecosystem | HeadySystems/HeadyEcosystem |
| hs-sandbox | HeadySystems/sandbox |

### Repository Stats (March 24, 2026)
- Total commits on main: 4,030
- Total tracked files: 51,358
- Total JS/TS source files: 11,567
- LFS objects: 6,602 (5.0 GB)
- Local branches: main (active), integration/ai-remote-sync, staging, testing, fix/heady/p0-conflicts

## March 20-24 Consolidation Sprint — The Great Merge
In 5 days, the Heady repository underwent massive consolidation:

| Day | Commits | Files Changed | Insertions | Deletions |
|-----|---------|--------------|------------|-----------|
| Mar 24 | pipeline auto-commits | ongoing | ongoing | ongoing |
| Mar 23 | 454 | 4,416 | 740,714 | 620,179 |
| Mar 22 | 210 | 2,795 | 240,212 | 427,152 |
| Mar 21 | 631 | 45,515 | 713,967 | 7,222,413 |
| Mar 20 | 136 | 1,078 | 12,640 | 3,814 |

**Total: 1,431 commits, 53,804 files changed, 1.7M insertions**

### What Happened
- Cherry-picked 100+ valuable remote branches into main
- Merged dependabot security updates across all remotes
- Consolidated Claude, Jules, and Codex AI agent contributions
- Integrated CSL hardening, autonomous self-healing infrastructure
- Extracted site generation improvements
- Ran `git lfs migrate import --above=50mb` — rewrote 8,561 commits to convert all files >50MB to LFS pointers
- Resolved tree-level conflicts from heavy divergence

## Google Cloud Platform

### Project: heady-ai (ID: 1003436179562)
- **Region:** us-east1
- **Services:** Cloud Run (297 services), Cloud Build, Artifact Registry
- **Auth:** Firebase Auth, GCP Secret Manager
- **Database:** Neon Postgres (pgvector), Upstash Redis

### Cloud Run Deployment Pattern
```
Source deploy (no Docker push):
gcloud run deploy SERVICE --source . --project heady-ai --region us-east1

With env-vars-file:
gcloud run deploy SERVICE --env-vars-file .env.yaml
```

### GCP Secret Manager
HeadyVault integrates with GCP Secret Manager via SecretManagerBackend class — zero-intervention automatic unlocking. Secrets synced from 1Password via `scripts/op-seed-vault.js`.

## Cloudflare Infrastructure

### DNS Zones (12+ domains)
All domains use Cloudflare-proxied DNS:
- A record: 192.0.2.1 (Cloudflare proxy)
- AAAA record: 100:: (Cloudflare proxy)
- Worker route: `domain.com/*` → `liquid-gateway-worker`
- Host header: `X-Forwarded-Host` → Cloud Run `dynamic-site-server.js`

### Security Hardening
- Zero `unsafe-eval` Content Security Policy
- 16-domain CORS whitelist (no wildcards)
- Cloudflare WAF + DDoS protection on all domains
- Workers-based request filtering
- mTLS certificates for service mesh

## Three-Ring KV Audit System
Immutable provenance for all swarm orchestration and pipeline transitions:
- **Ring 1 (Edge KV):** Real-time, microsecond writes at the edge
- **Ring 2 (Upstash Redis):** Session-level aggregation, rate limiting
- **Ring 3 (Neon Postgres):** Permanent, queryable audit trail with Ed25519 signatures

## Autonomous Operations

### Auto-Success Engine
Self-healing loop running on φ⁷ heartbeat (29,034ms cycle):
- 144 tasks across 13 categories
- Monitors all services, detects failures, auto-restarts
- Pattern learning from each incident
- Wisdom enforcement via trust receipts

### HCFullPipeline Auto-Commit
The pipeline automatically commits changes with structured messages:
- `HCFP-AUTO: N file(s) changed — file1, file2, ...`
- `feat(auto): description [tier=SIGNIFICANT/TRIVIAL]`
- Runs continuously, 297 auto-commits in last 5 days

### Multi-Agent Contributions
The codebase receives contributions from multiple AI agents:
- **Claude** (Anthropic): 191 commits — deep architecture, security hardening
- **Jules** (Google): 5 commits — optimization, formatting, region fixes
- **Codex** (OpenAI): Integration batches — docs, ADRs, buddy widget
- **Dependabot**: 39 commits — automated dependency updates

## CI/CD & Workflows
- GitHub Actions workflows for all Cloud Run services
- `deploy-auth-server.yml`, `deploy-buddy-api.yml`, `deploy-hf-discord.sh`
- Self-healing CI with `selfheal-{SHA}` branch pattern
- Promote-to-staging workflow with manual approval gate

## Monitoring & Observability
- Sentry DSN wired to auth-session-server, liquid-gateway-worker, mcp-server, buddy-api
- OpenTelemetry trace propagation across MCP sessions
- Structured pino logging across all services
- Health endpoints: `/health` or `/api/health` on every service
- HeadyLens monitoring dashboard at admin.headysystems.com

## HuggingFace Integration
Models and datasets hosted at huggingface.co/HeadySystems:
- **heady-embeddings-384d** — Fast CSL embedding model
- **heady-csl-classifier** — CSL gate classification
- **heady-buddy-chat** — Conversation model
- **heady-ecosystem-docs** — Full documentation dataset
- **heady-csl-operations** — CSL operation traces
- **heady-sacred-geometry-topology** — Sacred geometry dataset
