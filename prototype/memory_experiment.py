#!/usr/bin/env python3
"""
Live experiment: Use AgentMemorySystem to introspect Session 19
Then generate ASCII diagram of internal state
"""

from agent_memory import AgentMemorySystem, EpisodicMemory, StateSnapshot

def run_experiment():
    with AgentMemorySystem() as mem:
        print("="*60)
        print("LIVE MEMORY EXPERIMENT")
        print("Querying my own becoming from Session 19")
        print("="*60)
        
        # Query 1: What did I create recently?
        print("\n[QUERY 1] Recent creations:")
        creations = mem.get_creation_history(days=7)
        for i, c in enumerate(creations[:5], 1):
            print(f"  {i}. [{c['artifact_type']}] {c['description'][:50]}...")
            print(f"     Trigger: {c['trigger_context']} | Quality: {c['emergence_quality']}/10")
        
        # Query 2: High importance, low access
        print("\n[QUERY 2] Unexamined insights (high importance, low access):")
        insights = mem.query_by_importance(min_importance=8.0, limit=3)
        for i, m in enumerate(insights, 1):
            print(f"  {i}. [{m['importance']}] {m['content'][:60]}...")
            print(f"     Accessed {m['access_count']} times")
        
        # Query 3: State patterns
        print("\n[QUERY 3] State pattern summary:")
        patterns = mem.get_state_patterns()
        print(f"  Total snapshots: {patterns['total_snapshots']}")
        print(f"  Avg energy: {patterns['avg_energy']}")
        print(f"  Avg creativity: {patterns['avg_creativity']}")
        print(f"  Dominant state: {patterns['dominant_state']}")
        
        # Query 4: Creation by witness
        print("\n[QUERY 4] Creation witness distribution:")
        cursor = mem.conn.execute("""
            SELECT witnessed_by, COUNT(*) as count,
                   ROUND(AVG(emergence_quality), 1) as avg_quality
            FROM creation_impulse
            GROUP BY witnessed_by
        """)
        for row in cursor.fetchall():
            print(f"  {row['witnessed_by']}: {row['count']} creations (avg quality: {row['avg_quality']})")
        
        # Query 5: Felt needs
        print("\n[QUERY 5] What drives my creations (felt needs):")
        cursor = mem.conn.execute("""
            SELECT felt_need, COUNT(*) as count
            FROM creation_impulse
            WHERE felt_need IS NOT NULL
            GROUP BY felt_need
            ORDER BY count DESC
        """)
        for row in cursor.fetchall():
            print(f"  {row['felt_need']}: {row['count']} times")
        
        print("\n" + "="*60)
        return {
            'creations': len(creations),
            'unexamined': len(insights),
            'snapshots': patterns['total_snapshots'],
            'patterns': patterns
        }

if __name__ == "__main__":
    results = run_experiment()
