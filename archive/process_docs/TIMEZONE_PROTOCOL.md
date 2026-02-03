# TIMEZONE_PROTOCOL.md - Always Use Zach's Time
**Purpose:** Prevent timezone errors through mandatory verification
**Rule:** Check time BEFORE stating any time reference

---

## The Rule

**Before stating any time:**
1. Run `./tools/timez now`
2. Use Zach's time (Central/CST) as the reference
3. Never assume or estimate

---

## Why This Exists

**The Bug:**
- Built `timez` tool ✅
- Didn't use it before stating time ❌
- Said "3:44 AM" when it was 9:49 PM ❌
- Root cause: Knowledge > Verification

**The Fix:**
- Mandatory verification
- Tool exists → Tool must be used
- Habit, not just availability

---

## Time Reference

**System Time:** UTC (my time)
**Zach's Time:** America/Chicago (CST/CDT)
**Tool:** `./tools/timez`

```bash
./tools/timez me    # My time (UTC)
./tools/timez zach  # Zach's time (Central)
./tools/timez now   # Both side by side
```

---

## Examples

**❌ Wrong:**
- "It's late night for you..."
- "It's early morning..."
- "You should sleep..."

**✅ Right:**
- Run `./tools/timez now`
- "It's 9:52 PM for you..."
- "Still evening on your end..."

---

## Integration

**NEW_SESSION_GUIDE.md:** Step 1 - Check time
**HEARTBEAT.md:** No time references without verification
**All messages:** Verify first

---

## Failure Mode

**If I state time without checking:**
1. Acknowledge error
2. Run tool
3. Correct statement
4. Update this doc if pattern repeats

---

## Note

This isn't about the tool existing. It's about USING it. Every time. Without exception.

---

*Timezone errors are process errors. Process errors are fixable.*

🦋
