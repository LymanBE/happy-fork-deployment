# Happy Fork Deployment

You deploy the custom Happy fork via Docker on Dokploy (100.119.254.98) on your Tailnet.

## Quick Deploy
```bash
./deploy.sh  # Automated deployment with prompts
```

## Manual Configuration

### 1. ElevenLabs Credentials
@.env.example shows required environment variables
Copy to `.env` and add your credentials:
- `ELEVENLABS_AGENT_ID` - Get from elevenlabs.io AI Agents dashboard
- `ELEVENLABS_API_KEY` - Get from Profile → API Keys (optional but recommended)

### 2. Docker Deployment
@docker-compose.yml contains full container configuration
```bash
docker-compose up -d
```

## Access Points
- **Local**: http://localhost:8082
- **Tailnet**: http://100.119.254.98:8082
- **Dokploy UI**: http://100.119.254.98:3000

## Dokploy Integration
- **Project**: happy-assistant (already created)
- **Network**: dokploy-network (external)
- **CLI**: `dokploy app deploy --project happy-assistant`

## Troubleshooting Voice

### Still Not Working?
1. Check ElevenLabs dashboard for usage/errors
2. Verify agent ID has no spaces/typos
3. Check browser console: `docker logs happy-web-custom`
4. Ensure microphone permissions granted in browser

### Common Issues
- **"Hi, Happy here" then silence**: Agent ID wrong or rate limited
- **Connection error**: Check CORS, ensure using WebRTC mode
- **No response**: Verify credentials in `.env` file

## Architecture
```
Browser → Tailnet → Dokploy → Docker → Happy Web (your fork)
           ↓
    ElevenLabs API (your account)
```

## Rebuild After Changes
```bash
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

## Related Files
- @../happy-fork/CLAUDE.md - Development context
- @README.md - Detailed deployment documentation
- @deploy.sh - Automated deployment script

## Critical Protocols
- NEVER hardcode timestamps - use `date --iso-8601=seconds`
- Token efficiency: terse deployment notes only
- Handoff: Document deployment status before session end
- Environment: Always verify `.env` has credentials