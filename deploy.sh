#!/bin/bash

echo "🚀 Happy Fork Deployment Script"
echo "================================"

# Check if .env exists
if [ ! -f .env ]; then
    echo "⚠️  No .env file found. Creating from template..."
    cp .env.example .env
    echo "📝 Please edit .env with your ElevenLabs credentials:"
    echo "   - ELEVENLABS_AGENT_ID"
    echo "   - ELEVENLABS_API_KEY"
    echo ""
    echo "Get these from https://elevenlabs.io"
    echo ""
    read -p "Press Enter after adding your credentials..."
fi

# Source environment variables
source .env

# Check if credentials are set
if [ -z "$ELEVENLABS_AGENT_ID" ] || [ "$ELEVENLABS_AGENT_ID" == "agent_your_custom_agent_id_here" ]; then
    echo "⚠️  Warning: No custom ElevenLabs agent ID set"
    echo "   Happy will use default shared agents (may have issues)"
    echo ""
    read -p "Continue anyway? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo "✅ Custom ElevenLabs agent configured: ${ELEVENLABS_AGENT_ID:0:20}..."
fi

# Stop existing container if running
echo "🛑 Stopping existing Happy containers..."
docker stop happy-web 2>/dev/null || true
docker stop happy-web-custom 2>/dev/null || true
docker rm happy-web 2>/dev/null || true
docker rm happy-web-custom 2>/dev/null || true

# Build and run
echo "🔨 Building Happy with custom voice support..."
docker-compose build

echo "🎯 Starting Happy..."
docker-compose up -d

# Wait for startup
echo "⏳ Waiting for Happy to start..."
sleep 5

# Check if running
if docker ps | grep -q happy-web-custom; then
    echo ""
    echo "✅ Happy is running!"
    echo ""
    echo "📱 Access your Happy instance at:"
    echo "   Local:   http://localhost:8082"
    echo "   Tailnet: http://100.119.254.98:8082"
    echo ""
    echo "🎤 Voice Configuration:"
    if [ ! -z "$ELEVENLABS_AGENT_ID" ] && [ "$ELEVENLABS_AGENT_ID" != "agent_your_custom_agent_id_here" ]; then
        echo "   ✅ Using YOUR ElevenLabs agent"
        echo "   ✅ No rate limiting from shared account"
    else
        echo "   ⚠️  Using default Happy agents (shared)"
        echo "   ⚠️  May experience rate limiting"
    fi
    echo ""
    echo "📊 View logs:"
    echo "   docker logs -f happy-web-custom"
    echo ""
    echo "🛑 To stop:"
    echo "   docker-compose down"
else
    echo "❌ Failed to start Happy"
    echo "Check logs: docker logs happy-web-custom"
    exit 1
fi