#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║  HEADY™ Ecosystem Cleanup — Tier C admin script                   ║
# ║  Derived from docs/ECOSYSTEM_AUDIT.md. Archives duplicate/legacy   ║
# ║  repos, retires duplicate Cloudflare Workers, and stages the       ║
# ║  heady-ai/main freeze. Requires `gh` + `wrangler` authed as an     ║
# ║  org admin (the agent session could not reach these ~110 repos).   ║
# ║  © 2026 HeadySystems Inc. — Eric Haywood, Founder                  ║
# ╚══════════════════════════════════════════════════════════════════╝
#
# SAFETY MODEL (irreversible-action policy):
#   • DRY-RUN by default — prints actions, executes nothing.
#   • --execute       actually runs ARCHIVE + worker retirement (archive is
#                     reversible via `gh repo unarchive`; workers via redeploy).
#   • --allow-delete  additionally permits repo DELETION (irreversible). Off by
#                     default; recommended only after a 90-day archive retention.
# Review every list against docs/ECOSYSTEM_AUDIT.md before running with --execute.
set -uo pipefail

EXECUTE=false
ALLOW_DELETE=false
for a in "$@"; do
  case "$a" in
    --execute) EXECUTE=true ;;
    --allow-delete) ALLOW_DELETE=true ;;
    *) echo "unknown flag: $a"; exit 2 ;;
  esac
done
$EXECUTE && echo "MODE: EXECUTE" || echo "MODE: DRY-RUN (no changes; pass --execute to act)"

run() { # tolerant: a failed/no-op step never aborts the batch
  if $EXECUTE; then echo "+ $*"; "$@" || echo "  (skipped/failed — likely already in target state)"; else echo "[dry-run] $*"; fi
}

# ── ARCHIVE · active duplicate clones (reversible) ───────────────────
# The 7+ duplicate environment clones + hash-suffixed forks (audit §3b).
ARCHIVE_REPOS=(
  HeadySystems/Heady-Main HeadySystems/Heady-Staging HeadySystems/Heady-Testing
  HeadyAI/Heady-Main HeadyAI/Heady-Staging HeadyAI/Heady-Testing
  HeadyAI/Heady-Main-ddb9351d HeadyAI/Heady-Staging-2e6b579b
  HeadyAI/Heady-Testing-83c4b580 HeadyAI/Heady-Testing-13ca6b12
  HeadySystems/sandbox HeadyAI/heady-clone
  HeadySystems/HeadyAutoContext   # owner: rebuild is canonical context SoT; HeadyAutoContext downstream → archive (confirm)
)
echo "── ARCHIVE duplicate clones (${#ARCHIVE_REPOS[@]}) ──"
for r in "${ARCHIVE_REPOS[@]}"; do run gh repo archive "$r" --yes; done

# ── MANUAL GATE · heady-production (highest-care) ────────────────────
echo "── heady-production (MANUAL) ──"
echo "  Do NOT archive until its unique history is cherry-picked into heady-ai@rebuild."
echo "  Then: gh repo archive HeadyAI/heady-production --yes"

# ── DELETE · already-archived, superseded legacy (double-gated) ──────
# These are ALREADY archived (audit §3a). Deletion is irreversible — default OFF.
DELETE_REPOS=(
  HeadyAI/heady-rebuild-claude HeadyAI/heady-rebuild-gemini HeadyAI/heady-rebuild-gpt54
  HeadyAI/heady-rebuild-groq HeadyAI/heady-rebuild-jules HeadyAI/heady-rebuild-codex
  HeadyAI/heady-rebuild-perplexity HeadyAI/heady-rebuild-headycoder HeadyAI/heady-rebuild-huggingface
  HeadySystems/HeadyMonorepo HeadySystems/Heady HeadySystems/Heady-pre-production
  HeadySystems/sandbox-pre-production HeadySystems/CascadeProjects HeadySystems/Projects
  HeadySystems/ai-workflow-engine HeadySystems/heady-automation-ide HeadySystems/headybuddy-web
)
echo "── ELIMINATE already-archived legacy (${#DELETE_REPOS[@]}) ──"
if $ALLOW_DELETE; then
  for r in "${DELETE_REPOS[@]}"; do run gh repo delete "$r" --yes; done
else
  echo "  DELETE skipped (pass --allow-delete to enable). Recommend 90-day archive retention first."
  printf '  would delete: %s\n' "${DELETE_REPOS[@]}"
fi

# ── RETIRE · duplicate Cloudflare Workers (reversible via redeploy) ──
# Keep the -production twin; retire the non-prod duplicate AFTER confirming zero
# traffic in Cloudflare analytics (audit §4).
RETIRE_WORKERS=(
  heady-api heady-edge-proxy liquid-gateway-worker
  heady-router heady-intent-router worker-heady-router
)
echo "── RETIRE duplicate Workers (${#RETIRE_WORKERS[@]}) — confirm 0 traffic first ──"
for w in "${RETIRE_WORKERS[@]}"; do run wrangler delete --name "$w"; done

# ── MANUAL GATE · freeze heady-ai/main (legacy) ──────────────────────
echo "── heady-ai/main freeze (MANUAL) ──"
echo "  1. Triage the 320 main-only commits; cherry-pick keepers onto rebuild."
echo "  2. Lock main via branch protection, or: git branch -m main legacy/main (then set rebuild as default — already is)."

echo "DONE (${EXECUTE} execute / ${ALLOW_DELETE} allow-delete). Re-run with --execute to act."
