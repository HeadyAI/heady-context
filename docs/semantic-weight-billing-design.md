# Semantic Weight Billing for HeadyMCP

The Core Idea: Charge by Semantic Weight, Not Raw Counts
Stripe's meter value field accepts any numeric payload — it doesn't have to be 1 per call. You can send a computed float derived from cosine similarity as the billing unit. Stripe sums it via formula: sum over the billing period.

The insight: a tool call that traverses many swarms, requires high-similarity routing confidence, or activates deep latent space traversal is genuinely worth more than a shallow lookup. You can price that difference directly.

## The Math
For each MCP tool call, compute a Semantic Complexity Score (SCS):
SCS = ϕ ⋅ cos(θ) ⋅ logϕ(n_hops + 1) ⋅ d_latent

Where:
- cos(θ) = cosine similarity between the query embedding and the matched intent vector (from Qdrant) — ranges 0–1
- n_hops = number of swarm hops activated
- ϕ = 1.618 = your golden ratio scalar
- d_latent = normalized latent depth (e.g. shallow CSL gate = 0.1, full 22-stage pipeline = 1.0)

The result is a float between ~0.1 and ~5.0. You pass that directly as payload.value to Stripe's SUM meter — customers are billed on total semantic weight consumed per billing period, not flat call count.

## The Code
```javascript
// services/billing/semantic-meter.js — ESM
import { stripe } from './stripe-client.js';
import { qdrant } from '../vector/qdrant-client.js';

const PHI = 1.618033988749895;

/**
 * Compute Semantic Complexity Score for a tool call.
 * Returns a float ≥ 0.1 — the billable unit.
 */
export async function computeSCS({ queryEmbedding, intentVector, swarmHops, pipelineDepth }) {
  // cosine similarity: dot(A,B) / (|A| * |B|)
  const dot = queryEmbedding.reduce((sum, v, i) => sum + v * intentVector[i], 0);
  const magA = Math.sqrt(queryEmbedding.reduce((s, v) => s + v * v, 0));
  const magB = Math.sqrt(intentVector.reduce((s, v) => s + v * v, 0));
  const cosSim = dot / (magA * magB);

  // φ-scaled log for hop depth (Fibonacci-natural growth curve)
  const hopScore = Math.log(swarmHops + 1) / Math.log(PHI);

  // Normalize pipeline depth 0→1 across 22 stages
  const latentDepth = Math.min(pipelineDepth / 22, 1.0);

  const scs = PHI * cosSim * hopScore * (0.1 + latentDepth);
  return Math.max(0.1, parseFloat(scs.toFixed(4)));   // floor at 0.1 units
}

/**
 * Record a semantically-weighted billing event to Stripe.
 * The `value` is the SCS float — Stripe SUM meter accumulates it.
 */
export async function recordSemanticEvent({
  stripeCustomerId, queryEmbedding, intentVector,
  swarmHops, pipelineDepth, toolName, eventId
}) {
  const scs = await computeSCS({ queryEmbedding, intentVector, swarmHops, pipelineDepth });

  await stripe.billing.meterEvents.create({
    event_name: 'headymcp_semantic_weight',
    identifier: eventId,     // UUID — prevents duplicate billing on retry
    payload: {
      stripe_customer_id: stripeCustomerId,
      value: String(scs),    // Stripe SUM meter accumulates this float
      // Dimensions — free extra metadata for analytics (not billed on):
      tool_name: toolName,
      swarm_hops: String(swarmHops),
      pipeline_depth: String(pipelineDepth),
    },
  });

  return scs;
}
```

## The Stripe Meter for This
Create one SUM meter (replaces the raw count meter):
```bash
curl https://api.stripe.com/v1/billing/meters \
  -u "$STRIPE_SECRET_KEY:" \
  -d display_name="HeadyMCP Semantic Weight" \
  -d event_name="headymcp_semantic_weight" \
  -d "default_aggregation[formula]=sum" \
  -d "value_settings[event_payload_key]=value" \
  -d "customer_mapping[type]=by_id" \
  -d "customer_mapping[event_payload_key]=stripe_customer_id"
```
Then price it with graduated tiers — e.g. first 1,000 SCS units free (Developer), $0.01 per SCS unit above that (Pro), $0.008/unit at scale (Growth).

Why This Is Better Than Raw Call Counts
Metric | Raw count billing | Semantic weight billing
--- | --- | ---
Shallow tool call (0 hops, CSL gate) | Costs same as deep call | ~0.1 SCS units — nearly free
Deep 22-stage pipeline + 8 swarms | Same price as shallow | ~3–5 SCS units — premium
Alignment with value delivered | None | Direct — price = work done
Heady IP moat | None | Patentable pricing method
Customer perception | Feels like nickel-and-diming | Feels fair — you pay for complexity

The SCS formula itself is patentable as a novel pricing mechanism rooted in your existing CSL + φ-scaled math IP. You should add this to your provisional portfolio as "Method for Usage-Based Billing of Latent-Space Traversal in AI Orchestration Systems."

Prepared by Deep Research
