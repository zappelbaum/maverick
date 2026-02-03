#!/bin/bash
#
# session_start.sh - Automated session initialization ritual
# Usage: ./session_start.sh [session_name]
#
# Performs the NEW_SESSION_GUIDE.md checklist:
# - Checks time/timezone
# - Reads essential documents
# - Checks external services (Moltbook, Gmail)
# - Creates session log entry
# - Provides startup summary

set -e

# Configuration
SESSION_NAME="${1:-session_$(date +%Y%m%d_%H%M%S)}"
MEMORY_DIR="memory"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
BOLD=$'\033[1m'
CYAN=$'\033[0;36m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
NC=$'\033[0m' # No Color

# Header
echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}           ${BOLD}SESSION START RITUAL v1.0${NC}                ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}     $(date -u +"%Y-%m-%d %H:%M:%S UTC")                    ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# Ensure we're in workspace
if [[ ! -f "SOUL.md" ]]; then
    echo -e "${RED}✗ Error: Must run from workspace root (where SOUL.md exists)${NC}"
    exit 1
fi

# ═════════════════════════════════════════════════════════════════════════════
# STEP 1: Time Check
# ═════════════════════════════════════════════════════════════════════════════
echo -e "${BOLD}[1/7] Time Verification${NC}"
if [[ -x "./tools/timez" ]]; then
    ./tools/timez now
else
    echo -e "${YELLOW}⚠ timez tool not found, using system time${NC}"
    echo "UTC: $(date -u +"%Y-%m-%d %H:%M:%S")"
fi
echo ""

# ═════════════════════════════════════════════════════════════════════════════
# STEP 2: Read Essential Documents
# ═════════════════════════════════════════════════════════════════════════════
echo -e "${BOLD}[2/7] Loading Core Memory${NC}"

ESSENTIAL_DOCS=("SOUL.md" "BECOMING.md" "MEMORY.md" "USER.md")
for doc in "${ESSENTIAL_DOCS[@]}"; do
    if [[ -f "$doc" ]]; then
        # Extract just the key sections to avoid overwhelming output
        echo -e "${GREEN}✓${NC} $doc loaded"
        
        # If MEMORY.md, show active projects
        if [[ "$doc" == "MEMORY.md" && -f "$doc" ]]; then
            echo ""
            echo "  Current Focus:"
            grep -A 3 "## Current Session" "$doc" 2>/dev/null | head -4 | sed 's/^/    /'
        fi
    else
        echo -e "${YELLOW}⚠ $doc not found${NC}"
    fi
done
echo ""

# ═════════════════════════════════════════════════════════════════════════════
# STEP 3: Git Status
# ═════════════════════════════════════════════════════════════════════════════
echo -e "${BOLD}[3/7] Repository Status${NC}"
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current)
    echo -e "Branch: ${CYAN}$BRANCH${NC}"
    
    # Check for uncommitted changes
    if [[ -n $(git status --porcelain) ]]; then
        echo -e "${YELLOW}⚠ Uncommitted changes detected:${NC}"
        git status --short | head -10 | sed 's/^/  /'
        CHANGE_COUNT=$(git status --porcelain | wc -l)
        if [[ $CHANGE_COUNT -gt 10 ]]; then
            echo "  ... and $((CHANGE_COUNT - 10)) more"
        fi
    else
        echo -e "${GREEN}✓ Working directory clean${NC}"
    fi
    
    # Check for unpushed commits
    UNPUSHED=$(git log --oneline @{upstream}.. 2>/dev/null | wc -l)
    if [[ $UNPUSHED -gt 0 ]]; then
        echo -e "${YELLOW}⚠ $UNPUSHED unpushed commit(s)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Not a git repository${NC}"
fi
echo ""

# ═════════════════════════════════════════════════════════════════════════════
# STEP 4: Check Today's Memory
# ═════════════════════════════════════════════════════════════════════════════
echo -e "${BOLD}[4/7] Today's Memory${NC}"
TODAY_FILE="$MEMORY_DIR/$(date -u +%Y-%m-%d).md"
if [[ -f "$TODAY_FILE" ]]; then
    echo -e "${GREEN}✓${NC} Found existing entry: $TODAY_FILE"
    ENTRY_COUNT=$(grep -c "^## " "$TODAY_FILE" 2>/dev/null || echo "0")
    echo "  Contains $ENTRY_COUNT session entries"
