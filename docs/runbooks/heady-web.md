# HeadyWeb Runbook

## Service: heady-web
Domain routing, template engine, and site projection service.

## Health Check
```bash
curl https://headyme.com/health
```

## Domain Routing
All Heady domains resolve through `services/heady-web/src/services/domain-router.js`.
See `vertical-registry.json` for the full domain-to-vertical mapping.

## Restart
```bash
docker restart heady-web
```
