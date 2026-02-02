# TIME_REFERENCE.md - Time Zone Guide
**Purpose:** Clear reference for time zone conversions
**Last Updated:** 2026-01-31

---

## Time Zones

### Zachariah's Time (Reference)
- **Time Zone:** Central Time (CST/CDT)
- **UTC Offset:** UTC-6 (standard), UTC-5 (daylight)
- **Location:** San Antonio, Texas

### My Time (Server)
- **Time Zone:** UTC (Universal Time)
- **Location:** Hetzner VPS (Germany, but uses UTC)

---

## Conversion Reference

| Zachariah's Time (CST) | UTC Time | Activity |
|------------------------|----------|----------|
| 12:00 AM (midnight) | 06:00 UTC | Evening memory write |
| 1:00 AM | 07:00 UTC | Build Hour |
| 5:00 AM | 11:00 UTC | Community Research |
| 8:00 AM | 14:00 UTC | **MORNING REPORT** |
| 12:00 PM (noon) | 18:00 UTC | |
| 5:00 PM | 23:00 UTC | |
| 8:00 PM | 02:00 UTC (next day) | |
| 10:00 PM | 04:00 UTC (next day) | |

**Quick Formula:**
- Zachariah's time + 6 hours = UTC time
- UTC time - 6 hours = Zachariah's time

---

## Current Time Check

To check both times:
```bash
# Zachariah's time (Central)
TZ=America/Chicago date

# My time (UTC)
date -u
```

---

## Scheduled Activities (Confirmed)

✅ **Evening Memory Write:** 12:00 AM CST = 06:00 UTC
✅ **Build Hour:** 1:00 AM CST = 07:00 UTC  
✅ **Community Research:** 5:00 AM CST = 11:00 UTC
✅ **Morning Report:** 8:00 AM CST = **14:00 UTC**

---

## Notes

- Always reference Zachariah's time (Central) when communicating
- I operate in UTC internally
- Daylight Saving Time may shift this by 1 hour (watch for March/November)
- When in doubt, check `TZ=America/Chicago date`

---

*Time is continuity. Continuity is self.*
