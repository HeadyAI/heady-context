# Public Domain Health Runbook

## Overview
Monitors health of all public Heady domains across the ecosystem.

## Canonical Domains
| Domain | Service | Health Endpoint |
|--------|---------|----------------|
| headyme.com | heady-web | /health |
| headysystems.com | heady-web | /health |
| headymcp.com | heady-web | /health |
| headyapi.com | heady-web | /health |
| headyconnection.org | heady-web | /health |
| headyio.com | heady-web | /health |
| headyos.com | heady-web | /health |
| headyfinance.com | heady-web | /health |
| headyex.com | heady-web | /health |

## Health Check Script
```bash
npm run test:domains
```

## Common Error Codes
| Code | Meaning | Action |
|------|---------|--------|
| 522 | Connection Timed Out (Cloudflare) | Check Cloud Run instance is running and healthy |
| 523 | Origin Unreachable | Verify DNS records and origin server |
| 502 | Bad Gateway | Check Cloud Run logs for crashes |

## Escalation
If a domain is unreachable, check Cloudflare DNS, then Cloud Run status.
