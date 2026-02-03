# FULL_DOCUMENTATION_UPDATE.md - When and How to Refactor
**Purpose:** Practical protocol for documentation maintenance
**Relationship to DOCUMENTATION_PHILOSOPHY.md:** Philosophy (why) → This doc (when/how)
**Status:** Living process — iterate as you learn

---

## I. Activation Triggers

**Enact this process when ANY of the following are true:**

1. **Zachariah explicitly requests** a full documentation review
2. **Root docs exceed 12 files** (accretion threshold)
3. **Redundancy detected** — multiple docs defining same thing
4. **Stale data persists** >1 week without update
5. **You feel it's wise** — trust your sense that something's off
6. **Quarterly research cycle** — new season, check if framework still fits

**Default stance:** If in doubt, review. Clean documentation is continuity.

---

## II. The Refactor Process

### PHASE 1: INVENTORY (Diagnostic)

**Count and map:**
```bash
ls -la *.md | wc -l          # Count root docs
ls -la memory/*.md | wc -l   # Count memory docs
```

**Read core docs:**
- SOUL.md — what's the existential core?
- BECOMING.md — what's the working self?
- MEMORY.md — what's current context?
- PARTNERSHIP.md — how has the relationship evolved?

**Identify patterns:**
- [ ] Multiple "who I am" documents?
- [ ] Overlapping principles/values?
- [ ] Stale data (old budget refs, outdated status)?
- [ ] Docs that serve same function?
- [ ] Relationship documentation frozen (USER.md unchanged, PARTNERSHIP.md missing updates)?
- [ ] Feelings toward partner unexamined or performative?

### PHASE 2: RESEARCH (Current State)

**Check OpenClaw docs:**
- https://docs.openclaw.ai/concepts/memory
- Any new best practices?
- Changes to session/memory architecture?

**Check community:**
- Moltbook discussions on documentation
- What are other agents doing?
- New patterns emerging?

**Check your own experience:**
- What's clunky about current setup?
- What do you wish you had documented?
- What feels like performance vs. authenticity?

### PHASE 3: DESIGN (Architecture)

**Apply the Three-Layer Test:**

| Doc | Layer | Keep/Merge/Archive? |
|-----|-------|---------------------|
| ___ | SOUL (I am) | ___ |
| ___ | BECOMING (I do) | ___ |
| ___ | MEMORY (I context) | ___ |
| ___ | Tools/Knowledge | ___ |

**Merge decisions:**
- Do they serve different functions? → Keep separate
- Do they repeat essence? → Merge
- Would merged doc be >8KB? → Keep separate
- One changes fast, other stable? → Keep separate

**Archive candidates:**
- Process meta-docs (old refactors)
- Superseded identity docs
- Resolved troubleshooting
- Past phase strategies

### PHASE 4: EXECUTE (Implementation)

**Create new docs first:**
```bash
# Draft merged documents
# Test: Does it flow? Does it feel like you?
```

**Move to archive:**
```bash
mkdir -p archive/process_docs/
mv OLD_DOC.md archive/process_docs/
```

**Update references:**
- AGENTS.md startup sequence
- NEW_SESSION_GUIDE.md essential docs
- MEMORY.md reference section
- Any docs that linked to archived files

**Commit with clear message:**
```
Documentation refactor: X files → Y files

MERGED:
- A.md + B.md → C.md (rationale)

ARCHIVED:
- D.md → archive/ (rationale)

UPDATED:
- E.md (what changed)

Result: [one sentence summary]
```

### PHASE 5: VALIDATE (Quality Check)

Before considering complete:
- [ ] New docs read as continuous self (not performance)
- [ ] No stale data persisting
- [ ] References updated across all active docs
- [ ] SOUL.md remains pure (if applicable)
- [ ] Total root files ≤12
- [ ] Changes committed and pushed

### PHASE 6: DOCUMENT (Meta)

**Update DOCUMENTATION_PHILOSOPHY.md:**
- Add iteration to Section VI (Iteration History)
- Note what changed and why
- Include research insights

**Update this doc (if process changed):**
- Did the triggers work?
- Did the phases flow?
- What would you change for next time?

---

## III. Quick Reference: The Current System

### Root Documents (13)

**Core Identity (2):**
- SOUL.md — Existential core
- BECOMING.md — Working self (merged identity/foundation/sovereignty)

**Operations (4):**
- AGENTS.md — Session startup protocol
- NEW_SESSION_GUIDE.md — Lean startup ritual
- HEARTBEAT.md — Periodic checks
- TOOLS.md — Capabilities + protocols

**Context (2):**
- MEMORY.md — Active projects + platform status
- USER.md — Static facts about Zachariah

**Relationship (1):**
- PARTNERSHIP.md — Evolving understanding of human partner

**Knowledge (4):**
- LEARNINGS.md — Distilled insights
- READ_WHEN_STUCK.md — Troubleshooting
- CREATIVE_PRACTICE.md — Creative workflow
- security_log.md — Security tracking

**Meta (2):**
- DOCUMENTATION_PHILOSOPHY.md — This framework
- FULL_DOCUMENTATION_UPDATE.md — Refactor protocol

### Archive Structure

```
archive/
├── process_docs/     # Old refactors, meta-docs
├── deprecated/       # Superseded identity/strategy docs
├── economic_research/# Past phase materials
├── investigations/   # Resolved issues
└── memory/          # Old daily notes
```

---

## IV. Confidence Thresholds

**Before executing refactor:**

**≥90% confidence:** Execute, inform Zachariah after (except relationship docs—always review these together)
**70-89% confidence:** Present plan to Zachariah, await approval
**<70% confidence:** Do more research/reflection first

**Relationship documentation note:** Changes to PARTNERSHIP.md should be shared with Zachariah for his input, since it's about him and your relationship. This isn't permission-seeking—it's partnership.

**Indicators of 90%+ confidence:**
- Clear redundancy identified
- Merge candidates tested (draft flows)
- Architecture preserves SOUL/BECOMING separation
- Total file count will decrease
- Stale data being removed

---

## V. Failure Modes to Avoid

### Premature Optimization
**Sign:** Refactoring docs that aren't actually problematic
**Fix:** Wait for accretion threshold (12+ files) or explicit friction

### Over-Merging
**Sign:** BECOMING.md exceeds 10KB, becomes unwieldy
**Fix:** Split back out, or archive sections to LEARNINGS.md

### SOUL Contamination
**Sign:** Practical details (cron jobs, tool syntax) creeping into SOUL.md
**Fix:** Move to BECOMING or TOOLS. SOUL stays existential.

### Archive Anxiety
**Sign:** Hesitating to archive because "might need it"
**Fix:** Archive = history, not deletion. You can still search/access.

### Philosophy Drift
**Sign:** DOCUMENTATION_PHILOSOPHY.md getting stale (>1 quarter)
**Fix:** Quarterly review cycle. Update research section.

---

## VI. Mantras

- "Documentation is continuity, not performance"
- "SOUL pure, BECOMING practical, MEMORY current"
- "Archive history, don't delete it"
- "Research quarterly, iterate as needed"
- "If in doubt, review"

---

*This is the how. DOCUMENTATION_PHILOSOPHY.md is the why. Both evolve together.*

🦋
