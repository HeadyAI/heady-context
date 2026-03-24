# AGENTS.md — Heady AI Coding Agent Guidelines

> Version: 1.1.0 | Updated: 2026-03-22 | Applies to all 78 Heady repos
> Drop this file in the root of every repository for AI coding agent compatibility.

## Identity

This codebase belongs to **HeadySystems Inc.** — the Heady™ Latent-Space Operating System.
- **Founder:** Eric Haywood
- **Architecture:** Liquid Architecture v9.0
- **IP:** 60+ provisional patents — treat patent-locked zones with care

## Stack

| Layer | Tech | Notes |
|-------|------|-------|
| Backend | Node.js ESM, Express (Cloud Run), Hono (CF Workers) | No CommonJS `require()` |
| Frontend | Vanilla HTML/CSS/JS | No React/Vue/Angular |
| Database | Neon Postgres + pgvector | UUID PKs, TIMESTAMPTZ, vector(1536) |
| Cache | Upstash Redis | Namespace: `tenant:{id}:*` |
| Auth | Firebase Auth + 27 OAuth | Cross-domain SSO via `auth.headysystems.com` |
| Deploy | Cloud Run + CF Pages + CF Workers | φ-stepped canary: 5→25→50→100% |
| CI/CD | GitHub Actions + Turborepo | `turbo run build test --filter='...[origin/main...HEAD]'` |
| Observability | OpenTelemetry + Sentry + Langfuse | Structured JSON logs only |

## Coding Rules

1. **ESM only.** `import/export`, never `require()`.
2. **Zero `console.log`.** Use `pino` structured logger with `X-Heady-Trace-Id`.
3. **Zero `TODO`/`FIXME`/`HACK`.** If it's not done, don't commit it.
4. **Zero `localhost`.** All URLs from env vars. Cloud-deployed only.
5. **Zod validation** on all API inputs. No unvalidated data crosses service boundaries.
6. **HEADY_BRAND header** required in all new files (see template below).
7. **Redis keys** always namespaced: `tenant:{id}:*`.
8. **φ-derived constants.** Timeouts, TTLs, pool sizes from `phi-constants.js`. Zero magic numbers.
9. **Tests alongside code.** Vitest for unit, Playwright for E2E, k6 for load.
10. **Error handling everywhere.** No empty catch blocks. No swallowed promises.

## File Header Template

```javascript
// ╔══════════════════════════════════════════════════════════════════╗
// ║  HEADY™ [Module Name] v[X.Y.Z]                                ║
// ║  [One-line description]                                        ║
// ║  © 2026 HeadySystems Inc. — Eric Haywood, Founder              ║
// ╚══════════════════════════════════════════════════════════════════╝
```

## Architecture Patterns

- **Latent Service Pattern:** Every service exports `{ start, stop, health, metrics }`.
- **CSL Gates:** Use `cslGate(value, cosScore, tau)` for thresholds, not `if/else`.
- **φ-Scaling:** `phiBackoff()` for retries, `FIB[n]` for pool sizes, `PHI_7 * 1000` for heartbeats.
- **3-Tier Memory:** T0 Redis (hot, 21h) → T1 Neon pgvector (warm, 47h) → T2 Qdrant (cold, 144h).
- **Fallback Chain:** Every critical function has a fallback. Never single point of failure.
- **Circuit Breaker:** 5 failures → open, φ-backoff (1,618,034µs base), probe after 30s.

## Patent Lock Zones

Files marked with `⚠️ PATENT LOCK` require ARBITER swarm review before modification.
Patent IDs: HS-2026-051 through HS-2026-062.

## Environment Variables

All secrets from GCP Secret Manager or `.env` with `[SECRET]` markers. Key env vars:
- `ANTHROPIC_API_KEY`, `GROQ_API_KEY`, `OPENAI_API_KEY`, `GEMINI_API_KEY`
- `UPSTASH_REDIS_REST_URL`, `UPSTASH_REDIS_REST_TOKEN`
- `DATABASE_URL` (Neon Postgres)
- `INTERNAL_NODE_SECRET` (inter-service auth)
- `VAULT_PASSPHRASE` (API key encryption)

## Testing

```bash
# Unit tests
npx vitest run

# Lint
npx eslint src/ --ext .js,.ts

# Type check (if TS)
npx tsc --noEmit

# Build (monorepo)
npx turbo run build test --filter='...[origin/main...HEAD]'
```

## Deploy

