# Auto-sync script: pulls latest openclaw image and restarts container (Windows PowerShell)

$ErrorActionPreference = "Stop"

$REGISTRY = "ghcr.io"
$OWNER = if ($env:GITHUB_OWNER) { $env:GITHUB_OWNER } else { "JPB1221" }
$REPO = "moltbot"
$IMAGE_NAME = "openclaw"
$IMAGE = "${REGISTRY}/${OWNER}/${REPO}:main"

Write-Host "[$(Get-Date)] Checking for updates..." -ForegroundColor Cyan

# Pull the latest image
Write-Host "Pulling latest image: $IMAGE" -ForegroundColor Yellow
try {
    docker pull $IMAGE
    Write-Host "✓ Image pulled successfully" -ForegroundColor Green
    
    # Set environment variable for docker-compose
    $env:OPENCLAW_IMAGE = $IMAGE
    
    # Restart the service
    Write-Host "Restarting openclaw-gateway..." -ForegroundColor Yellow
    docker compose -f docker-compose.yml up -d openclaw-gateway
    
    Write-Host "✓ Container restarted with new image" -ForegroundColor Green
    Write-Host "[$(Get-Date)] Deployment complete" -ForegroundColor Cyan
} catch {
    Write-Host "✗ Failed: $_" -ForegroundColor Red
    exit 1
}
