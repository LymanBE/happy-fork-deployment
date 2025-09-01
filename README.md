# Happy Fork - Custom Voice API Deployment

## What We've Done

We've successfully forked Happy and added support for custom voice API providers:

1. **Environment Variable Support** - Can now use your own ElevenLabs API keys
2. **Abstraction Layer Ready** - Foundation for OpenAI Realtime API integration
3. **Backward Compatible** - Still works with default Happy agents if no keys provided

## Quick Start

### 1. Set Up ElevenLabs (5 minutes)

1. Sign up at https://elevenlabs.io ($5/month starter plan)
2. Go to "AI Agents" → "Create an AI agent"
3. Configure your agent:
   - Name: "Happy Assistant" (or your preference)
   - Voice: Choose any voice you like
   - First message: "Hi, Happy here!"
   - Knowledge base: Leave default
4. Copy the agent ID (looks like: `agent_xxxxxxxxxxxxxxxxxxxxx`)
5. Get your API key from Profile → API Keys

### 2. Configure Your Deployment

```bash
cd /home/brett/happy-fork-deployment
cp .env.example .env
nano .env  # Add your ElevenLabs credentials
```

### 3. Deploy with Docker

```bash
# Quick test
docker-compose up

# Or deploy to Dokploy
dokploy app deploy --project happy-assistant
```

### 4. Access Your Custom Happy

- Local: http://localhost:8082
- Tailnet: http://100.119.254.98:8082
- Custom domain: http://happy.your-tailnet.ts.net

## Key Improvements Over Default Happy

1. **Your Own ElevenLabs Account**
   - No rate limiting from shared account
   - Reliable voice service
   - Your own usage limits

2. **Privacy**
   - Voice data through your account only
   - No sharing with other users

3. **Customization Ready**
   - Modify agent personality
   - Add custom prompts
   - Switch to OpenAI when ready

## Architecture

```
Your iPhone Safari → Tailnet → Dokploy → Happy Web (your fork)
                                              ↓
                                    Your ElevenLabs Agent
```

## Next Steps for OpenAI Integration

When you're ready to add OpenAI Realtime API:

1. We've already created the abstraction layer (`VoiceProvider.ts`)
2. Need to implement `OpenAIProvider.ts`
3. Update environment to use `EXPO_PUBLIC_VOICE_PROVIDER=openai`

## Troubleshooting

### Voice Still Not Working?
- Check your ElevenLabs dashboard for usage
- Verify agent ID is correct (no spaces)
- Check browser console for errors
- Make sure microphone permissions granted

### Build Issues?
```bash
# Clean rebuild
docker-compose down -v
docker-compose build --no-cache
docker-compose up
```

### Can't Connect?
- Verify Tailscale is connected
- Check Dokploy is running: http://100.119.254.98:3000
- Try direct Docker access: http://localhost:8082

## Cost Analysis

- **ElevenLabs Starter**: $5/month for 30 minutes
- **ElevenLabs Creator**: $22/month for 100 minutes  
- **OpenAI Realtime**: ~$0.06/minute (when implemented)

## Repository Structure

```
happy-fork/
├── sources/realtime/
│   ├── RealtimeVoiceSession.tsx       # Mobile (modified)
│   ├── RealtimeVoiceSession.web.tsx   # Web (modified)
│   ├── VoiceProvider.ts               # New abstraction layer
│   └── providers/
│       ├── ElevenLabsProvider.ts      # ElevenLabs implementation
│       └── OpenAIProvider.ts          # Future OpenAI implementation
```

## Custom Agent Prompting

The Happy agent context is sent via the `initialConversationContext` in `voiceHooks.ts`.
You can modify this to customize the agent's behavior:

```typescript
// Line 132 in voiceHooks.ts
prompt += 'THIS IS AN ACTIVE SESSION: \n\n' + formatSessionFull(...)
```

## Development Workflow

1. Make changes in your fork
2. Push to GitHub
3. Rebuild Docker image
4. Test on Tailnet
5. Iterate quickly without iOS builds!

## Support

- Happy Issues: https://github.com/slopus/happy/issues
- Your Fork: https://github.com/LymanBE/happy-fork
- Original Issue #68: Feature request for custom API keys