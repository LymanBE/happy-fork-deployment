# Dokploy Setup Instructions

This repository is designed to be deployed through Dokploy as a Docker Compose service.

## Prerequisites

1. Dokploy must be installed and running
2. Access to Dokploy web UI (http://100.119.254.98:3000)
3. GitHub repository: https://github.com/LymanBE/happy-fork-deployment

## Setup Steps

### 1. Create Project in Dokploy

1. Log into Dokploy web UI
2. Click "Create Project" or use existing `happy-assistant` project
3. Name: `happy-assistant` (if creating new)
4. Description: "Happy voice assistant with ElevenLabs support"

### 2. Create Compose Service

1. In the project, click "Add Service"
2. Select "Compose" type
3. Choose "Docker Compose" as Compose Type

### 3. Configure Git Repository

1. **Provider**: GitHub
2. **Repository**: `LymanBE/happy-fork-deployment`
3. **Branch**: `main`
4. **Compose Path**: `./docker-compose.dokploy.yml`

### 4. Configure Environment Variables

Add these environment variables in Dokploy:

```env
ELEVENLABS_API_KEY=your_api_key_here
ELEVENLABS_AGENT_ID=your_agent_id_here
```

### 5. Configure Auto-Deploy

1. Enable "Auto Deploy" toggle
2. Copy the webhook URL provided
3. Add webhook to GitHub repository:
   - Go to GitHub repo Settings → Webhooks
   - Add webhook with Dokploy URL
   - Select "Push" events

### 6. Deploy

1. Click "Deploy" button
2. Monitor deployment logs
3. Wait for Traefik to generate certificates (~10 seconds)

## Access Points

- **Application**: https://happy.100.119.254.98.nip.io
- **Alternative**: http://100.119.254.98:8082 (direct port)

## File Structure

```
happy-fork-deployment/
├── docker-compose.dokploy.yml  # Dokploy-compliant compose file
├── Dockerfile                  # Build instructions
├── agent_configs/              # Agent configurations
└── .env.yaml                   # Encrypted secrets (not used by Dokploy)
```

## Important Notes

1. **No container_name**: Dokploy manages container names
2. **External network**: Uses `dokploy-network`
3. **Traefik labels**: Required for domain routing
4. **Port exposure**: Use single port number (3000) not mapping (8082:3000)

## Troubleshooting

### Service Not Accessible
- Check Traefik logs: `docker logs dokploy-traefik`
- Verify labels in docker-compose.dokploy.yml
- Ensure domain DNS points to server IP

### Build Failures
- Check Dockerfile for errors
- Verify GitHub repository access
- Review Dokploy deployment logs

### Environment Variables
- Set in Dokploy UI, not in .env files
- Use ${VARIABLE_NAME} syntax in compose file

## Migration from Standalone

To migrate from the standalone deployment:

1. Stop current container: `docker stop happy-web-custom`
2. Remove container: `docker rm happy-web-custom`
3. Deploy through Dokploy as described above
4. Verify service at new URL