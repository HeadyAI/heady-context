# HeadyAuth Runbook

## Service: heady-auth
Authentication, session management, and token validation.

## Health Check
```bash
curl http://localhost:3314/health
```

## Key Endpoints
- `POST /api/auth/login` — authenticate user
- `POST /api/auth/register` — create account
- `POST /api/auth/refresh` — refresh token
- `POST /api/auth/revoke` — revoke token

## Rate Limits
- Login: 20 requests per 15 minutes
- General API: 1000 requests per 15 minutes
