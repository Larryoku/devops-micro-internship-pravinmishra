# Assignment 4 — Gotto Job: Backlog Refinement & Sprint 1 in Jira

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this 90-minute, time-boxed exercise, you will act as a Scrum team — or run in Solo Mode, playing every role yourself — to turn the Gotto Job template into a value-ordered backlog, estimate the work in story points, plan Sprint 1, open the burndown chart, and ship one small UI-only increment (text, color, spacing, a label, or a CTA — no backend changes).

---

# Task 1 — Roles & Mode Setup (Team vs Solo)

## Goal

Choose Team Mode or Solo Mode, and document how each Scrum role (Product Owner, Scrum Master, Dev Lead, DevOps Lead) was handled.

### Evidence

#### Screenshot 1 — Jira "Create project" screen, or the project sidebar after creation

![Screenshot 1 — Jira project creation](./images/assignment-04-screenshot-01.png)

---

### Notes

Write one line for each role: PO (what you prioritized), SM (how you ensured process), Dev Lead (what you built), DevOps Lead (how you shipped).

**Role Documentation:**
- **Product Owner:** Prioritized backlog by value: headline clarity refresh (S1) and trust-building elements (S2) addressed first. CTA button visibility (S3) and feature highlights (S6) ranked as high-value, low-effort wins. Deferred dark mode (S8) as nice-to-have.
- **Scrum Master:** Facilitated 90-minute timebox strict adherence. Ran planning poker estimation discussion; resolved story point debates with data-driven reasoning. Kept team focused on Sprint Goal of "improve UI discoverability and trust." Blocked distractions and documented decisions.
- **Dev Lead:** Implemented three stories in Sprint 1: improved headline copy with value proposition (S1), added responsive CTA button with hover effects (S3), and created feature highlights grid layout (S6). All code passed HTML/CSS validation and browser testing.
- **DevOps Lead:** Deployed all Sprint 1 stories to live staging environment. Verified responsive design across desktop, tablet, and mobile viewports. Tested CTA button and links. Documented deployment steps and rollback procedures for each story.

---

# Task 2 — Create the Jira Project (Team-managed → Scrum)

## Goal

Create a Team-managed Scrum project named `Gotto Job – Team <#>` (Team Mode) or `Gotto Job – <YourName>` (Solo Mode).

### Evidence

#### Screenshot 2 — Project created page showing the project name and key

![Screenshot 2 — Project created](./images/assignment-04-screenshot-02.png)

---

# Task 3 — Create the Epic

## Goal

Create the Epic `Improve Gotto Job UI discoverability & trust` to group the UI improvement initiative.

### Evidence

#### Screenshot 3 — Backlog showing the Epic panel with the Epic visible

![Screenshot 3 — Epic panel in backlog](./images/assignment-04-screenshot-03.png)

---

# Task 4 — Seed the Product Backlog (6–8 Stories + Fibonacci Points + Ranking)

## Goal

Create at least six Stories under the Epic, estimate each with 1, 2, or 3 story points, and rank them by value.

### Evidence

#### Screenshot 4 — Backlog showing the Epic and at least six Stories under it

![Screenshot 4 — Epic with six Stories](./images/assignment-04-screenshot-04.png)

---

#### Screenshot 5 — One Story opened showing its Story Points and acceptance criteria filled in

![Screenshot 5 — Story points and criteria](./images/assignment-04-screenshot-05.png)

---

# Task 5 — Planning Poker (Estimate + Debate Notes)

## Goal

Confirm the Story Points (1, 2, or 3) for each Story and record brief reasoning for each estimate.

### Evidence

#### Screenshot 6 — Backlog showing Story Points visible, or two or three Stories opened showing their points

![Screenshot 6 — Story points visible](./images/assignment-04-screenshot-06.png)

---

### Notes

For each story, explain in one or two lines why it is a 1, 2, or 3 (mention any debate, even in Solo Mode).

**Planning Poker Reasoning:**
- **S1 (Headline clarity - 2 pts):** Requires copy rewrite and A/B testing considerations. Design alignment needed with brand guidelines. Moderate complexity; multiple revisions expected during QA.
- **S2 (Trust badges - 3 pts):** Needs testimonial content sourcing, image assets, and badge styling. Content creation is rate-limiting factor. High design and integration effort. Backend testimonial data not included.
- **S3 (CTA button - 1 pt):** Simple color, size, and hover state update to existing button. No backend changes. Can be implemented in <30 minutes. Low risk of scope creep. Dependencies: none.
- **S4 (FAQ section - 2 pts):** Content-heavy but straightforward accordion/collapse layout. Requires FAQ copy creation. HTML/CSS implementation straightforward. Testing: keyboard navigation and mobile interactions.
- **S5 (Mobile header - 2 pts):** Navigation responsive collapse and touch-friendly spacing require testing across devices (iOS Safari, Android Chrome). CSS media queries needed. Hamburger menu implementation.
- **S6 (Feature highlights - 1 pt):** Simple grid layout (3 columns → 1 column responsive). Copy + icons only. No backend. Minimal CSS changes. Can ship in one session.
- **S7 (Form accessibility - 2 pts):** ARIA labels, semantic HTML, keyboard navigation (Tab order), and WCAG contrast verification needed. Multiple test passes required across screen readers and browsers.
- **S8 (Dark mode - 3 pts):** CSS custom properties, localStorage persistence, theme toggle logic, testing across all pages. Highest complexity. Impacts entire site styling. Deferred to future sprint.

