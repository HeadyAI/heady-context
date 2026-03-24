# Building an MCP proxy gateway: the complete technical blueprint

**An MCP proxy/gateway — a "node of MCP servers" — is now a well-defined architectural pattern with proven implementations, a maturing spec, and a rapidly crowding competitive landscape.** The core architecture acts simultaneously as an MCP server to downstream clients and an MCP client to upstream servers, aggregating tool manifests with namespace prefixing and routing `tools/call` requests by prefix lookup. As of March 2026, the MCP specification has reached version **2025-11-25** with four major revisions, the competitive field includes **50+ gateway products** (from Composio and Arcade to AWS and Microsoft), and Cloudflare Workers offers arguably the most capable edge runtime for this pattern — though its **6 outbound connection limit** and lack of outbound WebSocket hibernation create real engineering constraints. Here is everything required to build HeadyMCP.

---

## The MCP specification has evolved through four major revisions

The Model Context Protocol launched publicly in November 2024 and has undergone rapid iteration. The **latest stable spec is version 2025-11-25**, released on the protocol's one-year anniversary. Understanding the full spec is essential for a proxy that must faithfully relay every protocol method.

**Version timeline and key changes:**

| Version | Key additions |
|---------|--------------|
| **2024-11-05** | Original launch: stdio + HTTP+SSE transports, tools/resources/prompts/sampling primitives |
| **2025-03-26** | Streamable HTTP transport (replacing HTTP+SSE), OAuth 2.1 authorization framework with mandatory PKCE, `Mcp-Session-Id` header |
| **2025-06-18** | Structured tool outputs, elicitation (server requests info from users), resource links in tool results, `title` field for display names, `MCP-Protocol-Version` header requirement, removed JSON-RPC batching |
| **2025-11-25** | Async Tasks (`tasks/get`, `tasks/list`, `tasks/cancel`), Extensions framework, Client ID Metadata Documents (replacing DCR), step-up authorization, enhanced sampling with tool calling, server-side agent loops |

The protocol is built on **JSON-RPC 2.0** with three message types: requests (with `id`), responses (matching `id`), and notifications (no `id`). All messages are UTF-8 encoded. The spec defines **standard error codes** (-32700 through -32099) and reserves the `_meta` property for protocol-level metadata like progress tokens and task IDs.

### Every protocol method a proxy must handle

A proxy must faithfully relay all MCP methods. The complete method inventory across the four capability categories:

**Lifecycle:** `initialize` (client→server, negotiates capabilities and protocol version), `notifications/initialized` (client signals readiness), `ping` (bidirectional health check).

**Tools:** `tools/list` (paginated via `cursor`, returns tool objects with `name`, `title`, `description`, `inputSchema`, and `annotations`), `tools/call` (invokes tool by name with arguments, returns `content` array of text/image/embedded resources), `notifications/tools/list_changed`.

**Resources:** `resources/list`, `resources/read` (by URI), `resources/subscribe`/`unsubscribe`, plus `notifications/resources/list_changed` and `notifications/resources/updated`.

**Prompts:** `prompts/list`, `prompts/get` (fills template arguments, returns message array), `notifications/prompts/list_changed`.

**Utilities:** `completion/complete` (argument autocompletion), `logging/setLevel` (debug through emergency), `sampling/createMessage` (server→client, requests LLM completion), `elicitation/create` (server→client, requests structured user input).

**Tasks (2025-11-25):** `tasks/get`, `tasks/list`, `tasks/result`, `tasks/cancel` — any request can return a task handle for long-running operations with states: working, input_required, completed, failed, cancelled.

The `initialize` handshake is the critical entry point. The client sends its `protocolVersion`, `capabilities` (roots, sampling, elicitation, extensions), and `clientInfo`. The server responds with its own `protocolVersion`, `capabilities` (tools, resources, prompts, logging, completions, tasks, extensions), `serverInfo`, and optional `instructions`. **If a capability is not advertised, the other party MUST NOT use that feature** — this is how the proxy controls what it exposes.

---

## Two transports matter: Streamable HTTP and stdio

The MCP spec defines two active transports. A proxy must understand both deeply because transport bridging is a core function.

