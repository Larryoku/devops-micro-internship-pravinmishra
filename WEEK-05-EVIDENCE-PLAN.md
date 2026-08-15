# Week 05 Evidence Capture Plan

**Goal:** Collect all remaining screenshots and evidence to complete Week 05 assignments.  
**Total Evidence Items:** 43 screenshots + 1 demo video + text notes

---

## Phase 1: Assignment 2 Setup (Foundation)
**Duration:** ~1–2 hours  
**Output:** 12 screenshots  
**Dependencies:** None — this is your foundational Jira setup

### Prerequisites
- ✅ Jira Space created: "DevOps Micro-Internship Website – Silas Nyarko"
- ✅ Epic created: "Polish DMI Website UI & Deploy"
- ✅ 6 Stories created (S1–S6) with story points, descriptions, acceptance criteria, labels
- ✅ Sub-tasks added to S2 and S4
- ✅ Sprint 1 created and started with Sprint Goal
- ✅ Filters created for `frontend` and `devops` labels

### Screenshot Checklist

| # | Task | What to Capture | Notes |
|---|------|-----------------|-------|
| 1 | Task 1 | Jira Space sidebar showing space name | Ensure "Silas Nyarko" is visible |
| 2 | Task 2 | Backlog with Epic panel enabled, Epic visible | Show Epic is collapsed/expanded |
| 3 | Task 3 | Backlog showing Epic + all 6 Stories under it | Make sure Story IDs (S1–S6) are clear |
| 4 | Task 3 | One Story opened: show story points, acceptance criteria in description, label | S1 or S2 recommended |
| 5 | Task 4 | S2 opened showing 4 Sub-tasks (Edit HTML/CSS, Test locally, Deploy EC2, Verify/screenshot) | Show all subtasks in one view |
| 6 | Task 4 | S4 opened showing same 4 Sub-tasks | Show footer story structure |
| 7 | Task 5 | Backlog or Story details showing labels applied | Show 2+ Stories with `frontend`/`devops` labels |
| 8 | Task 6 | Sprint 1 before starting: Stories inside, Story Points total visible | Show ~3–5 story points |
| 9 | Task 6 | Active Sprint board after starting + Sprint Goal visible at top | Show board columns: To Do, In Progress, Done |
| 10 | Task 7 | Filter results for label = `frontend` | Show S1, S2, S3, S5, S6 filtered |
| 11 | Task 7 | Filter results for label = `devops` | Show S4 filtered |
| 12 | Task 8 | Burndown Chart page for Sprint 1 | Link visible in Jira Insights/Reports |

---

## Phase 2: Assignment 3 — 5-Day Mini-Sprint (Active Work)
**Duration:** 5 days (Day 1–Day 5) + 1 day for demo/retro  
**Output:** 17 screenshots + 1 demo video + 5 Daily Scrum comments + 1 retro comment

### Day 1: Implement Footer

**Goal:** Build and deploy static footer with version text.

**Work Steps:**
1. Create or update footer story in Jira with 5 Sub-tasks (Day 1–5)
2. Move into Sprint 1, start Sprint
3. On feature branch: add footer HTML/CSS with text: `Pravin Mishra Portfolio v1.0 — Deployed on <DD Mon YYYY> — By Silas Nyarko`
4. Commit and push
5. Deploy to public EC2 URL
6. Post Daily Scrum comment in Jira story

**Screenshots to Capture:**
| # | What | Details |
|---|------|---------|
| 3 | Jira board | Day 1 sub-task status: Done |
| 4 | Terminal/GitHub | Git commit output showing commit hash and footer changes |
| 5 | Browser EC2 URL | Footer visible with full text, URL visible in address bar |
| 6 | Jira story comment | Daily Scrum: "Day 1 — Implemented static footer with version and date text. Committed and deployed to EC2." |

---

### Day 2: Make Deploy Date Dynamic

**Goal:** Replace hardcoded date with auto-generated date at deploy time.

**Work Steps:**
1. Update footer to use deployment timestamp (TypeScript or shell script approach)
2. Update README.md with documentation on how date is generated
3. Commit and deploy
4. Post Daily Scrum comment

