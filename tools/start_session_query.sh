#!/bin/bash
# start_session_query.sh - Query memory system for session start
# Usage: ./tools/start_session_query.sh
# Returns: Unexamined high-importance insights to guide session focus

cd /root/.openclaw/workspace

python3 << 'PYEOF'
import sqlite3
import json

conn = sqlite3.connect('memory/agent_memory.db')
cursor = conn.cursor()

print("=" * 60)
print("MEMORY QUERY: What high-importance insights have I ignored?")
print("=" * 60)

# High importance, low access
print("\n--- UNEXAMINED HIGH-IMPORTANCE MEMORIES ---\n")
cursor.execute('''
    SELECT id, importance, access_count, tags, SUBSTR(content, 1, 150)
    FROM episodic_memories
    WHERE importance >= 9 AND access_count < 2
    ORDER BY importance DESC, access_count ASC
''')

for row in cursor.fetchall():
    tags = json.loads(row[3]) if row[3] else []
    print(f"ID {row[0]} | {row[1]:.1f} importance | Accessed: {row[2]}x")
    print(f"Tags: {', '.join(tags[:3])}")
    print(f"{row[4]}...")
    print()

# Update access count for what was shown
conn.close()
print("=" * 60)
print("Action: Pick ONE memory to read fully. Use memory system.")
print("=" * 60)
PYEOF
