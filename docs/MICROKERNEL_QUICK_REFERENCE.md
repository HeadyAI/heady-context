# HEADY™ Microkernel Liquid Latent Architecture — Quick Reference

> **Version:** 10.0 | **Date:** 2026-03-21 | **Status:** Production Spec
> **© 2026 HeadySystems Inc. — Eric Haywood, Founder**
> **φ = 1.6180339887498948 — All constants derived. Zero magic numbers.**

---

## Kernel TCB (Trusted Computing Base)

| Subsystem | File | LOC | Patent |
|-----------|------|-----|--------|
| IPC Bus | `core/ipc/envelope.js` + `core/ipc/router.js` | ~380 | HS-2026-051 |
| CSL Gate Engine | `csl-engine-v2.js` + `core/csl/gates.js` | ~420 | HS-2026-052 |
| Capability Manager | `core/capabilities/manager.js` | ~350 | HS-2026-053 |
| Memory Arbiter | `core/memory/arbiter.js` | ~480 | HS-2026-058 |
| Heartbeat Scheduler | `core/heartbeat/scheduler.js` | ~340 | HS-2026-059 |
| **Total TCB** | | **~1,970** | |

## Four Laws (Kernel Invariants)

```
Law 1 — LIQUIDITY:      Every node has a fallback. Kernel rejects registration without one.
Law 2 — φ-PURITY:       All constants from phi-math-v2.js. Kernel rejects non-φ values at boot.
Law 3 — SOVEREIGNTY:    Zero localhost. Kernel validates all pulse_url are HTTPS with real domains.
Law 4 — ZERO PLACEHOLDERS: Stubs cannot acquire capabilities. Proof-of-implementation required.
```

## CSL Gate Hierarchy

```
Level    Threshold    Formula              Use
───────  ─────────    ───────              ───
SUPPRESS   0.236      1 − ψ⁰ × ψ          Noise filtering
RECALL     0.382      1 − ψ¹ × ψ          Memory retrieval eligibility
INCLUDE    0.618      1 − ψ² × ψ          Response context inclusion
BOOST      0.691      1 − ψ³ × ψ          Elevated confidence routing
INJECT     0.809      1 − ψ⁴ × ψ          Active context injection
CRITICAL   0.882      1 − ψ⁵ × ψ          Deployment/security gates
ABSOLUTE   0.927      1 − ψ⁶ × ψ          Kernel-level operations
```

## IPC Envelope Schema

```javascript
{
  id:         UUID,           // Message ID
  timestamp:  ISO-8601,       // Created at
  source:     string,         // Sender node ID
  target:     string,         // Receiver node ID or "*" for broadcast
  capability: string,         // Capability token (seL4-style)
  type:       enum,           // request|response|event|heartbeat|...
  domain:     string,         // CSL domain for semantic routing
  payload:    any,            // Zero-copy forwarded (kernel doesn't deserialize)
  ttl_ms:     number,         // Default: fib(12) × 1000 = 233,000
  priority:   number [0,1],   // CSL score (NOT integer priority)
  trace_id:   UUID,           // Distributed trace correlation
  hash:       SHA-256,        // Integrity verification
}
```

## 6 Permission Scopes

| Scope | Rate Limit | Approval | Tools |
|-------|-----------|----------|-------|
| `cognitive` | 89/min (fib(10)) | No | LLM, embedding, vector search, RAG |
| `deploy` | 8/min (fib(5)) | **Human** | Cloud Run deploy, CF publish, canary |
| `ops` | 55/min (fib(9)) | No | Health checks, logs, metrics |
| `maintenance` | 21/min (fib(7)) | **Governance** | DB migrations, cache flush, secrets |
| `governance` | 34/min (fib(8)) | No | Audit log, compliance, patent guard |
| `emergency` | Unlimited | No (auto-escalate) | Flatten, circuit breaker, kill switch |

## 3-Tier Memory Architecture

```
T0 (Hot)   — Upstash Redis    — TTL: 21h (φ³×3h)  — 10K vectors   — Linear scan  — $10/mo
T1 (Warm)  — Neon pgvector    — TTL: 47h (fib(10)) — 500K vectors  — HNSW m=16    — $19/mo
T2 (Cold)  — Qdrant Cloud     — TTL: 144h (fib(12))— 10M vectors   — HNSW m=16    — $25/mo
```

**Promotion:** composite ≥ 0.718 → promote to T0 | ≥ 0.618 → promote to T1
**Demotion:**  composite < 0.382 → demote to T1  | < 0.236 → demote to T2

## Pipeline Variants

| Variant | Stages | Target Latency | Use Case |
|---------|--------|---------------|----------|
| FAST | 8 (0,1,2,3,10,11,20,21) | φ³×1000 = 4,236ms | Simple chat |
| STANDARD | 13 (adds 4-8) | φ⁵×1000 = 11,090ms | General tasks |
| FULL | 21 (all) | φ⁷×1000 = 29,034ms | Critical tasks |
| ARENA | 15 (battle-sim) | φ⁶×1000 = 17,944ms | Multi-model eval |
| LEARNING | 13 (metacognitive) | φ⁵×1000 = 11,090ms | Self-improvement |

## Boot Sequence

```
 1. KERNEL_INIT    → Boot 5 TCB subsystems: IPC → CSL → Caps → Memory → Heartbeat
 2. STREAM_SETUP   → Create Redis Streams + consumer groups
 3. NODE_REGISTER  → Accept manifests; validate Law 3
 4. CAP_ISSUE      → Issue capability tokens per scope
 5. HEALTH_PRIME   → First heartbeat; all nodes respond < φ³×1000ms
 6. PIPELINE_READY → HCFullPipeline registers as user-space node
 7. SWARM_BOOT     → 21 swarms register with capability tokens
 8. EDGE_HANDSHAKE → CF Workers confirm kernel connectivity
 9. GPU_HANDSHAKE  → Colab runtimes (αβγδ) confirm via Tailscale
10. READY          → Emit ML-DSA-65 signed readiness receipt
```

## Node Scoring Formula

```
score = phi_weight × csl × (1 / latency_ms)
```

Route to highest-scored node. Quarantine below ψ = 0.618 for 3 cycles.

## Connection Pool Sizing

| Resource | Min | Max | Idle Timeout |
|----------|-----|-----|-------------|
| Neon Postgres | fib(3)=2 | fib(7)=13 | fib(11)×1000=89s |
| Upstash Redis | fib(3)=2 | fib(8)=21 | fib(10)×1000=55s |
| HTTP (APIs) | fib(2)=1 | fib(6)=8 | fib(9)×1000=34s |
| WebSocket | fib(2)=1 | fib(5)=5 | fib(8)×1000=21s |

## Budget Target

| Service | Cost/mo | Optimization |
|---------|---------|-------------|
| Cloud Run (21 svc) | $50–100 | min-instances=1, concurrency=80 |
| CF Workers | $5 | $5 paid plan, 10M req/mo |
| Upstash Redis | $10 | Pro, pipeline batching |
| Neon Postgres | $19 | Auto-suspend, Hyperdrive |
| Qdrant Cloud | $25 | Cold tier, 144h TTL |
| Gemini Flash-Lite | $5–15 | AI Gateway caching |
| Colab Pro+ | $50 | 4 runtimes, 2000 CU/mo |
| Sentry | $0 | Free tier, 10% sampling |
| HuggingFace | $0 | Free API, 3-token rotation |
| Domains (11) | $13 | ~$150/yr |
| **Total** | **$177–237** | |

---

*φ · Sacred Geometry · Liquid Architecture · Infinite Intelligence*
