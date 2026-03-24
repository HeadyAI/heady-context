# HeadySystems Inc. — IP Component Classification Registry
# CONFIDENTIAL — TRADE SECRET

**Last Updated:** March 21, 2026

---

## Patent-First Components (Observable from API/UI)

| Component | USPTO Filing | Status | Claim Strategy |
|-----------|-------------|--------|----------------|
| CSL AND-Gate | 19/433,835 | Non-provisional conversion pending | Technical improvement to AI inference pipelines at embedding/vector level |
| CSL NOT-Gate | 19/433,835 | Non-provisional conversion pending | Same as AND-gate; part of same filing |
| Alive Software / Self-Model | 19/433,835 | Non-provisional conversion pending | Real-time self-model updates; runtime feedback loops |
| HeadyBee Continuous Voting | 19/433,835 | Non-provisional conversion pending | Computer-implemented voting protocol with weight, decay, threshold |
| Sacred Geometry Orchestration | — | **Provisional needed ASAP** | Geometric topology for routing; vector distance → service priority |
| HeadyRouter Semantic Routing | — | **Provisional needed ASAP** | Semantic embedding → capability manifest → fallback chain |
| HeadyGuard Semantic Gating | — | Evaluate | External behavior observable; model weights are trade secret |

## Trade Secret Components (Internal, Non-Observable)

| Component | Tier | Key Protectable Elements | Storage |
|-----------|------|--------------------------|---------|
| HeadyConductor Core | 1 | Multi-agent routing, task prioritization, Monte Carlo orchestration | `src/core/`, `src/orchestration/` |
| HeadyBrain Pipeline | 1 | Semantic preprocessing, context compression, nibble system | `src/services/`, `packages/` |
| Semantic Logic Gates (impl) | 1 | Gate topology, dynamic switching algorithm | `src/core/` |
| HNSW Vector Config | 1 | M=21, EF=89, 384D reduction | `src/shared/`, database configs |
| HCFullPipeline (21-stage) | 1 | Deployment/testing/wiring recipe | `packages/hcfullpipeline/` |
| Liquid Architecture | 1 | Rendering pipeline internals | `src/services/` |
| Training Data / Eval | 1 | Data selection, labeling, eval metrics | Air-gapped storage |
| HeadyMCP Protocol | 2 | MCP adaptation, tool integration patterns | `src/mcp/`, `services/heady-mcp-server/` |
| HeadyAutoIDE | 2 | Code generation routing, self-optimization | `services/heady-ide/` |
| HeadyValidator | 3 | Quality scoring models, validation heuristics | `src/services/` |
| HeadyBuddy UX | 3 | Personalization logic, interaction patterns | `headybuddy/` |

## Patent Marking Plan

Once patents issue, the following surfaces must display "Patent Pending" or patent numbers:

- [ ] heady-ai.com — footer and API documentation
- [ ] headyme.com — footer
- [ ] headysystems.com — footer and about page
- [ ] headyio.com — footer and developer docs
- [ ] API response headers: `X-Heady-Patents: pending` (add to all API responses)
- [ ] npm package READMEs
- [ ] Electron desktop app about dialog

## Legal Deadlines

> **§ 102 On-Sale Bar Warning:** If HeadyAI has been providing API outputs commercially
> before a patent is filed, the 1-year clock is running. File provisionals for Sacred
> Geometry Orchestration and HeadyRouter BEFORE any additional commercial API use.

> **Post-Desjardins Window:** Current USPTO climate is the most favorable for agentic
> AI patents since Alice (2014). Non-provisional conversion should happen NOW.

---

*Maintained by:* Eric Head, CEO — HeadySystems Inc.
