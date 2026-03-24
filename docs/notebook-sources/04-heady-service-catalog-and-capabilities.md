# Heady™ Service Catalog & Capabilities — NotebookLM Source
**Version:** 8.0 | **Updated:** March 24, 2026

## Service Architecture Overview
The Heady platform runs 297 services across Google Cloud Run and Cloudflare Workers, orchestrated by the HCFullPipeline v8.0 and the 17-Swarm Matrix. All services are containerized Node.js applications deployed to Cloud Run (project: heady-ai, region: us-east1) with edge routing through 17 Cloudflare Workers.

## Core Cloud Run Services

### Gateway & Routing
| Service | Purpose |
|---------|---------|
| heady-manager (port 3300) | Central API gateway + AutoContext orchestrator |
| headyme-site | Dynamic multi-site server — renders all 12 branded domains |
| api-gateway | Structured pino logging, request routing |
| liquid-gateway-worker | Main Cloudflare traffic routing for all domains |

### Authentication & Security
| Service | Purpose |
|---------|---------|
| auth-session-server | Firebase Auth + JWT sessions + RBAC + Neon Postgres |
| heady-auth | Full auth service with MFA, RBAC engine, admin routes |
| HeadyVault | Secrets lifecycle — GCP Secret Manager + 1Password sync |
| edge-auth-worker | Zero-trust edge authorization |

### Intelligence & AI
| Service | Purpose |
|---------|---------|
| heady-buddy-api | LLM routing + pgvector + chat storage |
| csl-engine | Continuous Semantic Logic — 8 geometric gates |
| auto-success-engine | Self-healing loop with φ⁷ heartbeat (29,034ms) |
| heady-conductor | Orchestration conductor — mechanism layer |
| policy-engine | HeadyMCP per-action policy evaluation |

### Communication & Integration
| Service | Purpose |
|---------|---------|
| heady-discord-bot | Discord bot (Cloud Run, scaffold mode) |
| heady-huggingface-gateway | HuggingFace model/dataset gateway |
| notification-service | Webhook and notification delivery |
| mcp-server | MCP Streamable HTTP server (64 tools) |

### Pipeline & Orchestration
| Service | Purpose |
|---------|---------|
| hcfullpipeline-executor | 22-stage pipeline task execution |
| battle-sim-task-orchestrator | 9-stage competitive pipeline |
| heady-distiller | Stage 21 — knowledge distillation |
| swarm-coordinator | 17-swarm matrix coordination |

## Cloudflare Workers (17)
| Worker | Purpose |
|--------|---------|
| liquid-gateway-worker | Primary domain routing (host-based) |
| api-gateway | Edge API routing |
| auth-service | Edge authentication |
| edge-auth-worker | Edge authorization |
| edge-composer | Edge content composition |
| edge-proxy | Edge reverse proxy |
| heady-buddy-worker | AI companion edge logic |
| heady-mcp-worker | MCP protocol handler |
| mcp-transport | MCP transport layer (SSE/WebSocket/Streamable HTTP) |
| worker-heady-router | DNS-level routing |
| heartbeat.js | Health monitoring |

## 64 MCP Tools (HeadyMCP Server)
The MCP server exposes 64 tools organized by domain:

### Core Tools (16)
health, echo, system-status, version, capabilities, config-get, config-set, log-query, metric-query, trace-query, secret-get, secret-set, audit-log, event-emit, event-subscribe, rate-limit-check

### Engine Tools (16)
csl-gate, csl-embeddings, csl-similarity, vector-store, vector-search, vector-delete, memory-tier-get, memory-tier-set, pipeline-run, pipeline-status, swarm-dispatch, bee-spawn, bee-status, arena-compete, monte-carlo-sim, distill

### Service Tools (16)
deploy-service, service-health, service-scale, worker-deploy, dns-configure, ssl-provision, auth-token-exchange, auth-verify, session-create, session-invalidate, notification-send, webhook-register, file-upload, file-download, db-query, cache-invalidate

### Billing Tools (16)
stripe-meter-event, stripe-customer-create, stripe-subscription-create, usage-report, cost-forecast, payout-calculate, invoice-generate, treasury-balance, revenue-report

## 60+ Agent Skills

### Core Skills
heady-deep-scan, heady-memory-ops, heady-code-generation, heady-deployment, heady-research, heady-multi-model, heady-security-audit

### Architecture Skills
heady-liquid-gateway, heady-edge-ai, heady-mcp-streaming-interface, heady-gateway-routing, heady-ide-control-plane

### Memory & Knowledge
heady-companion-memory, heady-memory-knowledge-os, heady-graph-rag-memory, heady-hybrid-vector-search, heady-embedding-router

### Operations
heady-bee-swarm-ops, heady-incident-ops, heady-reliability-orchestrator, heady-self-healing-lifecycle, heady-drift-detection

### Security
heady-pqc-security, heady-mcp-gateway-zero-trust, heady-middleware-armor

### Specialized
heady-csl-engine, heady-phi-math-foundation, heady-battle-arena, heady-trading-intelligence, heady-voice-relay, heady-midi-creative, heady-monetization-platform

## AI Provider Integration

### Supported Providers
| Provider | Models | Use Case |
|----------|--------|----------|
| OpenAI | gpt-5.4-xhigh-fast | Primary code generation, chat |
| Anthropic | claude-opus-4.6-thinking | Deep reasoning, analysis |
| Google | gemini-3.1-pro-preview, gemini-3-flash-preview | Fast inference, multimodal |
| Groq | llama-3.3-70b-versatile | Ultra-low latency |
| Perplexity | sonar-pro, sonar-deep-research | Web search, citations |
| Hugging Face | Various | Embeddings, specialized models |

### Routing Strategies
- **fastest-wins**: Race providers, return first response
- **race_and_failover**: Race top 2, failover to next on failure
- **cost-optimized**: Route to cheapest provider meeting quality threshold
- **CSL-gated**: Cosine similarity scoring to select best provider per task
- **Thompson Sampling**: Multi-armed bandit with Beta distribution posteriors

## Database & Storage Stack
| System | Purpose |
|--------|---------|
| Neon Postgres + pgvector | Primary data + 1536D vector embeddings |
| Upstash Redis | Session cache, rate limiting, audit ring 2 |
| Cloudflare KV | Edge state, audit ring 1 |
| GCP Secret Manager | Production secrets management |
| HeadyMemory 3-tier | T0 working (21h) / T1 short-term (47h) / T2 long-term (144h) |