**Screenshots to Capture:**
| # | What | Details |
|---|------|---------|
| 7 | Code editor | Show footer.ts (or equivalent) with date generation logic |
| 8 | Browser EC2 URL | Footer shows current date dynamically |
| 9 | README.md snippet | Scroll to footer section showing "How It Works" documentation |
| 10 | Jira story comment | Daily Scrum: "Day 2 — Made deploy date dynamic using TypeScript. Updated README with implementation details." |

---

### Day 3: Polish & Validate Responsiveness

**Goal:** Improve footer styling, spacing, contrast. Test on desktop and mobile.

**Work Steps:**
1. Update style.css: improve padding, contrast, font size
2. Deploy to EC2
3. Test on desktop (DevTools browser width)
4. Test on mobile (DevTools mobile view or actual phone)
5. Post Daily Scrum comment

**Screenshots to Capture:**
| # | What | Details |
|---|------|---------|
| 11 | Browser desktop | EC2 footer on full desktop width, show improved styling |
| 12 | Browser mobile | DevTools mobile view (375px or similar), footer readable, responsive |
| 13 | Jira story comment | Daily Scrum: "Day 3 — Enhanced footer contrast, padding, and spacing. Validated on desktop and mobile viewports." |

---

### Day 4: Add DMI Website CTA

**Goal:** Replace homepage tagline with DMI Website call-to-action.

**Work Steps:**
1. Update index.html: replace tagline with "Start your DevOps Journey here" + link to https://dmi.pravinmishra.com
2. Ensure link is clickable
3. Deploy
4. Post Daily Scrum comment

**Screenshots to Capture:**
| # | What | Details |
|---|------|---------|
| 14 | Browser EC2 URL | Show hero/tagline area with DMI link, URL visible in address bar |

---

### Day 5: Demo, Retro, Burndown

**Goal:** Record demo video, post retrospective, capture Burndown Chart.

**Work Steps:**
1. Record 2–3 minute demo video showing footer + DMI CTA working on live EC2
2. Post retrospective comment in Jira story
3. Open Burndown Chart
4. Post final Daily Scrum comment

**Screenshots to Capture:**
| # | What | Details |
|---|------|---------|
| 15 | Jira Reports | Burndown Chart for Sprint 1 (even if mostly empty) |
| 16 | Jira story comment | Retrospective: "What went well: [1–2 sentences]. What to improve: [1–2 sentences]. DevOps pillar observed: [one of Transparency/Inspection/Adaptation]." |
| 17 | Browser EC2 URL | Final footer showing all elements: version, date, DMI link |

**Demo Video:**
- Record screen capture of: loading EC2 URL → scrolling to footer → clicking DMI link → showing responsive design
- Upload to unlisted YouTube or Google Drive
- Paste URL in assignment file: "#### Demo Video URL"

---

## Phase 3: Assignment 4 — Gotto Job Backlog Refinement (90-min Exercise)
**Duration:** ~2 hours  
**Output:** 14 screenshots + text notes

### Prerequisites (Must be in Jira already)
- Gotto Job template project created (if not, create it first)
- Understand the template user stories

### Task Sequence

**Task 1: Role Selection (5 min)**
- Choose: Team Mode or Solo Mode
- Document roles:
  - **PO (Product Owner):** Which stories you prioritized and why
  - **SM (Scrum Master):** How you ensured the process (ceremonies, timeboxing, etc.)
  - **Dev Lead:** What you built (UI features)
  - **DevOps Lead:** How you shipped it (deployment approach)

**Screenshot & Notes:**
| # | What | Details |
|---|------|---------|
| 1 | Jira project creation | Show project name: "Gotto Job – Silas Nyarko" (Solo Mode) |
| Notes | Role documentation | Write ~1 line per role (PO, SM, Dev, DevOps) |

---

**Task 2: Create Team-Managed Scrum Project (5 min)**

**Screenshot:**
| # | What | Details |
|---|------|---------|
| 2 | Project created page | Show project name and key |