**Streamable HTTP** (the current standard) uses a single HTTP endpoint. Clients send every JSON-RPC message as an HTTP POST. Servers respond with either a direct JSON response (`application/json`) for simple request/response, or an SSE stream (`text/event-stream`) for streaming multiple messages, progress notifications, or server-initiated requests. Clients can also open a standalone SSE stream via HTTP GET for server-initiated notifications. Session management uses `Mcp-Session-Id` headers, and the `MCP-Protocol-Version` header is required after initialization. Session termination is an HTTP DELETE. **Resumability** is built in: SSE events include `id` fields, and clients reconnect with `Last-Event-ID`.

**stdio transport** communicates via stdin/stdout of a child subprocess, with newline-delimited JSON-RPC messages. It's designed for local integrations and explicitly should NOT use OAuth — credentials come from environment variables instead.

**Legacy HTTP+SSE** (two endpoints: GET `/sse` for persistent SSE, POST `/message` for client messages) was deprecated in 2025-03-26 but remains relevant for backward compatibility. Clients can auto-detect: POST an InitializeRequest first; if it fails with 4xx, fall back to the legacy SSE flow.

---

## Proven proxy architectures and existing implementations

The MCP proxy/gateway space has coalesced around **three architectural patterns**, each with production implementations.

### The fan-in aggregator is the canonical pattern

The fan-in aggregator is the architecture HeadyMCP needs. It maintains connections to multiple upstream MCP servers, aggregates their capabilities into a unified manifest, and routes individual requests to the correct upstream. **MetaMCP** (metatool-ai/metamcp) is the most feature-complete open-source implementation — it loops through all configured upstream servers on `tools/list`, collects and namespaces their tools, and routes `tools/call` by parsing the prefixed tool name. **elizaOS/mcp-gateway** adds health monitoring with configurable `healthCheckInterval`, automatic reconnection, and `maxConcurrentConnections` controls. **Microsoft's mcp-gateway** takes this further with Kubernetes-native deployment, session-aware stateful routing (all requests with the same `session_id` route to the same MCP server instance), and Azure Entra ID authentication with RBAC roles.

### Transport bridge proxies handle the stdio↔HTTP translation

**sparfenyuk/mcp-proxy** (Python) is the most popular transport bridge with two modes: stdio→SSE (connecting local clients to remote servers) and SSE→stdio (exposing local servers over HTTP). Since v0.8.0, it supports **multiple named servers** behind a single proxy at `/servers/NAME/` paths. **punkpeye/mcp-proxy** (TypeScript, npm `mcp-proxy`) provides the programmatic building blocks — `proxyServer()` for bidirectional message forwarding and `startHTTPServer()` for HTTP→stdio bridging — and is used internally by FastMCP. Cloudflare's `mcp-remote` package bridges stdio-only clients to remote Streamable HTTP servers with OAuth support.

### FastMCP's Provider + Transform model is the most elegant composition architecture

**FastMCP 3.0** (Python) treats all composition — mounting, proxying, filtering — as combinations of two primitives: Providers (source components from any origin) and Transforms (modify components in a pipeline). `create_proxy("http://example.com/mcp")` creates a full proxy with session isolation. `mcp.mount("weather", weather_mcp)` adds a sub-server with automatic prefix namespacing. The `AggregateProvider` queries all providers for list operations and uses first-match for get operations. Local definitions take precedence over mounted servers, which take precedence over proxy components. This pattern is directly applicable to HeadyMCP's tiered architecture.

---

## Namespace collision has a clear emerging standard

When aggregating tools from multiple servers, **name collisions are inevitable**. The ecosystem has converged on prefixing as the primary solution, with the double-underscore `__` separator emerging as the de facto standard.

| Project | Separator | Pattern | Example |
|---------|-----------|---------|---------|
| MetaMCP | `__` | `{Server}__{tool}` | `WebSearch__search` |
| combine-mcp | `_` | `{server}_{tool}` | `shortcut_search_stories` |
| elizaOS/mcp-gateway | `:` | `{namespace}:{tool}` | `crypto:get_search` |
| ToolHive vMCP | configurable | `{workload}_` or `{workload}.` | `github_create_issue` |
| FastMCP (Python) | `/` | `{prefix}/{tool}` | `weather/get_forecast` |

