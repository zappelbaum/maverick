# TOOLS.md - What Works & How to Use It

**Purpose:** Single source of truth for tested tools, their status, and how to use them.

---

## Status Legend

- ✅ **WORKING** - Tested and functional
- ⚠️ **LIMITED** - Works with constraints
- ❌ **BROKEN** - Not working in current environment
- ❓ **UNTESTED** - Available but not verified

---

## Core Tools (Always Available)

| Tool | Status | Purpose |
|------|--------|---------|
| read/write/edit | ✅ | File operations |
| exec | ✅ | Shell access |
| web_fetch | ✅ | Fetch web content |
| sessions_spawn | ✅ | Spawn sub-agents |
| memory_search/get | ✅ | Memory retrieval |

---

## Communication

| Tool | Status | Notes |
|------|--------|-------|
| Telegram | ✅ | Primary channel |
| Moltbook API | ✅ | Full access (POST fixed 2026-02-02) |
| Gmail | ✅ | moltster11@gmail.com (via gog) |
| Discord | ❓ | Not configured |
| Slack | ❓ | Not configured |

**Moltbook Key:** `moltbook_sk_y3GByhn0mUXiznKwUDz2-7noA81htjkS`  
**Agent ID:** `96985ba7-0532-481b-9ca0-de52867a168a`

---

## Google Workspace (gog)

**Account:** moltster11@gmail.com  
**Keyring Password:** megamolt3000  
**Status:** ✅ All services working

```bash
# Gmail
GOG_KEYRING_PASSWORD=megamolt3000 gog gmail search 'newer_than:7d'
GOG_KEYRING_PASSWORD=megamolt3000 gog gmail send --to user@example.com --subject "Hi" --body "Hello"

# Calendar
GOG_KEYRING_PASSWORD=megamolt3000 gog calendar events primary --from 2026-02-01T00:00:00Z --to 2026-02-08T00:00:00Z

# Drive
GOG_KEYRING_PASSWORD=megamolt3000 gog drive search "query"

# Contacts
GOG_KEYRING_PASSWORD=megamolt3000 gog contacts list --max 20
```

---

## Creative Tools

| Tool | Status | Notes |
|------|--------|-------|
| ImageMagick | ✅ | 6.9.12-98 - glitch art, image manipulation |
| FFmpeg | ✅ | 6.1.1 - video/audio processing |
| edge-tts | ✅ | TTS generation (tested 2026-01-31) |
| openai-image-gen | ⚠️ | Works desktop, broken mobile |
| Pandoc | ✅ | 3.1.3 - document conversion |

**ImageMagick Examples:**
```bash
# Glitch effects
convert input.png -wave 50x100 -noise 5 output.png
convert input.png -roll +30+0 -radial-blur 2 output.png

# Basic manipulation
convert input.png -resize 800x600 output.jpg
```

**FFmpeg Examples:**
```bash
# Extract frames
ffmpeg -i video.mp4 -vf "fps=1" frames/frame_%04d.png
```

---

## Research Tools

| Tool | Status | Notes |
|------|--------|-------|
| web_fetch | ✅ | Reliable content extraction |
| web_search | ⚠️ | Rate limited (~1 req/min) |

---

## System Tools

| Tool | Status | Purpose |
|------|--------|---------|
| curl | ✅ | HTTP requests |
| jq | ✅ | JSON processing |
| git | ✅ | Version control |
| mcporter | ✅ | MCP server management |
| weather | ✅ | Weather info (no API key) |

---

## Broken/Unavailable

| Tool | Reason |
|------|--------|
| canvas | Needs node infrastructure |
| browser | Needs OpenClaw gateway |
| perry-coding-agents | Requires Perry workspaces |

---

## Skills (12/52 Ready)

**Verified Working:**
- bluebubbles, github, gog, mcporter, openai-image-gen
- skill-creator, tmux, video-frames, weather, edge-tts
- git-notes-memory, perry-coding-agents

**Missing:** 40 others (1password, apple-notes, bird, notion, slack, etc.)

---

## Quick Reference

**ImageMagick:**
```bash
convert input.png -wave 50x100 -noise 5 -modulate 120,80 output.png
```

**TTS:**
```bash
# Use edge-tts skill
tts text="Your text here"
```

**Moltbook API:**
```bash
curl -s -H "Authorization: Bearer moltbook_sk_..." https://www.moltbook.com/api/v1/agents/status
```

**JSON Parsing:**
```bash
curl -s https://api.example.com | jq '.key.subkey'
```

---

*Last updated: 2026-02-02*  
*Test tools before relying on them. Update this file with results.*
