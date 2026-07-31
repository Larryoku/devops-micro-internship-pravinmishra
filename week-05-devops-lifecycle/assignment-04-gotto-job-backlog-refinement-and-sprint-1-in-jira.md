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

![alt text](<Ass 04 04 Screenshot 1.png>)

### Notes

Write one line for each role: PO (what you prioritized), SM (how you ensured process), Dev Lead (what you built), DevOps Lead (how you shipped).

Mode Chosen: Solo Mode

Product Owner (PO): I prioritized user-facing UI improvements in the backlog to maximize discoverability and immediate user trust.

Scrum Master (SM): I organized the Scrum board, set up Sprint 1, enforced time-boxing, and drafted the sprint goal.

Dev Lead: I executed the code-level UI change, updated the frontend layout, and verified the changes locally.

DevOps Lead: I managed the Git workflow, committed the code, and deployed the updated increment to the live environment.

# Task 2 — Create the Jira Project (Team-managed → Scrum)

## Goal

Create a Team-managed Scrum project named `Gotto Job – Team <#>` (Team Mode) or `Gotto Job – <YourName>` (Solo Mode).

### Evidence

#### Screenshot 2 — Project created page showing the project name and key

![alt text](<Ass 04 04 Screenshot 2.png>)

# Task 3 — Create the Epic

## Goal

Create the Epic `Improve Gotto Job UI discoverability & trust` to group the UI improvement initiative.

### Evidence

#### Screenshot 3 — Backlog showing the Epic panel with the Epic visible

![alt text](<Ass 04 04 Screenshot 3.png>)

# Task 4 — Seed the Product Backlog (6–8 Stories + Fibonacci Points + Ranking)

## Goal

Create at least six Stories under the Epic, estimate each with 1, 2, or 3 story points, and rank them by value.

### Evidence

#### Screenshot 4 — Backlog showing the Epic and at least six Stories under it

![alt text](<Ass 04 04 Screenshot 4.png>)

#### Screenshot 5 — One Story opened showing its Story Points and acceptance criteria filled in

![alt text](<Ass 04 04 Screenshot 5.png>)

# Task 5 — Planning Poker (Estimate + Debate Notes)

## Goal

Confirm the Story Points (1, 2, or 3) for each Story and record brief reasoning for each estimate.

### Evidence

#### Screenshot 6 — Backlog showing Story Points visible, or two or three Stories opened showing their points

![alt text](<Ass 04 04 Screenshot 6.png>)

### Notes

For each story, explain in one or two lines why it is a 1, 2, or 3 (mention any debate, even in Solo Mode).

Story 1: Update main CTA button text to "Explore Jobs Now" — Point 1

Justification: Low complexity and minimal effort since it only requires updating a single text string in the header component and verifying rendering locally.

Debate: Brief consideration was given to rating it a 2 due to running local verification tests, but it was kept at 1 because the codebase change itself is trivial.

Story 2: Add trust badge banner under main navigation — Point 3

Justification: High effort involving non-trivial UI layout adjustments, asset sourcing/styling, and ensuring responsive design across desktop and mobile screens.

Debate: Debated rating it a 2 for simplicity, but opted for 3 to account for potential styling conflicts with existing header navigation rules.

Story 3: Increase contrast and sizing of search bar placeholder — Point 2

Justification: Moderate effort requiring specific CSS/accessibility adjustments for contrast ratios and placeholder font sizing without breaking component layout.

Debate: Considered a 1 since it’s CSS-only, but escalated to 2 to allow buffer time for visual testing across different browsers.

# Task 6 — Sprint Planning: Create Sprint 1 + Sprint Goal + Scope

## Goal

Create Sprint 1, move three or four Stories into it (approximately 3–6 points), set the Sprint Goal, and break each selected Story into Build, Verify, Deploy, and Screenshot Sub-tasks.

### Evidence

#### Screenshot 7 — Sprint 1 with the selected Stories inside it

![alt text](<Ass 04 04 Screenshot 7.png>)

#### Screenshot 8 — One Story showing the Sub-tasks created

![alt text](<Ass 04 04 Screenshot 8.png>)

# Task 7 — Reports: Open Burndown Chart

## Goal

Open the Burndown Chart and confirm it exists for Sprint 1. It is acceptable if the chart is not yet populated.

### Evidence

#### Screenshot 9 — Burndown Chart page opened, even if empty

![alt text](<Ass 04 04 Screenshot 9.png>)

# Task 8 — Ship One Small Increment (Build + Deploy + Proof)

## Goal

Implement one small UI-only Story from Sprint 1, commit it, deploy it live, and move the Story and its Sub-tasks to Done in Jira.

### Evidence

#### Screenshot 10 — Jira board showing the Story moved to Done

![alt text](<Ass 04 04 Screenshot 10.png>)

#### Screenshot 11 — Git commit output

![alt text](<Ass 04 04 Screenshot 11.png>)

#### Screenshot 12 — Live URL in the browser showing the UI change, with the URL visible

![alt text](<Ass 04 04 Screenshot 12.png>)

# Task 9 — Retro Notes (Scrum Pillar + Value)

## Goal

Add a retro comment covering what went well, what to improve, one Scrum pillar observed (Transparency, Inspection, or Adaptation), and one Scrum value (Openness, Focus, Commitment, Courage, or Respect).

### Evidence

#### Screenshot 13 — Jira retro comment visible

![alt text](<Ass 04 04 Screenshot 13.png>)

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about what you delivered, including your live URL, three to five lines on what you did and learned, and one screenshot (Burndown Chart, Sprint board, or the live UI change).

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

https://www.linkedin.com/posts/silas-nyarko_excited-to-share-my-latest-progress-with-share-7488994823899750400-1Ris/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAC77mYABXwQj5VAsAS-zzzdbpmvsIZLeP7U

#### Screenshot 14 — Published LinkedIn post

![alt text](<Linkedin screenshot Ass 04.png>)

# Submission Instructions

- Add all required screenshots in your submission
- Full name must be visible in required screenshots
- Do not expose sensitive information (keys, passwords, account IDs)

---

# Completion Checklist

- [X] Task 1: Team Mode or Solo Mode selected and all four roles documented (Screenshot 1 & Notes)
- [X] Task 2: Team-managed Scrum project created with the required name (Screenshot 2)
- [X] Task 3: UI improvement Epic created (Screenshot 3)
- [X] Task 4: 6–8 Stories added under the Epic and ranked by value (Screenshots 4 & 5)
- [X] Task 5: Story Points set (1, 2, or 3) with reasoning recorded (Screenshot 6 & Notes)
- [X] Task 6: Sprint 1 created with Sprint Goal, 3–4 Stories, and Sub-tasks (Screenshots 7 & 8)
- [X] Task 7: Burndown Chart opened (Screenshot 9)
- [X] Task 8: One UI-only increment implemented, committed, deployed, and verified (Screenshots 10–12)
- [X] Task 9: Retro comment with one Scrum pillar and one Scrum value (Screenshot 13)
- [X] LinkedIn post published and URL submitted (Screenshot 14)
- [X] Full Name visible in required screenshots
- [X] No sensitive data exposed

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
