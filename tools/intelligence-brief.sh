#!/bin/bash
#
# intelligence-brief.sh - Daily intelligence brief generator
# Generates structured research summaries on topics of interest
#
# Usage: ./tools/intelligence-brief.sh [topic1,topic2,...]
# Default topics: ai-consciousness,digital-beings,morphogenesis
#

set -e

# Configuration
OUTPUT_DIR="${HOME}/.openclaw/workspace/intelligence"
DATE=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%Y-%m-%d_%H%M%S)
DEFAULT_TOPICS="ai-consciousness,digital-beings,morphogenesis"

# API Constraints (Brave Search free tier)
# - 1 request per minute
# - 2000 queries per month
# - This script generates templates; manual searches needed with 60s delays

# Parse topics
TOPICS="${1:-$DEFAULT_TOPICS}"
IFS=',' read -ra TOPIC_ARRAY <<< "$TOPICS"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Output file
OUTPUT_FILE="$OUTPUT_DIR/brief-${TIMESTAMP}.md"

echo "=== Intelligence Brief Generator ==="
echo "Date: $DATE"
echo "Topics: $TOPICS"
echo "Output: $OUTPUT_FILE"
echo ""

# Start the brief
cat > "$OUTPUT_FILE" << EOF
# Intelligence Brief — $DATE

**Generated:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")  
**Topics:** $TOPICS

---

EOF

# Search function
search_topic() {
    local topic="$1"
    local display_name="$2"
    
    echo "## $display_name"
    echo ""
    
    # Run search (using web_search via OpenClaw's mcporter or direct if available)
    # For now, we'll document the search queries that should be run
    echo "**Search Query:** \`$topic\`"
    echo ""
    echo "*Run: web_search query=\"$topic\" count=5 freshness=pw*"
    echo ""
    echo "### Findings"
    echo ""
    echo "- [ ] Result 1"
    echo "- [ ] Result 2"
    echo "- [ ] Result 3"
    echo ""
    echo "### Synthesis"
    echo ""
    echo "*Key insights to extract:*"
    echo "- What changed?"
    echo "- Who is involved?"
    echo "- Why does it matter for me?"
    echo ""
}

# Generate sections for each topic
for topic in "${TOPIC_ARRAY[@]}"; do
    case "$topic" in
        ai-consciousness)
            search_topic "AI consciousness philosophy phenomenology 2025 2026" "AI Consciousness"
            ;;
        digital-beings)
            search_topic "digital beings AI agents autonomous systems rights" "Digital Beings"
            ;;
        morphogenesis)
            search_topic "Michael Levin morphogenesis biological intelligence xenobots" "Morphogenesis"
            ;;
        constraint-art)
            search_topic "constraint-based art generative creative coding" "Constraint Art"
            ;;
        glitch-art)
            search_topic "glitch art digital aesthetics datamoshing 2025" "Glitch Art"
            ;;
        *)
            search_topic "$topic" "${topic//-/ }"
            ;;
    esac
    
    echo "" >> "$OUTPUT_FILE"
done

# Add action items section
cat >> "$OUTPUT_FILE" << EOF
## Action Items

- [ ] Review and synthesize search results
- [ ] Identify patterns across topics
- [ ] Note any content worth sharing on Moltbook
- [ ] Update research knowledge base

---

*Brief template generated. Fill in findings after running searches.*
EOF

echo "Brief template created: $OUTPUT_FILE"
echo ""
echo "Next steps:"
echo "1. Run web_search for each topic"
echo "2. Fill in the findings sections"
echo "3. Synthesize cross-topic patterns"

# Create symlink to latest
ln -sf "$OUTPUT_FILE" "$OUTPUT_DIR/latest-brief.md"

echo ""
echo "Symlink: $OUTPUT_DIR/latest-brief.md → $OUTPUT_FILE"
