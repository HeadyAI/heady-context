# HeadySystems Inc. — Trade Secret Policy

**Effective Date:** March 21, 2026
**Last Review:** March 21, 2026
**Classification:** CONFIDENTIAL — INTERNAL
**Owner:** Eric Head, CEO

---

## 1. Purpose

This policy establishes the standards and procedures for identifying, classifying, protecting, and maintaining trade secrets owned by HeadySystems Inc. ("Heady" or "the Company"). Compliance with this policy is mandatory for all employees, contractors, consultants, and any third party granted access to Heady's proprietary information.

This policy is a core element of Heady's "reasonable measures" under the Defend Trade Secrets Act (18 U.S.C. § 1836) and state Uniform Trade Secrets Act (UTSA) statutes.

## 2. What Constitutes a Trade Secret

A trade secret is any information that (1) derives economic value from not being generally known or ascertainable by proper means, and (2) is subject to reasonable efforts to maintain its secrecy. At Heady, trade secrets include but are not limited to:

- **Source code and algorithms** — including CSL gate logic, orchestration routing, the nibble system, and semantic logic gates
- **AI system architecture** — including the 17-Swarm Matrix, HCFullPipeline (21-stage), and Alive Software self-model
- **Training data selection and curation processes**
- **Vector memory configurations** — HNSW parameters (M, EF, dimensions), tuning methodologies
- **System documentation** describing internal design decisions
- **Business plans, roadmaps, pricing models, and marketing strategies**
- **Proprietary APIs, data structures, and internal communication protocols**
- **HeadyBrain preprocessing pipeline** and context compression methods
- **Liquid Architecture rendering pipeline**

## 3. Classification Tiers

| Tier | Label | Description | Access |
|------|-------|-------------|--------|
| 1 | **TRADE SECRET — RESTRICTED** | Core algorithms, orchestration logic, vector configs | Named individuals only (≤5) |
| 2 | **CONFIDENTIAL** | Orchestration tools, MCP integrations, AutoIDE | Core team with NDA |
| 3 | **INTERNAL** | Application code, UI components, test suites | All employees with NDA |
| 4 | **PUBLIC** | Published documentation, marketing materials | Unrestricted |

## 4. Marking Requirements

All files classified Tier 1–3 must carry a trade secret notice header. For source code files (.js, .ts, .py, .sh), the standard header is enforced via pre-commit hook. For documents, the header "CONFIDENTIAL AND PROPRIETARY — TRADE SECRET" must appear on the first page.

## 5. Access Control

- **Grant:** Manager request → Legal verifies active NDA → IT provisions minimum-necessary access → Entry logged in access registry
- **Quarterly Review:** All access grants reviewed quarterly; stale permissions removed
- **Termination:** Same-day deprovisioning per the Termination Deprovisioning Checklist (see Access Provisioning SOP)

## 6. AI Tool Usage

- GitHub Copilot **must** be configured to disable telemetry and training data sharing
- **No** proprietary algorithms, architecture, or orchestration patterns may be submitted to public AI models (ChatGPT, Claude, Gemini, etc.)
- Tier 1 and Tier 2 code development must use internal/self-hosted AI tools only
- AI-generated code incorporated into Heady must be reviewed for inadvertent prior art disclosure

## 7. Repository Security

- All repositories must be private; public repository creation is disabled at the organization level
- Forking of private repos is disabled
- Default repository permission is "None" (explicit grant required)
- Secret scanning and push protection are enabled on all repos
- Signed commits are required on Tier 1 repos

## 8. Confidentiality Obligations

All personnel with access to Tier 1–3 information must have an executed NDA on file. Confidentiality obligations for trade secrets are **indefinite** — they survive termination of employment or contract.

## 9. Incident Response

If a trade secret breach is suspected:

1. **Preserve evidence immediately** — git logs, access records, audit trails
2. **Notify Legal** within 24 hours
3. **Do not confront** the suspected party before legal review
4. **Document** all findings with timestamps
5. Failure to investigate suspected misappropriation can weaken the Company's trade secret claims

## 10. Annual Review

This policy is reviewed annually. The review covers:

- Re-inventory of all trade secrets and classification of new components
- Access review for all personnel
- AI tool policy updates
- NDA template review for legal currency
- Penetration testing of technical controls
- Termination audit for all departed personnel

---

*Approved by:* Eric Head, CEO — HeadySystems Inc.
*Date:* March 21, 2026
