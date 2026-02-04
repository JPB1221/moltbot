# OpenClaw Secure Deployment - PRD

## Original Problem Statement
User wants to run OpenClaw (https://github.com/openclaw/openclaw) locally on the cloud securely, concerned about security issues where bots make unauthorized purchases.

## Architecture
- **Tech Stack**: Node.js (TypeScript), Docker, pnpm
- **Deployment**: Docker containers with security hardening
- **AI Provider**: Claude Opus 4.5 via Emergent LLM key

## User Personas
1. **Primary User**: Owner who wants AI assistant capabilities
2. **Approved Contacts**: Friends/family who are paired and approved
3. **Unknown Contacts**: Blocked by default, require pairing code approval

## Core Requirements (Static)
1. ✅ Secure AI assistant running in cloud
2. ✅ Prevention of unauthorized actions (purchases, transactions)
3. ✅ Multi-channel support (WhatsApp, Telegram, Discord, Slack)
4. ✅ Sandboxed execution environment
5. ✅ Approval-based access control

## What's Been Implemented (Feb 4, 2026)

### Security Configuration
- **Exec commands**: DENIED by default
- **Browser tool**: DISABLED (prevents web automation/purchases)
- **Write/Edit tools**: DISABLED (prevents file modifications)
- **All sessions**: SANDBOXED in Docker containers
- **Network in sandbox**: DISABLED
- **DM Policy**: Pairing required (approval-based)
- **Groups**: Mention required

### Files Created
1. `.env` - Environment variables with Emergent LLM key
2. `.openclaw/openclaw.json` - Secure configuration
3. `.openclaw/exec-approvals.json` - Deny all by default
4. `docker-compose.secure.yml` - Hardened Docker compose
5. `start-secure.sh` - Setup script
6. `SECURITY_GUIDE.md` - User documentation

### Security Layers Implemented
1. **Layer 1**: Access Control (pairing, mentions, session isolation)
2. **Layer 2**: Tool Restrictions (allow read-only, deny dangerous)
3. **Layer 3**: Sandboxing (Docker, no network, read-only workspace)
4. **Layer 4**: Exec Approvals (deny all, ask always)

## Prioritized Backlog

### P0 (Critical) - Done ✅
- [x] Clone OpenClaw repository
- [x] Create secure configuration
- [x] Disable dangerous tools
- [x] Enable sandboxing
- [x] Set up approval system

### P1 (High Priority) - User Action Required
- [ ] Build Docker image: `./start-secure.sh`
- [ ] Start gateway: `docker compose -f docker-compose.secure.yml up -d`
- [ ] Connect channels (WhatsApp, Telegram, Discord)
- [ ] Run security audit: `openclaw security audit --deep`

### P2 (Medium Priority) - Future
- [ ] Set up Tailscale for remote access
- [ ] Configure custom skills
- [ ] Set up cron jobs for maintenance
- [ ] Enable voice features (if desired)

### P3 (Low Priority) - Enhancements
- [ ] Custom identity/avatar
- [ ] Multi-agent setup (different access levels)
- [ ] Integration with other services

## Next Tasks
1. User runs `./start-secure.sh` to build Docker image
2. User starts gateway with `docker compose -f docker-compose.secure.yml up -d`
3. User connects WhatsApp by scanning QR code
4. User approves contacts via pairing system