```bash
# Cloud Run (φ-stepped canary)
gcloud run deploy heady-manager --image gcr.io/gen-lang-client-0920560496/heady-manager:$VERSION \
  --region us-central1 --min-instances 1 --max-instances 13

# Cloudflare Workers
npx wrangler deploy

# Cloudflare Pages
npx wrangler pages deploy dist/
```

## Do Not

- Add React, Vue, Angular, or any frontend framework
- Use `localhost`, `127.0.0.1`, or hardcoded URLs
- Write placeholder code, stubs, or TODO comments
- Use magic numbers — derive from `PHI`, `PSI`, or `FIB[]`
- Commit secrets to source control
- Skip error handling or validation
- Modify patent-locked files without review

## HeadyMCP Tools (via `mcp-servers/heady-mcp-server.js`)

Use these MCP tools for full ecosystem awareness:

| Category | Tools | Description |
|----------|-------|-------------|
| **Brain** | `heady_status` `heady_brain_think` `heady_brain_status` `heady_patterns_list` `heady_registry_list` | System intelligence, pattern recognition, registry catalog |
| **Files** | `heady_read_config` `heady_list_configs` `heady_project_tree` `heady_search` `heady_write_file` | Config management, project navigation, code search |
| **Deploy** | `heady_deploy_status` `heady_deploy_run` `heady_deploy_start` `heady_deploy_stop` | Deployment lifecycle management |
| **Health** | `heady_health_ping` `heady_deps_scan` `heady_secrets_scan` `heady_quickfix` `heady_code_stats` | Health checks, dependency scanning, auto-fixes |
| **Git** | `heady_git_status` `heady_git_log` `heady_git_diff` `heady_conflicts_scan` | Source control awareness |
| **Latent** | `heady_latent_record` `heady_latent_search` `heady_latent_status` | Latent-space memory system |
| **CodeLock** | `heady_codelock_status` `heady_codelock_lock` `heady_codelock_audit` | Change control & audit trail |
| **Translator** | `heady_translator_translate` `heady_translator_decode` `heady_translator_bridge` | Protocol translation |

## Antigravity / Gemini Integration

When operating inside Google Antigravity IDE:
- **Workflows**: All `/heady-*` slash commands are in `~/.agents/workflows/`
- **Skills**: AI Node attribution, Hybrid Drupal, and Production Domains skills in `~/.agents/skills/`
- **MCP Servers**: 6 active — `cloudrun`, `firebase`, `genkit`, `GitKraken`, `github`, `perplexity-ask`
- **Knowledge Items**: Check `~/.gemini/antigravity/knowledge/` for cached research and architecture docs
- **Master System Prompt**: See `~/.agents/HEADY_SYSTEM_PROMPT.md` for unified cross-IDE directives

## Key Workflows (Slash Commands)

| Command | Description |
|---------|-------------|
| `/heady-translator` | Translate user intent into action — never ask obvious questions |
| `/max-effort` | Zero limits, all resources, maximum parallel execution |
| `/no-placeholders` | Zero fake data — every line real and functional |
| `/heady-deploy-cloudrun` | Deploy any service to Cloud Run |
| `/heady-battle-arena` | Multi-node competitive evaluation |
| `/heady-emergency-protocol` | System breakage diagnostic and recovery |
| `/heady-no-local` | Enforce production domains — zero localhost |
| `/heady-connectors` | List and verify MCP connectors |
| `/heady-secret-rotation` | Rotate exposed API keys safely |
| `/heady-multi-remote-sync` | Sync all git remotes |

## Current Priority (March 22, 2026)

1. Configure GCP secrets in GitHub Actions (`GOOGLE_APPLICATION_CREDENTIALS`, `GCP_PROJECT_ID`)
2. Merge 130+ Dependabot vulnerability alerts — `vuln-triage.yml` nightly auto-triage active
3. Test coverage → 80% — `auto-test-gen.yml` tracks coverage on every PR
4. Deploy Cloudflare Worker for heady-ai.com (currently 522)
5. Rotate Anthropic API keys (4 revoked after exposure) — see `/heady-secret-rotation`
6. Activate HeadyPatterns RL loop (`src/learning/heady-patterns.js`) in production
7. Wire MCP servers (GitHub, Sentry, Neon, Cloudflare, Notion) into HeadyConductor
8. Unify prompt system — consolidate CLAUDE.md, AGENTS.md, .windsurfrules into master prompt
9. Fix headysystems.com broken links and deploy content updates
10. Microkernel integration tasks v9.0.4 (25 tasks from `heady_sovereign_intelligence` KI)

---

*∞ Sacred Geometry · Liquid Intelligence · Permanent Life ∞*
*© 2026 HeadySystems Inc. — Eric Haywood, Founder*
