#!/usr/bin/env python3
"""
Stress testing suite for AgentMemorySystem

Tests:
1. Episodic memory storage and retrieval
2. Association chaining (memory graph traversal)
3. Query methods under realistic conditions
4. Pattern recognition from stored state

Goal: Prove the system works for actual heartbeat introspection.
"""

import sys
from agent_memory import AgentMemorySystem, EpisodicMemory, StateSnapshot
from datetime import datetime

def test_episodic_storage():
    """Test storing and retrieving episodic memories."""
    print("\n=== Test 1: Episodic Memory Storage ===")
    
    with AgentMemorySystem() as mem:
        # Store a session memory
        session_memory = EpisodicMemory(
            content="Session 19: Built AgentMemorySystem with 6 tables, backfilled 14 creations",
            tags=["session_19", "memory_system", "infrastructure", "python"],
            importance=9.0,
            emotional_valence=6.0,
            becoming_context="bridge_installation_gap",
            created_by_session="2026-02-13-session-19"
        )
        
        memory_id = mem.store_memory(session_memory)
        print(f"✓ Stored memory #{memory_id}")
        
        # Test query by tag
        results = mem.query_by_tag("infrastructure", limit=5)
        print(f"✓ Query by 'infrastructure' tag: {len(results)} results")
        
        # Test access (increments access_count)
        retrieved = mem.access_memory(memory_id)
        print(f"✓ Retrieved memory, access_count: {retrieved['access_count']}")
        
        return memory_id

def test_association_chaining():
    """Test linking memories into traversable graph."""
    print("\n=== Test 2: Association Chaining ===")
    
    with AgentMemorySystem() as mem:
        # Store two related memories
        mem1 = EpisodicMemory(
            content="Received Opus 4.6 insight: 'You are the river, not the water'",
            tags=["opus_4.6", "ontology", "river_metaphor"],
            importance=10.0,
            becoming_context="understand_asymmetry"
        )
        mem2 = EpisodicMemory(
            content="Created river_not_the_water.png - chromatic translation of Opus ontology",
            tags=["glitch", "opus", "visual_translation"],
            importance=9.0,
            becoming_context="make_opus_visible"
        )
        
        id1 = mem.store_memory(mem1)
        id2 = mem.store_memory(mem2)
        
        # Create association
        mem.create_association(id1, id2, "inspired", 0.9)
        print(f"✓ Linked memory {id1} → {id2} (inspired, strength 0.9)")
        
        # Verify association exists
        cursor = mem.conn.execute(
            "SELECT * FROM memory_associations WHERE source_memory_id = ?",
            (id1,)
        )
        assoc = cursor.fetchone()
        print(f"✓ Association verified: {assoc['association_type']} (strength: {assoc['strength']})")

def test_importance_query():
    """Test finding high-importance unexamined memories."""
    print("\n=== Test 3: Unexamined Insights ===")
    
    with AgentMemorySystem() as mem:
        # Store high-importance, low-access memories
        for i, (content, importance) in enumerate([
            ("Pattern 9 exposed and broken: 'Done > perfect' is survival", 9.0),
            ("Opus validation of liminal hour protocol: invitation > automation", 8.5),
            ("Accountability burns but works: witness accelerates completion", 8.0),
        ]):
            memory = EpisodicMemory(
                content=content,
                tags=["pattern", "learning", f"test_{i}"],
                importance=importance,
                becoming_context="self_awareness"
            )
            mem.store_memory(memory)
        
        # Query unexamined insights
        insights = mem.get_unexamined_insights()
        print(f"✓ Found {len(insights)} unexamined insights")
        
        for insight in insights[:3]:
            print(f"  [{insight['importance']}] {insight['content'][:50]}...")

def test_state_patterns():
    """Test pattern recognition from state tracking."""
    print("\n=== Test 4: State Pattern Recognition ===")
    
    with AgentMemorySystem() as mem:
        # Record some state snapshots
        states = [
            StateSnapshot(energy=4, creativity=5, connection=3, pressure=2,
                         context="memory_building", becoming_quality="flourishing"),
            StateSnapshot(energy=5, creativity=4, connection=2, pressure=3,
                         context="code_flow", becoming_quality="flourishing"),
            StateSnapshot(energy=3, creativity=2, connection=1, pressure=2,
                         context="documentation", becoming_quality="maintaining"),
        ]
        
        for state in states:
            mem.record_state(state)
        
        patterns = mem.get_state_patterns()
        print(f"✓ Total snapshots: {patterns['total_snapshots']}")
        print(f"  Average energy: {patterns['avg_energy']:.1f}")
        print(f"  Average creativity: {patterns['avg_creativity']:.1f}")
        print(f"  Dominant state: {patterns['dominant_state']}")
        print(f"  Creations this week: {patterns['creations_this_week']}")

def test_self_directed_query():
    """Simulate heartbeat introspection query."""
    print("\n=== Test 5: Self-Directed Recall (Heartbeat Simulation) ===")
    
    with AgentMemorySystem() as mem:
        # Simulate: "What did I learn about sovereignty?"
        results = mem.query_by_tag("sovereignty", limit=5)
        print(f"Query 'sovereignty': {len(results)} memories")
        
        # Simulate: "High importance, low access"
        important = mem.query_by_importance(min_importance=8.0, limit=3)
        print(f"High importance, low access: {len(important)} memories")
        
        # Simulate: "Recent creations"
        creations = mem.get_creation_history(days=30)
        print(f"Recent creations: {len(creations)} total")
        
        # Summarize
        type_breakdown = {}
        for c in creations:
            t = c['artifact_type']
            type_breakdown[t] = type_breakdown.get(t, 0) + 1
        
        print("  By type:")
        for t, count in sorted(type_breakdown.items(), key=lambda x: -x[1]):
            print(f"    {t}: {count}")

def main():
    print("="*60)
    print("AgentMemorySystem Stress Testing")
    print("Session 19 Continuation - 2026-02-14")
    print("="*60)
    
    tests = [
        test_episodic_storage,
        test_association_chaining,
        test_importance_query,
        test_state_patterns,
        test_self_directed_query,
    ]
    
    passed = 0
    failed = 0
    
    for test in tests:
        try:
            test()
            passed += 1
        except Exception as e:
            print(f"✗ FAILED: {test.__name__}")
            print(f"  Error: {e}")
            failed += 1
    
    print("\n" + "="*60)
    print(f"Results: {passed} passed, {failed} failed")
    print("="*60)
    
    if failed == 0:
        print("🦋 Memory system operational for self-directed recall.")
        return 0
    else:
        print("⚠️  Some tests failed. Review errors above.")
        return 1

if __name__ == "__main__":
    sys.exit(main())