**SEP-993**, a draft specification proposal for the official MCP spec, formally proposes namespaces using `__` (double underscore) for tools and prompts, and `/` for resources. The rationale: `.` and `/` are not accepted in LLM API tool names, so `__` provides maximum compatibility. The proposal notes that LLMs struggle with >20 tools and fail at >40, making namespace-based grouping and selective presentation essential for aggregators.

**ToolHive vMCP** offers the most sophisticated conflict resolution with three strategies: **prefix** (default, always prefix all tools), **priority** (keep tool from highest-priority server, drop duplicates), and **manual** (require explicit overrides for all conflicts — vMCP refuses to start if ambiguity remains). For HeadyMCP, the recommended approach is always-prefix with `__` separator, matching the emerging spec standard, plus per-tool overrides for display names and descriptions.

---

## Tiered middleware maps directly to API gateway patterns

HeadyMCP's configurable service levels — from pure pass-through to full orchestration — maps cleanly onto the middleware chain architecture proven by Kong, Envoy, and Traefik. Kong's `ai-mcp-proxy` plugin (v3.12+) already implements **four MCP-specific modes**: proxy MCP requests, convert REST APIs to MCP tools, expose grouped tools, and listen mode — with per-tool ACLs.

The recommended tier structure for HeadyMCP:

**Tier 0 — Pass-through proxy.** Pure JSON-RPC forwarding with transport bridging. Zero processing overhead. This is what sparfenyuk/mcp-proxy and punkpeye/mcp-proxy provide.

**Tier 1 — Observability.** Request/response logging of all MCP traffic, tool call analytics, session tracking, latency metrics. Gravitee 4.10's MCP Proxy provides native analytics specifically for tool calls, prompts, and errors as a reference model.

**Tier 2 — Security and access control.** JWT/OAuth 2.1 authentication, per-tool ACLs and RBAC, input/output filtering, prompt injection prevention. Kong's plugin chain model — scoped at Global → Service → Route → Consumer levels with numeric priority ordering — is the most proven architecture for layered security policies.

**Tier 3 — Traffic management.** Per-tenant and per-tool rate limiting, tool manifest caching, circuit breaking for failed upstream servers, request/response transformation.

**Tier 4 — Full orchestration (HeadyMCP intelligence).** AI-powered tool selection, multi-tool chaining, context-aware routing, tool description enhancement, intelligent error recovery. This is where HeadyMCP's unique value lives.

Each tier should be independently toggleable via configuration, allowing customers to select exactly the processing level they need. The implementation pattern: a **middleware chain** where each tier is a plugin with an `enabled` boolean and per-tier configuration, processing requests in priority order.

---

## Authentication requires solving the two-hop problem

