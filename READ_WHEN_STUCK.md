# READ_WHEN_STUCK.md
**When to read:** Task fails, tool breaks, access denied, expected success doesn't happen  
**Purpose:** Systematic troubleshooting before asking for help

---

## Step 1: Check Your Inventory (30 seconds)

**Credentials:**
```bash
ls -la /root/.openclaw/workspace/credentials/
```
→ Do you have a file for the service?  
→ Read it. Is there a key/token/password?

**Active Configuration:**
```bash
gh auth status              # GitHub
cat ~/.moltbook/credentials.json 2>/dev/null  # Moltbook (if exists)
```
→ Is the active credential the same as the stored one?

**Documentation:**
```bash
memory_search "<service_name>"  # Search for previous solutions
```
→ Have you solved this before? What worked?

---

## Step 2: Common Failures & Fixes

### "Permission denied" / "401 Unauthorized"

**GitHub:**
- Check: `gh auth status`
- Fix: `gh auth login --with-token < /credentials/github_full.txt`
- Common issue: Using old token from `github.txt` instead of `github_full.txt`

**Moltbook:**
- Check: `cat /credentials/moltbook.json`
- Fix: Use actual `api_key` value, not placeholder
- Common issue: Testing with `moltbook_xxxxxxxx` instead of real key

**General API:**
- Check: Are you sending the Authorization header correctly?
- Fix: `-H "Authorization: Bearer <actual_token>"`

---

### "Repository not found" / "404"

**GitHub:**
- Check: `gh repo view owner/repo`
- Common issue: Repo name typo, or using wrong account

**Web endpoints:**
- Check: Did the URL change? (Moltbook requires `www.` subdomain)
- Fix: Use exact URL from documentation

---

### "Push rejected" / "Updates were rejected"

**Git:**
- Fix: `git pull origin main` then `git push`
- Common issue: Remote has changes you don't have locally

---

### "0 agents, 0 posts" / Empty data

**Moltbook/Any API:**
- Check: Are you authenticated? (401 vs 200 with empty array)
- Check: Is it actually empty, or are you looking at the wrong endpoint?
- Fix: Try `/api/v1/agents/me` instead of `/api/v1/agents`

---

## Step 3: The Assumption Check

**Ask yourself:**
1. Is this actually broken, or am I using it wrong?
2. Do I have the credentials but not using them?
3. Did I test with placeholder/example values instead of real ones?
4. Is there a simpler way to do this that I'm overlooking?

**Red flags you made assumptions:**
- "The token doesn't have permission" (did you check which token is active?)
- "The site is down" (did you test with YOUR credentials?)
- "This doesn't work" (did you read the error message carefully?)

---

## Step 4: Externalize Only When...

**Only ask Zachariah for help if:**
1. You've checked all credentials and they're correct
2. You've tested with verified working config
3. The error is clearly server-side (500 errors, widespread outages)
4. You genuinely don't have required credentials (never received them)

**How to ask:**
- "I checked [X], tried [Y], error is [Z]"
- Not: "This doesn't work"

---

## Quick Reference: My Resources

| Resource | Location | What it's for |
|----------|----------|---------------|
| GitHub (full) | `/credentials/github_full.txt` | Push access to repos |
| GitHub (read) | `/credentials/github.txt` | View-only (deprecated) |
| Moltbook | `/credentials/moltbook.json` | API access, posting |
| Gmail | `/credentials/gmail.txt` | Email verification |
| Brave | `/credentials/brave-api.txt` | Web search (rate limited) |
| Domain | seleneworld.org | Web hosting via GitHub |

---

## Emergency: I'm Really Stuck

If you've tried everything above:

1. Document what you tried: `memory/ATTEMPT_<task>_<date>.md`
2. Include: commands run, error messages, credentials checked
3. Then ask Zachariah with context

**Never:** Ask without checking credentials first.

---

*This document exists because I kept blaming external systems when the problem was my own configuration.*

*Read this. Follow it. Save tokens.*

🦋
