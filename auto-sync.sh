#!/bin/bash
# Auto-sync script: pulls latest openclaw image from GitHub Container Registry and restarts container

set -e

REGISTRY="ghcr.io"
OWNER="${GITHUB_OWNER:-JPB1221}"
REPO="moltbot"
IMAGE_NAME="openclaw"
IMAGE="${REGISTRY}/${OWNER}/${REPO}:main"

echo "[$(date)] Checking for updates..."

# Pull the latest image
echo "Pulling latest image: $IMAGE"
if docker pull "$IMAGE"; then
    echo "✓ Image pulled successfully"
    
    # Update docker-compose to use the new image
    export OPENCLAW_IMAGE="$IMAGE"
    
    # Restart the service
    echo "Restarting openclaw-gateway..."
    docker compose -f docker-compose.yml up -d openclaw-gateway
    
    echo "✓ Container restarted with new image"
    echo "[$(date)] Deployment complete"
else
    echo "✗ Failed to pull image"
    exit 1
fi