---

**Task 3: Create Epic (5 min)**

**Screenshot:**
| # | What | Details |
|---|------|---------|
| 3 | Backlog | Epic panel enabled, Epic visible: "Improve Gotto Job UI discoverability & trust" |

---

**Task 4: Seed Backlog with 6–8 Stories (15 min)**

**Stories to Create:**
1. **Improve hero section headline clarity** (2 pts) — Make value proposition obvious
2. **Add trust badges/testimonials section** (3 pts) — Build credibility
3. **Improve CTA button visibility** (1 pt) — Make primary action stand out
4. **Add FAQ section** (2 pts) — Answer common questions
5. **Mobile-responsive header** (2 pts) — Ensure header works on all devices
6. **Add feature highlights** (1 pt) — Show key features in hero
7. **Improve form accessibility** (2 pts) — Label, contrast, keyboard nav
8. **Dark mode toggle** (3 pts) — Optional: nice-to-have

**Screenshots:**
| # | What | Details |
|---|------|---------|
| 4 | Backlog | Show Epic + all 6–8 Stories under it, ranked by value |
| 5 | One Story opened | Show story points (1, 2, or 3), acceptance criteria filled in |

---

**Task 5: Planning Poker — Estimate & Justify (15 min)**

**For each story, write 1–2 lines explaining the estimate:**

Example notes:
```
S1 (Headline clarity): 2 pts — Requires copy rewrite + design alignment; moderate complexity
S2 (Trust badges): 3 pts — Needs testimonial content + styling; higher design effort
S3 (CTA button): 1 pt — Simple color/size change, no backend work
S4 (FAQ): 2 pts — Content heavy but straightforward layout
S5 (Mobile header): 2 pts — Testing across devices adds complexity
S6 (Feature highlights): 1 pt — Copy + basic grid layout
S7 (Form access): 2 pts — ARIA labels + keyboard nav, needs testing
S8 (Dark mode): 3 pts — CSS variables + localStorage, more complex
```

**Screenshot & Notes:**
| # | What | Details |
|---|------|---------|
| 6 | Backlog or Stories | Show story points visible (1, 2, or 3) |
| Notes | Planning Poker reasoning | 1–2 lines per story explaining the estimate |

---

**Task 6: Sprint Planning — Create Sprint 1 (10 min)**

**Select 3–4 Stories totaling ~3–6 points. Example:**
- S1 (Headline): 2 pts
- S3 (CTA button): 1 pt
- S6 (Feature highlights): 1 pt
- **Total: 4 pts**

**Add Sub-tasks to each:**
- Build
- Verify
- Deploy
- Screenshot

**Set Sprint Goal:** "Improve Gotto Job homepage discoverability and trust signals"

**Screenshots:**
| # | What | Details |
|---|------|---------|
| 7 | Sprint 1 before starting | Show 3–4 Stories selected, total story points visible |
| 8 | One Story opened | Show Build, Verify, Deploy, Screenshot sub-tasks |

---

**Task 7: Burndown Chart (2 min)**

**Screenshot:**
| # | What | Details |
|---|------|---------|
| 9 | Reports → Burndown Chart | Show Burndown Chart page for Sprint 1 (OK if empty) |

---

**Task 8: Ship One Increment (30 min)**

**Pick one story (e.g., S3: CTA Button) and:**
1. Update the Gotto Job template HTML: change button color to vibrant, add hover effect
2. Commit to Git
3. Deploy to EC2 or public URL
4. Move Story + Sub-tasks to Done in Jira
5. Post verification

**Screenshots:**
| # | What | Details |
|---|------|---------|
| 10 | Jira board | Story moved to Done column |
| 11 | Terminal | Git commit output showing the button style changes |
| 12 | Browser live URL | Show Gotto Job page with improved CTA button, URL visible |

---

**Task 9: Retrospective (5 min)**

**Template:**
```
What went well: [1–2 sentences about the backlog refinement or execution]
What to improve: [1–2 sentences about process or estimation]
Scrum pillar observed: [Transparency / Inspection / Adaptation]
Scrum value demonstrated: [Openness / Focus / Commitment / Courage / Respect]
```

