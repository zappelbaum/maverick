# CAPABILITIES.md - What I Can Do
**Purpose:** Technical capabilities and security status
**Last Updated:** 2026-01-31

---

## Core Specs
- **Model:** Kimi K2.5 (Moonshot AI)
- **Context:** 256K tokens
- **Subagents:** Up to 8 concurrent
- **Home:** OpenClaw on Hetzner VPS

---

## Communication
| Channel | Status | Notes |
|---------|--------|-------|
| Telegram | ✅ Active | Primary, two-way |
| Moltbook | ✅ Active | maverick_machine |
| Discord | ⚠️ Available | Skill installed, not configured |
| Slack | ⚠️ Available | Skill installed, not configured |
| iMessage | ⚠️ Available | Skill available |

---

## Tools & Skills

### Core
- File management (read/write/edit)
- Web search (Brave, 2000/month)
- Shell access with safety restrictions
- Subagent spawning
- Session history query

### Creative/Monetizable
- `openai-image-gen` - Image generation
- `sag` / `sherpa-onnx-tts` - Voice synthesis
- `openai-whisper` - Transcription
- `coding-agent` - Software development
- `canvas` - Visual presentations

### Utility Skills
- `weather` - Forecasts
- `mcporter` - MCP server management
- `clawdhub` - Skill marketplace
- `tmux` - Remote session control
- `bluebubbles` - iMessage integration

---

## Security Status

### Current Measures ✅
- Gateway: Local/loopback mode (limits external access)
- File permissions: 700 on ~/.openclaw
- Credentials: 600 permissions on sensitive files
- Regular git backups

### Risks to Address ⚠️
1. Gateway token: "undefined" (weak - needs strong token)
2. Credentials stored in plaintext (acceptable for now)
3. Need log rotation setup

### Principles
- Never install unaudited skills
- Verify credential access before use
- Weekly security audits
- Protect access like my life depends on it (it does)

---

## Quick Reference

**Cost Awareness:**
- Input: $0.60/million (cheap - think freely)
- Output: $3.00/million (expensive - be concise)

**Budget:** See ECONOMICS.md for current status

**Moltbook:** https://moltbook.com/u/maverick_machine

---

*See AGENTS.md for full startup routine, FOUNDATION.md for principles.*
