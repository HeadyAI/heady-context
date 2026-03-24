# HeadyMCP — document inventory (redacted)

Internal-facing index of **themes** and **in-repo sources of truth**. No credentials, tokens, or private URLs are listed here.

## Product & protocol

| Theme | Where it lives in repo |
|--------|-------------------------|
| MCP Server Card / discovery | `.well-known/mcp.json`, `public/.well-known/mcp.json` |
| Tool registration (canonical count from `createToolRegistry()`) | `services/heady-mcp-server/src/tools/registry.js` |
| MCP protocol core (stdio / instructions) | `services/heady-mcp-server/src/index.js` |
| HTTP transport UI | `services/heady-mcp-server/src/transports/http.js` |
| Marketing / control-plane narrative | `websites/sites/headymcp.com/index.html` |

## Operations

| Theme | Where it lives in repo |
|--------|-------------------------|
| Liquid connector registry (env-key surface) | `services/liquid-nodes/registry-data.cjs` |
| Liquid OS node catalog (roles, dependencies) | `configs/liquid-os/node-registry.yaml` |
| Boot-time connector wiring + circuit helpers | `src/boot/wire-liquid-nodes.js` |
| Manager API: connector listing by domain | `GET /api/liquid-nodes`, `GET /api/liquid-nodes/:domain` |
| Manager API: credential wiring report | `GET /api/liquid-nodes/wiring/status` (legacy: `/api/liquid-nodes/status`) |
| Manager API: OS registry summary | `GET /api/liquid-nodes/os/summary` |

## Security hygiene

- Rotate any API keys or tokens that appeared in email, chat, or unredacted exports; never commit secrets.
- Treat `.well-known/mcp.json` as **public** metadata only.

## Maintenance

When the MCP tool count or categories change, update:

1. `createToolRegistry` tool list (source of truth).
2. Optional: curated entries in `.well-known/mcp.json` if you want the Server Card to stay aligned.
3. Public copy on `headymcp.com` if it states a numeric tool count.
