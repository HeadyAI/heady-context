# 🚀 Deployment Runbook
> Heady-specific. Replaces the generic Acme Corp template.

## Cloud Run Deploy

```bash
# Authenticate
gcloud auth configure-docker us-central1-docker.pkg.dev

# Build + push
docker build -t us-central1-docker.pkg.dev/gen-lang-client-0920560496/heady/app:latest .
docker push us-central1-docker.pkg.dev/gen-lang-client-0920560496/heady/app:latest

# Deploy
gcloud run deploy heady-production \
  --image us-central1-docker.pkg.dev/gen-lang-client-0920560496/heady/app:latest \
  --region us-central1 \
  --port 3301 \
  --min-instances 1
```

## Cloudflare Worker Deploy
```bash
# Verify config
cat wrangler.toml

# Deploy
wrangler deploy

# Check health
curl https://heady-ai.com/health
```

## Health Check Verification
```bash
# All domains
for domain in headyme.com headysystems.com headyai.com headyapi.com headymcp.com; do
  echo "$domain: $(curl -s -o /dev/null -w '%{http_code}' https://$domain/health)"
done
```

## Rollback
```bash
# List revisions
gcloud run revisions list --service heady-production --region us-central1

# Roll back to previous
gcloud run services update-traffic heady-production \
  --to-revisions PREV_REVISION=100 \
  --region us-central1
```

## CI Pipeline Fix (φ-Preflight Validation)
```bash
# Pull failing run logs
gh run list --workflow=".github/workflows/ci.yml" --limit 5
gh run view <RUN_ID> --log

# After fix — trigger manually
gh workflow run ci.yml
```