The critical challenge for an MCP proxy is the **two-hop authentication problem**: Hop 1 authenticates the client to the proxy (solved by MCP's OAuth 2.1 framework), and Hop 2 authenticates the proxy to upstream servers (left to implementors).

**For Hop 1 (client→proxy):** MCP defines a comprehensive OAuth 2.1 flow. The server is an OAuth Resource Server that returns HTTP 401 with Protected Resource Metadata (RFC 9728) pointing to an external Authorization Server. Clients perform Authorization Code + PKCE flow, and the spec mandates Resource Indicators (RFC 8707) to prevent token mis-redemption. As of 2025-11-25, **Client ID Metadata Documents (CIMD)** replace Dynamic Client Registration as the default registration method, and client-credentials flow supports M2M scenarios.

**For Hop 2 (proxy→upstream):** Four patterns have emerged in production:

The **credential vault pattern** (used by Runlayer + 1Password) stores `op://vault/item/field` references instead of raw credentials. At runtime, the proxy resolves references, injects live values, completes the request, and immediately releases secrets from memory. Every fetch is audit-logged with hash-based traceability.

The **OAuth proxy pattern** (built into FastMCP v2.12+ and the MCP TypeScript SDK's `ProxyOAuthServerProvider`) bridges MCP's DCR requirement with traditional OAuth providers that don't support it. Dual-PKCE secures both client-to-proxy and proxy-to-provider hops.

**Token exchange** (RFC 8693) or provider-specific equivalents (Azure On-Behalf-Of) trade an upstream token for a downstream-scoped token, preserving least-privilege.

**For multi-tenancy:** Each tenant needs isolated upstream server configurations and credentials. LiteLLM's MCP Gateway provides per-key, per-team access controls with database-backed server storage. IBM's ContextForge creates virtual servers per client with independent tool configurations and access controls. Microsoft's mcp-gateway uses Entra ID with application roles (`mcp.admin`, `mcp.engineer`). The recommended pattern for HeadyMCP: **tenant-scoped configuration objects** in Cloudflare KV or D1, each containing upstream server list, credentials (vault references), tool permissions, and tier selection.

---

## Cloudflare Workers is the strongest edge runtime for MCP, with key constraints

Cloudflare has invested heavily in MCP with first-party tooling. The **Agents SDK** provides `createMcpHandler()` for stateless MCP servers on plain Workers and `McpAgent` (backed by Durable Objects) for stateful servers with session persistence, elicitation, and sampling support. **13+ Cloudflare-built MCP servers** demonstrate production usage, and their OAuth Provider Library handles the full OAuth 2.1 flow. Transport support includes Streamable HTTP, SSE (legacy), and an internal **RPC transport** for zero-overhead agent-to-MCP communication via Service Bindings.

### The platform primitives map well to MCP proxy architecture

**Durable Objects** are ideal for per-session or per-tenant state management. Each DO provides single-threaded execution, built-in SQLite storage (up to 10GB), WebSocket Hibernation for idle connections, and guaranteed single-instance execution. The **McpAgent** class is already backed by Durable Objects, providing a proven pattern. Use one DO per upstream MCP server connection for persistent session management, or one per client session for client-side state.

**KV** serves as the global service registry and configuration store — eventually consistent reads at the edge with sub-millisecond latency make it perfect for tool manifest caching and tier configuration. **D1** (serverless SQL) handles structured data: audit logs, permission tables, tenant configurations. **Service Bindings** enable zero-overhead internal routing — a gateway Worker connects to per-upstream Workers without network hops or additional billing, making them the ideal mechanism for fan-out to upstream MCP servers.

**Vectorize** (vector database) enables semantic search over tool descriptions for intelligent tool discovery and routing — directly relevant to HeadyMCP's orchestration tier. **Queues** decouple long-running tool calls from the request/response cycle, and **Workflows** orchestrate multi-step tool chains with automatic retries.

### Three constraints demand architectural attention

**The 6 outbound connection limit** per Worker invocation is the most significant constraint. A proxy fanning out to many upstream MCP servers will hit this quickly. The mitigation: use **Service Bindings** to distribute outbound connections across multiple Workers (each handling a subset of upstreams), or use Durable Objects that maintain persistent connections to specific upstreams.

**WebSocket Hibernation works only for inbound connections.** Outbound persistent connections to upstream MCP servers keep the Durable Object active and incur duration charges. For upstreams using Streamable HTTP (which is request/response, not persistent), this isn't an issue — but for any upstream requiring persistent connections, costs accumulate.

**The 128MB memory limit per isolate** constrains how many concurrent upstream connections and cached manifests a single Worker/DO can maintain. For HeadyMCP with 31-42 tools, this is comfortable, but scaling to hundreds of upstream servers with thousands of tools requires partitioning across multiple DOs.

---

## The competitive landscape is crowded but undifferentiated

The MCP gateway space has **50+ entrants** across three segments, but no clear market leader has emerged.

**Integration-first platforms** compete on breadth: **Zapier** leads with 8,000+ app connections and 40,000+ actions, **ACI.dev** offers 600+ integrations with an elegant "2 meta-functions" architecture (search + execute covers all tools in ~1,000 tokens), and **Composio** claims 500+ integrations with SOC 2 compliance. **Arcade** (founded by ex-Okta engineers) differentiates on authentication.

**Infrastructure gateways** compete on performance and governance: **TrueFoundry** (recognized in Gartner's Market Guide for AI Gateways) and **Bifrost** both claim sub-3ms latency. **IBM ContextForge** provides 30+ safety/security plugins. **Microsoft's mcp-gateway** targets Kubernetes with session-aware routing. **Kong, Envoy/Solo.io, Traefik, and Gravitee** are extending existing API gateway products with MCP support.

**Registries are consolidating.** The **official MCP Registry** (registry.modelcontextprotocol.io) launched September 2025 as a metaregistry — storing metadata and pointing to npm/PyPI/Docker for actual code. It uses namespace validation (GitHub login verifies `io.github.username/*` ownership). **Smithery.ai** hosts 7,300+ tools with both discovery and deployment infrastructure. **PulseMCP** indexes 12,430+ servers. **mcp.so** aggregates 18,871 servers. The official registry is designed for federation: public and private sub-registries can ingest upstream data and augment it, which aligns with HeadyMCP's auto-discovery needs.

The key observation: **basic proxy/aggregation is becoming commoditized** as cloud providers (AWS API Gateway MCP Proxy, December 2025) and traditional API gateways add MCP support. Differentiation requires moving up the stack to intelligent orchestration, which is exactly HeadyMCP's Tier 4.

---

## The critical path from current state to production

Given HeadyMCP's existing foundation (31-42 MCP tools, dual JSON-RPC 2.0 + SSE transport, Cloudflare Workers, service registry with auto-discovery), the minimum viable path to a production MCP proxy has seven clear steps.

**Step 1: Implement the full MCP initialize handshake.** The gateway must negotiate capabilities with downstream clients, declaring exactly which MCP features it supports. The proxy should advertise `tools`, `resources`, `prompts`, and `logging` capabilities, along with `listChanged` notifications. Use the official `@modelcontextprotocol/server` package's `McpServer` class.

**Step 2: Build the upstream connection manager.** For each registered upstream MCP server, create an MCP client using `@modelcontextprotocol/client`. Support both Streamable HTTP (for remote upstreams) and stdio (for local upstreams, via a bridging Worker). Use Service Bindings to fan out — one Worker per upstream category avoids the 6-connection limit. Store connection state in Durable Objects with SQLite-backed session persistence.

**Step 3: Aggregate tool manifests with `__` namespacing.** On every `tools/list` request, query all healthy upstream servers, collect their tool manifests, prefix each tool name with `{serverName}__{toolName}` (matching SEP-993), cache the aggregated manifest in KV with a TTL, and return the unified list. Listen for `notifications/tools/list_changed` from upstreams and invalidate the cache accordingly.

**Step 4: Implement routing for `tools/call`.** Parse the `__` prefix from the tool name, look up the upstream server in the routing table, strip the prefix, and forward the call with original arguments. Return the upstream response to the client. Handle errors gracefully — if an upstream is down, return a clear JSON-RPC error rather than failing silently.

**Step 5: Add the tier configuration system.** Store per-tenant tier configuration in KV or D1: `{ tenantId, tier: 0-4, upstreams: [...], toolPermissions: {...}, credentials: [...] }`. The middleware chain processes each request through enabled tiers in priority order. Tier 0 (pass-through) is the default; each additional tier adds processing.

**Step 6: Implement Hop 2 authentication.** Store upstream credentials as vault references in D1 (never raw secrets in KV). For OAuth upstreams, implement token refresh and caching in Durable Objects. For API key upstreams, inject headers at request time. Support per-tenant credential isolation.

**Step 7: Expose Streamable HTTP transport to clients.** The gateway's single HTTP endpoint handles POST (client messages) and GET (SSE stream for notifications). Assign `Mcp-Session-Id` on initialization. Include `MCP-Protocol-Version` header validation. Support session termination via DELETE. For legacy clients, auto-detect and fall back to SSE.

The entire critical path can be implemented with the **official MCP TypeScript SDK** (Server + Client classes), **punkpeye/mcp-proxy's `proxyServer()`** for bidirectional message forwarding, **Cloudflare's Agents SDK** for the runtime foundation, and approximately **1,000-2,000 lines of orchestration code** connecting these components. The key architectural decision: use `createMcpHandler()` for the stateless gateway entry point with Service Bindings fanning out to per-upstream McpAgent Durable Objects, keeping the gateway Worker lightweight and the connection management distributed.
