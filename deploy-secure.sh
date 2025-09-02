#!/bin/bash

echo "🔒 Secure Happy Deployment (Private Repo)"
echo "=========================================="

# Check if happy-fork exists locally
if [ ! -d "../happy-fork" ]; then
    echo "❌ Error: happy-fork directory not found at ../happy-fork"
    echo "   Please ensure happy-fork is cloned adjacent to this directory"
    exit 1
fi

# Pull latest changes from happy-fork
echo "📦 Updating happy-fork code..."
(cd ../happy-fork && git pull origin main) || {
    echo "⚠️  Warning: Could not pull latest changes from happy-fork"
}

# Create temporary build context
echo "🔨 Preparing build context..."
rm -rf .build-context
mkdir -p .build-context
cp -r ../happy-fork .build-context/happy-fork
cp Dockerfile.local .build-context/Dockerfile

# Source environment variables
if [ -f .env ]; then
    source .env
else
    echo "⚠️  No .env file found, using encrypted .env.yaml"
    export SOPS_AGE_KEY_FILE=/home/brett/.config/mise/age.txt
    eval "$(mise env)"
fi

# Build the image
echo "🐳 Building Docker image..."
cd .build-context
docker build -t happy-web-local:latest .
cd ..

# Clean up build context
rm -rf .build-context

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker stop happy-web 2>/dev/null || true
docker rm happy-web 2>/dev/null || true

# Run the new container
echo "🚀 Starting Happy..."
docker run -d \
  --name happy-web \
  --restart unless-stopped \
  -p 8082:3000 \
  -e EXPO_PUBLIC_HAPPY_SERVER_URL=https://api.cluster-fluster.com \
  -e EXPO_PUBLIC_ELEVENLABS_AGENT_ID="${ELEVENLABS_AGENT_ID}" \
  -e EXPO_PUBLIC_ELEVENLABS_API_KEY="${ELEVENLABS_API_KEY}" \
  -e NODE_ENV=production \
  --network dokploy-network \
  happy-web-local:latest

# Check if running
sleep 5
if docker ps | grep -q happy-web; then
    echo ""
    echo "✅ Happy is running!"
    echo "📱 Access at: http://100.119.254.98:8082"
else
    echo "❌ Failed to start Happy"
    echo "Check logs: docker logs happy-web"
    exit 1
fi