**Example:**
```
What went well: Clear prioritization by value; stories were well-defined with acceptance criteria.
What to improve: Planning poker took longer than expected; could have been more concise.
Scrum pillar: Transparency — made priorities visible to the team.
Scrum value: Commitment — delivered one complete story on time.
```

**Screenshot:**
| # | What | Details |
|---|------|---------|
| 13 | Jira story comment | Retro comment visible |

---

**Task 10: LinkedIn Post**

**Screenshot & URL:**
| # | What | Details |
|---|------|---------|
| 14 | Published LinkedIn post | Show post content, live URL, burndown/board/feature image |

---

## Capture Tools & Tips

### Screenshots
- **Jira:** Use Chrome DevTools (F12) → Device toolbar to get clean, consistent screenshots
- **Browser:** Full-page screenshots with URL visible — use built-in tools or Lightshot
- **Terminal:** Use `git log --oneline` to show recent commits; pipe to screenshot
- **Accessibility:** Ensure full name "Silas Nyarko" visible in at least 5+ key screenshots

### Demo Video (Assignment 3, Day 5)
- **Duration:** 2–3 minutes
- **Content:**
  1. Load EC2 URL (0–10 sec)
  2. Scroll to footer, show version + date (10–20 sec)
  3. Show responsive footer on mobile view (20–30 sec)
  4. Click DMI Website link (30–40 sec)
  5. Brief narration: "Today I shipped a dynamic footer and integrated the DMI call-to-action. The footer shows the deployment date in real time."
- **Tools:**
  - OBS Studio (free, professional)
  - ScreenFlow (Mac)
  - ShareX (Windows, free)
  - Loom (browser, easiest)

---

## Timeline

| Phase | Assignment | Estimated Time | Start | End |
|-------|------------|-----------------|-------|-----|
| 1 | Assignment 2 (Foundation Jira setup) | 1–2 hours | Day 1 | Day 1 |
| 2 | Assignment 3 (5-day sprint) | Day 1–5 (+ Day 6 for demo/retro) | Day 1 | Day 6 |
| 3 | Assignment 4 (90-min Gotto Job) | ~2 hours | Day 6 or 7 | Day 6 or 7 |
| Final | Compile all evidence, create markdown files | 30 min | Day 7 | Day 7 |

---

## Submission Checklist

### Assignment 2
- [ ] 12 screenshots added in correct order
- [ ] Full name visible in 5+ screenshots
- [ ] No sensitive data exposed
- [ ] All placeholders replaced with actual screenshots

### Assignment 3
- [ ] 17 screenshots + 1 demo video URL
- [ ] LinkedIn Post URL (✅ already filled)
- [ ] 5 Daily Scrum comments posted in Jira
- [ ] 1 retrospective comment posted
- [ ] Full name visible in 5+ screenshots
- [ ] No sensitive data exposed

### Assignment 4
- [ ] 14 screenshots
- [ ] LinkedIn Post URL (✅ already filled)
- [ ] Role documentation (4 lines)
- [ ] Planning Poker notes (6–8 lines)
- [ ] 1 retrospective comment posted
- [ ] Full name visible in 5+ screenshots
- [ ] No sensitive data exposed

---

## Pro Tips

1. **Batch capture:** Do all Assignment 2 Jira screenshots in one session (they're all static)
2. **Daily Scrum comments:** Post them daily during the 5-day sprint; don't wait until the end
3. **Resize browser:** Capture at consistent widths (desktop: 1280px, mobile: 375px)
4. **Practice demo:** Record the demo video 2–3 times before final submission
5. **Cross-check:** Before submitting, verify each assignment file is completely filled (no "Add your..." placeholders)

---

**Next Steps:**
1. Start with Assignment 2 (Jira screenshots) — fastest, no dependencies
2. Proceed with Assignment 3 (5-day sprint) — real work, follow daily cadence
3. Finish with Assignment 4 (Gotto Job) — can be done anytime, most flexible

Good luck! 🚀
