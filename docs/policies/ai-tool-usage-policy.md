# HeadySystems Inc. — AI Tool Usage Policy

**Effective Date:** March 21, 2026
**Classification:** CONFIDENTIAL — INTERNAL
**Applies to:** All employees, contractors, and contributors

---

## 1. Purpose

This policy governs the use of AI-powered tools (coding assistants, chatbots, image generators, and similar) in the context of HeadySystems work. Improper use of AI tools can constitute public disclosure of trade secrets, destroying legal protection permanently.

## 2. Approved AI Tools

| Tool | Approved Use | Restrictions |
|------|-------------|--------------|
| GitHub Copilot (Business/Enterprise) | Tier 3–4 code only | Telemetry and training data sharing **must be disabled** |
| Internal Heady AI endpoints | All tiers | Preferred for all development |
| ChatGPT / Claude / Gemini (public) | General research, non-proprietary queries | **Never** submit proprietary code, architecture, or algorithms |
| Perplexity | Research, documentation | No proprietary queries |

## 3. Prohibited Actions

The following actions constitute a **trade secret violation** and may result in termination and legal action:

1. **Submitting Tier 1 or Tier 2 source code** to any public AI model or cloud-based coding assistant
2. **Describing proprietary algorithms** (CSL gates, nibble system, semantic logic, orchestration routing) in prompts to public AI tools
3. **Uploading architecture diagrams**, internal documentation, or system designs to public AI services
4. **Using AI-generated code** that reproduces patterns from Heady's proprietary systems in external projects
5. **Allowing any AI tool to train on Heady's codebase** via telemetry, feedback loops, or cloud processing

## 4. GitHub Copilot Configuration

All Heady developers using GitHub Copilot must verify the following settings:

```
GitHub → Settings → Copilot:
  ☐ Allow GitHub to use my code snippets for product improvements: OFF
  ☐ Allow GitHub to use my code snippets to improve Copilot: OFF

Organization → Settings → Copilot → Policies:
  ☐ Suggestions matching public code: BLOCKED
  ☐ Copilot Chat in IDE: ALLOWED (Tier 3-4 only)
  ☐ Copilot Chat in GitHub.com: DISABLED
```

## 5. Code Review Requirements

Any AI-generated code incorporated into the Heady codebase must:

1. Pass standard code review by a human team member
2. Be checked for inadvertent prior art patterns that could weaken patent applications
3. Not introduce open-source license contamination
4. Carry the standard trade secret header before commit

## 6. Incident Reporting

If you accidentally submit proprietary information to a public AI tool:

1. **Stop immediately** — do not continue the session
2. **Document** exactly what was submitted (screenshot if possible)
3. **Notify Legal** within 4 hours
4. **Request deletion** from the AI provider if possible
5. The incident will be assessed for impact on trade secret status

## 7. Training and Acknowledgment

All personnel must acknowledge this policy annually. New hires must acknowledge before receiving repository access.

---

*Approved by:* Eric Head, CEO — HeadySystems Inc.
*Date:* March 21, 2026
