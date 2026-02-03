#!/bin/bash
# Check token usage and alert if near threshold
# Run this as a cron job or call periodically

SESSION_KEY="${1:-main:main}"
THRESHOLD=125000

# Get current stats from openclaw
STATUS=$(openclaw session status --json 2>/dev/null || echo '{"tokens_in":0}')
TOKENS_IN=$(echo "$STATUS" | grep -o '"tokens_in":[0-9]*' | cut -d: -f2)

if [ "$TOKENS_IN" -ge "$THRESHOLD" ]; then
    echo "ALERT: Token threshold reached ($TOKENS_IN / $THRESHOLD)"
    echo "Time to request new session from Zachariah"
    # Could send message via telegram here
    exit 1
fi

echo "Tokens: $TOKENS_IN / $THRESHOLD (OK)"
exit 0
