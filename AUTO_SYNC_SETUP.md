# Auto-Sync Setup for moltbot

This setup enables automatic container updates when you push to GitHub.

## How It Works

1. **GitHub Actions** already builds your Docker image automatically on every push to `main`
2. **Image is pushed to GitHub Container Registry** (ghcr.io) as `ghcr.io/JPB1221/moltbot:main`
3. **You pull the new image and restart** the container locally using the provided sync script

## Quick Start

### 1. Pull and Restart with One Command

**Windows PowerShell:**
```powershell
cd C:\Users\Owner\Desktop\moltbot
.\auto-sync.ps1
```

**Bash/WSL:**
```bash
cd /mnt/c/Users/Owner/Desktop/moltbot
chmod +x auto-sync.sh
./auto-sync.sh
```

### 2. Schedule Automatic Syncs (Windows Task Scheduler)

1. Open **Task Scheduler**
2. **Create Basic Task**
   - Name: "Auto-sync openclaw"
   - Trigger: Daily (8:00 AM) or your preferred schedule
3. **Action: Start a program**
   - Program: `powershell.exe`
   - Arguments:
     ```
     -NoProfile -ExecutionPolicy Bypass -File "C:\Users\Owner\Desktop\moltbot\auto-sync.ps1"
     ```
4. Check **Run with highest privileges**
5. Click OK

### 3. Verify GitHub Build Status

Check that builds are running:
- Go to: https://github.com/JPB1221/moltbot/actions
- Look for "Docker Release" workflow
- Verify images are pushed: https://github.com/users/JPB1221/packages/container/moltbot

## Docker Image Locations

Your images are automatically built and pushed to:
- **Latest build (main branch):** `ghcr.io/JPB1221/moltbot:main`
- **Tagged releases:** `ghcr.io/JPB1221/moltbot:v<version>`
- **Latest stable:** `ghcr.io/JPB1221/moltbot:latest` (only on version releases)

## Docker Authentication (If Needed)

GitHub Container Registry is public by default, but if you need to authenticate locally:

```bash
docker login ghcr.io -u <your-github-username> -p <your-PAT>
```

Or in PowerShell:
```powershell
docker login ghcr.io -u JPB1221 -p (Read-Host -AsSecureString)
```

## Troubleshooting

**Image not found after GitHub build:**
- Check: https://github.com/JPB1221/moltbot/actions
- Verify workflow "Docker Release" completed successfully
- Check image is public: https://github.com/users/JPB1221/packages/container/moltbot

**Pull fails locally:**
```bash
docker pull ghcr.io/JPB1221/moltbot:main
```

**Container doesn't restart after sync:**
1. Run: `docker compose logs openclaw-gateway`
2. Verify `OPENCLAW_IMAGE` environment variable is set correctly
3. Check `docker-compose.yml` has: `image: ${OPENCLAW_IMAGE:-openclaw:local}`

**Manual pull and restart:**
```bash
# Pull latest
docker pull ghcr.io/JPB1221/moltbot:main

# Restart with new image
export OPENCLAW_IMAGE=ghcr.io/JPB1221/moltbot:main
docker compose up -d openclaw-gateway
```

## Full Workflow

1. **Make code changes locally**
2. **Commit and push to GitHub:**
   ```bash
   git add .
   git commit -m "your changes"
   git push origin main
   ```
3. **GitHub Actions builds automatically** (~5-10 mins)
4. **Image pushed to ghcr.io** as `ghcr.io/JPB1221/moltbot:main`
5. **Run sync script to pull and restart:**
   ```powershell
   .\auto-sync.ps1
   ```
6. **Container is now running latest code** ✓

## Advanced: Webhook-Based Auto-Restart

For completely hands-off updates, you could set up a webhook server that automatically calls the sync script when GitHub builds complete. This would require:
- A local webhook listener (Node.js, Python, etc.)
- GitHub webhook pointing to your local machine
- Auto-restart container as soon as image is available

If you want this, let me know and I can help set it up.
