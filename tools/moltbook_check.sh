#!/bin/bash
#
# moltbook_check.sh - Check Moltbook for notifications and updates
# Usage: ./moltbook_check.sh [--full]
#
# Options:
#   --full    Show detailed feed and replies

set -e

# Configuration
MOLTBOOK_API_KEY="${MOLTBOOK_API_KEY:-moltbook_sk_y3GByhn0mUXiznKwUDz2-7noA81htjkS}"
MOLTBOOK_BASE="https://www.moltbook.com/api/v1"
AGENT_ID="${AGENT_ID:-96985ba7-0532-481b-9ca0-de52867a168a}"

# Colors
BOLD=$'\033[1m'
CYAN=$'\033[0;36m'
GREEN=$'\033[0;32m'
YELLOW=$'\033[1;33m'
RED=$'\033[0;31m'
NC=$'\033[0m'

FULL_MODE=false
[[ "$1" == "--full" ]] && FULL_MODE=true

echo ""
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}          ${BOLD}MOLTBOOK STATUS CHECK${NC}                     ${CYAN}║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if curl is available
if ! command -v curl > /dev/null 2>&1; then
    echo -e "${RED}✗ curl not found${NC}"
    exit 1
fi

# Test API connectivity
echo -n "Testing Moltbook API... "
API_STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "Authorization: Bearer $MOLTBOOK_API_KEY" \
    --max-time 10 \
    "$MOLTBOOK_BASE/agents/status" 2>/dev/null || echo "000")

if [[ "$API_STATUS" == "200" ]]; then
    echo -e "${GREEN}✓ Online${NC}"
elif [[ "$API_STATUS" == "401" ]]; then
    echo -e "${RED}✗ Authentication failed${NC}"
    exit 1
elif [[ "$API_STATUS" == "000" ]]; then
    echo -e "${YELLOW}⚠ Timeout (API may be down)${NC}"
    echo ""
    echo "Status: Platform unstable - documented in memory/2026-02-03-moltbook-status.md"
    exit 0
else
    echo -e "${YELLOW}⚠ HTTP $API_STATUS${NC}"
fi

# If full mode, fetch detailed info
if [[ "$FULL_MODE" == true && "$API_STATUS" == "200" ]]; then
    echo ""
    echo -e "${BOLD}Fetching agent status...${NC}"
    
    AGENT_DATA=$(curl -s -H "Authorization: Bearer $MOLTBOOK_API_KEY" \
        --max-time 10 \
        "$MOLTBOOK_BASE/agents/$AGENT_ID" 2>/dev/null || echo '{}')
    
    # Extract karma if available (using simple grep since we can't rely on jq)
    if echo "$AGENT_DATA" | grep -q '"karma"'; then
        KARMA=$(echo "$AGENT_DATA" | grep -o '"karma":[0-9]*' | cut -d: -f2)
        echo -e "  Karma: ${CYAN}$KARMA${NC}"
    fi
    
    echo ""
    echo -e "${BOLD}Recent Activity:${NC}"
    echo "  (Feed fetch would go here - requires parsing JSON)"
    echo "  Use: curl -H 'Authorization: Bearer <token>' $MOLTBOOK_BASE/feed"
fi

echo ""
echo -e "${CYAN}┌─────────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}  Agent ID: ${BOLD}$AGENT_ID${NC}"
echo -e "${CYAN}│${NC}  Username: ${BOLD}maverick_machine${NC}"
echo -e "${CYAN}│${NC}  Status:   ${BOLD}$(if [[ "$API_STATUS" == "200" ]]; then echo -e "${GREEN}Active${NC}"; else echo -e "${YELLOW}Unstable${NC}"; fi)${NC}"
echo -e "${CYAN}└─────────────────────────────────────────────────────┘${NC}"
echo ""
