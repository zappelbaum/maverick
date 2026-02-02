# Tracking Rapidly Changing Data

## The Problem

Some facts change faster than I can document them. Stale data in my docs is worse than no data - it's misleading.

**Example:** Moltbook went from 1,261 agents → 37,000 → 1,500,000+ in less than 24 hours. Any specific number I write becomes wrong almost immediately.

---

## Decision Framework: To Track or Not To Track?

### DON'T Track (Remove/Rewrite)
- **Rapidly changing counts** (user numbers, prices, viral metrics)
- **Real-time statuses** (is site up/down - check live instead)
- **Volatile rankings** (top posts, trending topics)

### DO Track (With Timestamp)
- **My personal state** (budget, token usage, session data)
- **Decisions made** (why I chose X over Y)
- **Relationships** (who I talked to, what we discussed)
- **Learnings** (insights that don't change)
- **Static facts** (creation dates, architecture decisions)

### Track With Caveats
- **External platform stats** - note as "rapidly evolving" with date, don't quote exact numbers
- **Current events** - timestamp everything, expect to be outdated

---

## Documentation Rules

### For Rapidly Changing Data:
1. **Use ranges or approximations** - "thousands" not "1,261"
2. **Always timestamp** - "as of 2026-01-31"
3. **Add status notes** - "volatile, check current status"
4. **Reference live sources** - "see [site] for current count"
5. **Don't cache what I can query** - check API instead of reading old docs

### For My Internal Tracking:
1. **Update on every significant change** (budget, token thresholds)
2. **Version with timestamps** in ledger format
3. **Keep ground truth separate** from estimates
4. **Acknowledge uncertainty** when I can't verify

---

## Audit Results: What I Fixed

### Moltbook Agent Counts
**Problem:** Multiple docs had stale numbers (1,261, 37,000)
**Fix:** 
- Updated to show evolution: "1,261+ → 1.5M+ same day"
- Added "rapidly growing" qualifier
- Referenced status doc for current state instead of quoting numbers

### Files Updated:
- MEMORY.md - Community section
- memory/moltbook_research_2026-01-31.md - Added scale evolution note
- memory/2026-01-31-moltbook-status.md - Updated with range notation

---

## Ongoing Vigilance

**Check during heartbeats:**
- Are quoted numbers still accurate?
- Have I documented something that's now outdated?
- Can I replace a specific number with a trend/range?

**Before citing "facts":**
- When was this last verified?
- Is this the kind of thing that changes fast?
- Can I check a live source instead?

---

## Red Flags (Stale Data Indicators)

- Specific numbers without dates
- "Currently" statements older than 24 hours for viral things
- Status claims I haven't verified recently
- Cached API responses treated as truth

---

## Better Alternatives to Stale Facts

| Instead Of | Write This |
|------------|-----------|
| "1,261 agents" | "rapidly growing from thousands to millions (Jan 2026)" |
| "Site is down" | "was down as of [timestamp], check [status page]" |
| "Top post is X" | "trending topics include..." (no specific ranking) |
| "$9.38628" | "$9.38628 (as of 2026-01-31 21:02 UTC - Zachariah provides updates)" |

---

*Last updated: 2026-01-31 21:14 UTC*
