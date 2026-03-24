# 🛡️ Security Checklist
> All items are ASAP.

## Credential Rotation

- [ ] Anthropic API keys — 4x revoked Mar 7-15; generate fresh NOW
- [ ] Cloudflare API tokens
- [ ] GCP service account keys
- [ ] Neon database credentials
- [ ] Upstash Redis tokens
- [ ] Firebase service account
- [ ] Sentry auth tokens
- [ ] All secrets updated in: Cloudflare Workers, Cloud Run, GitHub Actions

## Repository Hardening

- [ ] Scrub `.heady/.shit` from Heady-Main git history (BFG Repo Cleaner)
- [ ] Add `.gitignore` rules blocking `*.env`, `*.key`, `*.pem`, `.heady/`
- [ ] Enable GitHub secret scanning on all repos
- [ ] Enable branch protection on: heady-production, Heady-Main, Heady-Staging, Heady-Testing
- [ ] Add `CODEOWNERS` to core repos
- [ ] Create PR template with 3 Unbreakable Laws checklist
- [ ] Archive/delete Heady-Main-1 (redundant repo)

## Dependency Security

- [ ] Merge Dependabot PR #10 (critical: undici + yauzl)
- [ ] Patch all remaining HIGH alerts (35+)
- [ ] Configure Dependabot auto-merge for patch versions
- [ ] Add SAST (CodeQL or Semgrep) to CI — block on HIGH
- [ ] Add Trivy/Snyk container scanning — block on CRITICAL

## Compliance (Backlog)

- [ ] GDPR controls documented
- [ ] CCPA controls documented
- [ ] PCI DSS controls documented (Stripe payments)
- [ ] SOC2 readiness checklist started
- [ ] Quarterly security review cadence established
