# HeadyManager Runbook

## Service: heady-manager
Main Express API gateway on port 3300.

## Health Check
```bash
curl http://localhost:3300/api/health
```

## Start
```bash
node heady-manager.js
```

## Environment Variables
- `PORT` (default: 3300)
- `NODE_ENV` (development/production)
- `ANTHROPIC_API_KEY`
- `DATABASE_URL`
