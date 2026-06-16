# Claude Code Configuration — Heady Context

This directory configures Claude Code for **maximum usable context** and
**Heady-optimal operation** when working in this repository. Settings are
team-wide (committed); personal overrides belong in `.claude/settings.local.json`
(gitignored).

## Maximum context

| Setting | Value | Effect |
|---------|-------|--------|
| `autoCompactWindow` | `1000000` | Compaction defers until the **1M-token** boundary — the full window is used before any summarization. |
| `env.ANTHROPIC_BETAS` | `context-1m-2025-08-07` | Opts into the 1M-token context beta. Pair with a 1M-capable model (e.g. `claude-opus-4-8[1m]`). |
| `autoCompactEnabled` | `true` | Long sessions never hard-stop; context is summarized at the boundary instead of failing. |
| `env.CLAUDE_CODE_MAX_OUTPUT_TOKENS` | `64000` | Large single-turn outputs (full files, long reports). |
| `env.MAX_THINKING_TOKENS` | `32000` | Deep extended-thinking budget (stays below the output cap). |
| `env.MAX_MCP_OUTPUT_TOKENS` | `50000` | Heady runs many MCP servers; raises the per-call output cap so tool results aren't truncated. |
| `effortLevel` | `xhigh` | Maximum reasoning effort on supported models. |
| `alwaysThinkingEnabled` / `showThinkingSummaries` | `true` | Thinking always on and visible in the transcript. |

> **Model note:** the 1M window requires a 1M-capable model. Select it per
> session (`/model claude-opus-4-8[1m]`) or pin it in your personal
> `.claude/settings.local.json`. It is intentionally **not** pinned in
> committed settings so the team isn't forced onto one model/tier.

## Heady-optimal operation

- **`enableAllProjectMcpServers: true`** — auto-approves the project's MCP
  servers (`.mcp.json`) so the Heady toolchain is available without per-server
  prompts.
- **`fileCheckpointingEnabled` / `todoFeatureEnabled`** — safe `/rewind` and
  task tracking for multi-stage pipeline work.
- **`cleanupPeriodDays: 90`** — long transcript retention for long-running
  orchestration sessions.
- **Permissions** — read/search/agent and the common Heady dev commands
  (git, npm/pnpm, node, python, gitleaks) are allowed; secrets
  (`.env`, `.heady/**`, keys) are **deny-read**; catastrophic and
  destructive-infra commands are blocked or gated (see hooks).

## Hooks

| Hook | Script | Purpose |
|------|--------|---------|
| `SessionStart` | `hooks/session-context.sh` | Injects live repo context (branch, HEAD, present canonical configs, Stop Rule) so each session starts grounded in current state, not a stale snapshot. |
| `PreToolUse(Bash)` | `hooks/guard-bash.sh` | Hard-**denies** catastrophic commands (`rm -rf /`, force-push, `mkfs`, fork-bombs) and **asks** before destructive-but-legitimate ones (`DROP TABLE`, `gcloud … delete`, `wrangler … delete`). Enforces the governance rule that irreversible actions need human confirmation. |

Both scripts are pure `bash` + `jq` (both required at runtime) and emit the
documented hook JSON contracts. Test them directly:

```bash
echo '{}' | bash .claude/hooks/session-context.sh | jq .
echo '{"tool_input":{"command":"rm -rf /"}}' | bash .claude/hooks/guard-bash.sh | jq .
```

Review or disable any hook live via the `/hooks` menu.