---

# Task 6 — Sprint Planning: Create Sprint 1 + Sprint Goal + Scope

## Goal

Create Sprint 1, move three or four Stories into it (approximately 3–6 points), set the Sprint Goal, and break each selected Story into Build, Verify, Deploy, and Screenshot Sub-tasks.

### Evidence

#### Screenshot 7 — Sprint 1 with the selected Stories inside it

![Screenshot 7 — Sprint 1 with Stories](./images/assignment-04-screenshot-07.png)

---

#### Screenshot 8 — One Story showing the Sub-tasks created

![Screenshot 8 — Story with Sub-tasks](./images/assignment-04-screenshot-08.png)

---

# Task 7 — Reports: Open Burndown Chart

## Goal

Open the Burndown Chart and confirm it exists for Sprint 1. It is acceptable if the chart is not yet populated.

### Evidence

#### Screenshot 9 — Burndown Chart page opened, even if empty

![Screenshot 9 — Burndown Chart](./images/assignment-04-screenshot-09.png)

---

# Task 8 — Ship One Small Increment (Build + Deploy + Proof)

## Goal

Implement one small UI-only Story from Sprint 1, commit it, deploy it live, and move the Story and its Sub-tasks to Done in Jira.

### Evidence

#### Screenshot 10 — Jira board showing the Story moved to Done

![Screenshot 10 — Story moved to Done](./images/assignment-04-screenshot-10.png)

---

#### Screenshot 11 — Git commit output

![Screenshot 11 — Git commit output](./images/assignment-04-screenshot-11.png)

---

#### Screenshot 12 — Live URL in the browser showing the UI change, with the URL visible

![Screenshot 12 — Live UI change deployed](./images/assignment-04-screenshot-12.png)

---

# Task 9 — Retro Notes (Scrum Pillar + Value)

## Goal

Add a retro comment covering what went well, what to improve, one Scrum pillar observed (Transparency, Inspection, or Adaptation), and one Scrum value (Openness, Focus, Commitment, Courage, or Respect).

### Evidence

#### Screenshot 13 — Jira retro comment visible

![Screenshot 13 — Retrospective comment](./images/assignment-04-screenshot-13.png)

---

# Task 10 — LinkedIn Post (Mandatory)

## Goal

Publish a LinkedIn post about what you delivered, including your live URL, three to five lines on what you did and learned, and one screenshot (Burndown Chart, Sprint board, or the live UI change).

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/silas-nyarko_devops-agile-jira-share-7494127317221376001-em9P/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAC77mYABXwQj5VAsAS-zzzdbpmvsIZLeP7U`

---

#### Screenshot 14 — Published LinkedIn post

![Screenshot 14 — LinkedIn post published](./images/assignment-04-screenshot-14.png)

---

# Submission Instructions

- Add all 14 required screenshots
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [ ] Task 1: Team Mode or Solo Mode selected and all four roles documented (Screenshot 1 & Notes)
- [ ] Task 2: Team-managed Scrum project created with the required name (Screenshot 2)
- [ ] Task 3: UI improvement Epic created (Screenshot 3)
- [ ] Task 4: 6–8 Stories added under the Epic and ranked by value (Screenshots 4 & 5)
- [ ] Task 5: Story Points set (1, 2, or 3) with reasoning recorded (Screenshot 6 & Notes)
- [ ] Task 6: Sprint 1 created with Sprint Goal, 3–4 Stories, and Sub-tasks (Screenshots 7 & 8)
- [ ] Task 7: Burndown Chart opened (Screenshot 9)
- [ ] Task 8: One UI-only increment implemented, committed, deployed, and verified (Screenshots 10–12)
- [ ] Task 9: Retro comment with one Scrum pillar and one Scrum value (Screenshot 13)
- [ ] Task 10: Mandatory LinkedIn post published with the live URL, backlog refinement, Sprint planning, one shipped increment, proof, and Screenshot 14
- [ ] Full Name visible in required screenshots
- [ ] No sensitive data exposed

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://dmi.pravinmishra.com?utm_source=github&utm_medium=readme  
- 🎓 University: https://university.pravinmishra.com?utm_source=github&utm_medium=readme  
- 💬 Discord Community: https://discord.pravinmishra.com?utm_source=github&utm_medium=readme  
- 📝 Blog: https://dmi.pravinmishra.com/blog?utm_source=github&utm_medium=readme  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
