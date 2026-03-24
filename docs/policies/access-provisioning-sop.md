# HeadySystems Inc. — Access Provisioning & Deprovisioning SOP

**Effective Date:** March 21, 2026
**Classification:** CONFIDENTIAL — INTERNAL
**Owner:** Eric Head, CEO

---

## 1. Access Grant Procedure

### Step 1: Request
Manager submits access request with:
- Employee/contractor name and role
- Specific repositories and systems required
- Business justification for access level
- Duration (permanent for employees, time-limited for contractors)

### Step 2: Legal Verification
Legal confirms:
- [x] Active NDA on file covering trade secrets
- [x] Employment/contractor agreement includes invention assignment
- [x] Confidentiality obligations include indefinite trade secret clause
- [x] Personnel has acknowledged Trade Secret Policy and AI Tool Usage Policy

### Step 3: IT Provisioning
IT provisions access at **minimum necessary permission level**:
- Tier 1 repos: Individual grant only (no team-level access)
- Tier 2 repos: Core team membership
- Tier 3 repos: Standard team membership
- 2FA must be enabled before access is granted

### Step 4: Registry
Access logged in the Access Registry with:
- Date of grant
- Repositories/systems granted
- Justification
- Approving manager
- NDA reference number

### Step 5: Quarterly Review
Every 90 days:
- All access grants reviewed against current role requirements
- Stale permissions removed (personnel who changed roles, projects completed)
- Access Registry updated

---

## 2. Termination Deprovisioning Checklist

**Execute within 2 hours of termination notification. All items must be completed same-day.**

### Immediate (Within 1 hour)
- [ ] Revoke all GitHub organization access (remove from all teams and repos)
- [ ] Revoke Cloudflare team/account access
- [ ] Revoke Google Cloud IAM permissions
- [ ] Revoke Firebase project access
- [ ] Disable SSO/OAuth sessions across all Heady services
- [ ] Revoke Vault policies tied to the person's service accounts

### Within 4 hours
- [ ] Rotate all API keys the departing person could have known or accessed
- [ ] Rotate any shared secrets (database credentials, service tokens) they had access to
- [ ] Review git log for any unusual commits in the 30 days before departure
- [ ] Check for any repo forks or clones in the departing person's personal GitHub

### Within 24 hours
- [ ] Collect all company devices (laptops, phones, storage devices)
- [ ] Require written confirmation of destruction/return of any copies of proprietary materials
- [ ] Send termination letter explicitly citing:
  - Confidentiality obligations that survive employment
  - Specific trade secret components they had access to
  - Prohibition on using Heady trade secrets to benefit any third party
  - Reminder of civil and criminal penalties under DTSA
- [ ] Log all deprovisioning actions with timestamps in the Access Registry

### Post-Departure (30 days)
- [ ] Monitor for any Heady code appearing in public repositories
- [ ] Review access logs for any data exfiltration patterns in the 90 days before departure
- [ ] Confirm all automated credentials (CI/CD tokens, service accounts) associated with the person are rotated

---

## 3. Contractor-Specific Requirements

- Maximum access duration: 12 months (renewable with re-verification)
- NDA must include explicit trade secret clauses covering: liquid architecture, HeadyBrain, HNSW configuration, orchestration routing
- No Tier 1 access without CEO approval
- Quarterly access reviews apply to contractors with increased scrutiny
- Source code fingerprinting applied to contractor-accessible code distributions

---

## 4. Audit Trail

All access provisioning and deprovisioning events are retained for **7 years** minimum. The Access Registry is stored in a tamper-evident audit log system separate from the repositories it controls.

---

*Approved by:* Eric Head, CEO — HeadySystems Inc.
*Date:* March 21, 2026