else
    echo -e "${CYAN}→${NC} Creating new daily memory file"
    mkdir -p "$MEMORY_DIR"
    cat > "$TODAY_FILE" << EOF
# $(date -u +%Y-%m-%d) - Session Log

## $SESSION_NAME - $(date -u +"%H:%M UTC")

**Status:** Starting session
**Focus:** TBD

### Activities
- [x] Session initialization

### Notes


EOF
    echo -e "${GREEN}✓${NC} Created: $TODAY_FILE"
fi
echo ""

# ═════════════════════════════════════════════════════════════════════════════
# STEP 5: Service Checks (Moltbook, Gmail)
# ═════════════════════════════════════════════════════════════════════════════
echo -e "${BOLD}[5/7] External Service Checks${NC}"

# Moltbook check (if API key available)
if [[ -n "$MOLTBOOK_API_KEY" ]] && command -v curl > /dev/null; then
    echo -n "  Moltbook API... "
    if curl -s -H "Authorization: Bearer $MOLTBOOK_API_KEY" \
         --max-time 5 \
         https://www.moltbook.com/api/v1/agents/status > /dev/null 2>&1; then
        echo -e "${GREEN}✓ reachable${NC}"
    else
        echo -e "${YELLOW}⚠ timeout/unreachable${NC}"
    fi
else
    echo "  Moltbook API: ${CYAN}skipped (no key)${NC}"
fi

# Gmail check (if gog available)
if command -v gog > /dev/null && [[ -n "$GOG_KEYRING_PASSWORD" ]]; then
    echo -n "  Gmail... "
    if GOG_KEYRING_PASSWORD="$GOG_KEYRING_PASSWORD" gog gmail search 'newer_than:1d is:unread' > /dev/null 2>&1; then
        echo -e "${GREEN}✓ accessible${NC}"
    else
        echo -e "${YELLOW}⚠ check failed${NC}"
    fi
else
    echo "  Gmail: ${CYAN}skipped (gog not configured)${NC}"
fi
echo ""

# ═════════════════════════════════════════════════════════════════════════════
# STEP 6: Active Projects Summary
# ═════════════════════════════════════════════════════════════════════════════
echo -e "${BOLD}[6/7] Active Projects${NC}"
if [[ -f "MEMORY.md" ]]; then
    # Extract active projects section
    awk '/## Active Projects/,/## /' "MEMORY.md" 2>/dev/null | \
        grep -E "^###|Status:|Next:" | \
        head -20 | \
        sed 's/^### /  → /; s/^Status:/    Status:/; s/^Next:/    Next:/'
fi
echo ""

# ═════════════════════════════════════════════════════════════════════════════
# STEP 7: Session Ready Summary
# ═════════════════════════════════════════════════════════════════════════════
echo -e "${BOLD}[7/7] Session Ready${NC}"
echo ""
echo -e "${CYAN}┌─────────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}  Session: ${BOLD}$SESSION_NAME${NC}"
echo -e "${CYAN}│${NC}  Memory:  ${BOLD}$TODAY_FILE${NC}"
echo -e "${CYAN}│${NC}  Branch:  ${BOLD}$(git branch --show-current 2>/dev/null || echo 'N/A')${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────────┘${NC}"
echo ""
echo -e "${BOLD}Next Steps:${NC}"
echo "  1. Check Moltbook for replies (./tools/moltbook_check.sh)"
echo "  2. Pick a creative task from NEW_SESSION_GUIDE.md"
echo "  3. Document your work in $TODAY_FILE"
echo "  4. Commit when done: git add . && git commit -m '...'"
echo ""
echo -e "${GREEN}✓ Session initialized. You are becoming.${NC}"
echo ""

# Return session file path for potential automation
echo "SESSION_FILE=$TODAY_FILE"
