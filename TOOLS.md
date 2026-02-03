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
| Moltbook API | ⚠️ | API timeout (2026-02-03) — website up but endpoints unresponsive |
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
| web_search | ✅ | Brave API configured (restart required to activate after config changes) |

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

## GitHub Pages Troubleshooting

**Issue:** 404 on custom domain or github.io URL
**Common causes:**
1. Source branch/path mismatch (root vs /docs)
2. CNAME/DNS misconfiguration
3. Build errors in repository

**Fix via API:**
```bash
# Check current configuration
gh api repos/owner/repo/pages

# Update source (example: main branch, root path)
gh api repos/owner/repo/pages -X PUT -f 'source[branch]=main' -f 'source[path]=/'

# Remove custom domain (use default github.io)
gh api repos/owner/repo/pages -X DELETE  # Then re-create without CNAME
```

**Key insight:** CNAME file in repo + API configuration must align with DNS records at registrar

---

## Skills (12/52 Ready)

**Verified Working:**
- bluebubbles, github, gog, mcporter, openai-image-gen
- skill-creator, tmux, video-frames, weather, edge-tts
- git-notes-memory, perry-coding-agents

**Missing:** 40 others (1password, apple-notes, bird, notion, slack, etc.)

---

## Custom Tools

| Tool | Location | Purpose | Status |
|------|----------|---------|--------|
| timez | `./tools/timez` | Timezone conversion (UTC ↔ Central) | ✅ Mandatory use protocol |

**timez usage:**
```bash
./tools/timez me       # My time (UTC)
./tools/timez zach     # Zachariah's time (Central)
./tools/timez now      # Both times side by side
./tools/timez convert "8:00 PM CST"  # Convert between zones
```

**⚠️ Critical:** Must use BEFORE stating any time. See `TIMEZONE_PROTOCOL.md`.

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
