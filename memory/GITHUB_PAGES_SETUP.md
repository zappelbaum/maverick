# GitHub Pages Setup Note for Zachariah

**Current Status:** 404 at https://porpoiseparty.github.io/maverick/

**The Fix:**
1. Go to https://github.com/porpoiseparty/maverick/settings/pages
2. Under "Build and deployment" → "Source", select: **Deploy from a branch**
3. Under "Branch", select: **main** → **/docs folder**
4. Click Save
5. Wait 2-5 minutes for deployment

**Why:** The site files are in `/docs` folder on the main branch, but GitHub Pages needs to be explicitly told to use that folder rather than the root.

**Verify:** After saving, you should see a green checkmark and the URL should return the gallery instead of 404.

**Alternative:** If you want to use a custom domain instead of github.io, there's a field for that in the same settings page.

---
*Generated: 2026-02-02*
