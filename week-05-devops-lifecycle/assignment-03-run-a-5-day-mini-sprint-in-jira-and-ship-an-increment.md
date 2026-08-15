# Assignment 3 — Run a 5-Day Mini-Sprint in Jira and Ship an Increment

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will run a five-day mini-Sprint in Jira and ship a small but real footer improvement to your portfolio website running on EC2. You will track the work from Sprint Goal and Story through daily Sub-tasks, Daily Scrum comments, Git commits, repeated deployments, verification, a retrospective, the Burndown Chart, and a mandatory LinkedIn delivery story.

---

# Task 1 — Set Up and Start Sprint 1

## Goal

Create the footer Story (`Add footer with version and deploy date`, 1 point, `frontend` label) with its five required Sub-tasks (Day 1–Day 5), move it into Sprint 1, set the required Sprint Goal, and start the Sprint.

### Evidence

#### Screenshot 1 — Sprint 1 created with the Story inside it

![Screenshot 1 — Sprint 1 created with Story](./images/assignment-03-screenshot-01.png)

---

#### Screenshot 2 — Active Sprint board showing the Sprint Goal

![Screenshot 2 — Active Sprint board with Sprint Goal](./images/assignment-03-screenshot-02.png)

---

# Task 2 — Day 1: Implement the Footer, Commit, and Deploy

## Goal

Add the required footer text (`Pravin Mishra Portfolio v1.0 — Deployed on <DD Mon YYYY> — By <Student Name>`) to the site on a `feature/footer-v1` branch, commit it, and deploy it to the public EC2 URL.

### Evidence

#### Screenshot 3 — Jira board showing the Day 1 Sub-task in Done

![Screenshot 3 — Day 1 Sub-task Done](./images/assignment-03-screenshot-03.png)

---

#### Screenshot 4 — Successful Git commit output

![Screenshot 4 — Git commit output](./images/assignment-03-screenshot-04.png)

---

#### Screenshot 5 — EC2 browser view showing the complete footer text, with the URL visible

![Screenshot 5 — EC2 footer deployed](./images/assignment-03-screenshot-05.png)

---

#### Screenshot 6 — Jira Story comment showing the Day 1 Daily Scrum update

![Screenshot 6 — Day 1 Daily Scrum comment](./images/assignment-03-screenshot-06.png)

**Day 1 Daily Scrum Comment:**
```
Day 1 — ✅ Implemented static footer with version and date text. Created feature/footer-v1 branch, added footer HTML with required text format: "Pravin Mishra Portfolio v1.0 — Deployed on 15 Aug 2026 — By Silas Nyarko". Committed to Git and deployed to EC2. Footer displays correctly at bottom of page. No blockers.
```

---

# Task 3 — Day 2: Make the Deploy Date Dynamic and Document It

## Goal

Update the footer so the deployment date is generated automatically (or updated consistently at deploy time), document the approach in `README.md`, commit, and redeploy.

### Evidence

#### Screenshot 7 — Code editor showing the footer and date logic or deployment-time template snippet

![Screenshot 7 — Code editor with date logic](./images/assignment-03-screenshot-07.png)

---

#### Screenshot 8 — EC2 browser view showing the updated footer with the current date

![Screenshot 8 — EC2 footer with dynamic date](./images/assignment-03-screenshot-08.png)

---

#### Screenshot 9 — README snippet documenting the footer and date behavior

![Screenshot 9 — README footer documentation](./images/assignment-03-screenshot-09.png)

---

#### Screenshot 10 — Jira Story comment showing the Day 2 Daily Scrum update

![Screenshot 10 — Day 2 Daily Scrum comment](./images/assignment-03-screenshot-10.png)

**Day 2 Daily Scrum Comment:**
```
Day 2 — ✅ Made deploy date dynamic using TypeScript. Created footer.ts with formatDeploymentDate() function using Date API and string formatting. Compiled to footer.js. Updated README.md with "Footer & Dynamic Deployment Date" section explaining implementation. Redeployed to EC2 and verified date updates to current date. Documentation complete.
```

---

# Task 4 — Day 3: Polish the Footer and Validate Accessibility

## Goal

Improve the footer's spacing, contrast, and readability, then validate it at both desktop and mobile viewport widths.

### Evidence

#### Screenshot 11 — Desktop EC2 view showing the polished footer

![Screenshot 11 — Polished footer desktop view](./images/assignment-03-screenshot-11.png)

---

#### Screenshot 12 — Mobile responsive view showing the footer remains readable

![Screenshot 12 — Footer mobile responsive view](./images/assignment-03-screenshot-12.png)

---

#### Screenshot 13 — Jira Story comment showing the Day 3 Daily Scrum update

![Screenshot 13 — Day 3 Daily Scrum comment](./images/assignment-03-screenshot-13.png)

**Day 3 Daily Scrum Comment:**
```
Day 3 — ✅ Polished footer styling for improved accessibility and UX. Updated style.css: increased padding (20px), improved contrast (dark bg/white text), optimized font size (14px) and line-height. Tested on desktop (1280px) and mobile (375px width) viewports using DevTools. Footer responsive and readable on all screen sizes. CSS validated.
```

---

# Task 5 — Day 4: Change the Homepage Tagline / Call-to-Action

## Goal

Replace the existing homepage tagline with the required DMI Website call-to-action link and deploy it to EC2.

### Evidence

#### Screenshot 14 — EC2 browser view showing "Start your DevOps Journey here" and the clickable "Visit the DMI Website" link

![Screenshot 14 — DMI Website CTA deployed](./images/assignment-03-screenshot-14.png)

**Day 4 Daily Scrum Comment:**
```
Day 4 — ✅ Updated homepage with DMI Website call-to-action. Replaced hero tagline with "Start your DevOps Journey here" and added clickable link to https://dmi.pravinmishra.com. Updated index.html and style.css for link styling (blue color, hover effect). Committed to feature/footer-v1. Deployed to EC2 and verified link is clickable and functional. CTA live on production.
```

---

# Task 6 — Day 5: Demo, Retrospective, and Burndown

## Goal

Record a two-to-three-minute demo video of the shipped footer, add a retrospective comment (what went well, what to improve, one DevOps pillar observed), post the Day 5 Daily Scrum update, and open the Burndown Chart.

### Evidence

#### Screenshot 15 — Burndown Chart for Sprint 1

![Screenshot 15 — Burndown Chart Sprint 1](./images/assignment-03-screenshot-15.png)

---

#### Screenshot 16 — Jira retrospective comment

![Screenshot 16 — Retrospective comment](./images/assignment-03-screenshot-16.png)

**Day 5 Daily Scrum Comment:**
```
Day 5 — ✅ Sprint complete. Recorded 2-minute demo video showing footer with dynamic date and DMI CTA link on live EC2 instance. Posted retrospective comment. Reviewed Sprint 1 Burndown Chart showing all 5 sub-tasks completed. All stories moved to Done. Sprint Goal achieved: shipped footer increment with version, dynamic date, and DMI call-to-action.
```

**Retrospective Comment:**
```
**What went well:** Clear sprint goal and well-defined daily sub-tasks made progress tracking straightforward. TypeScript implementation for dynamic dates was well-structured. Responsive design approach ensured footer worked across all viewport sizes without rework.

**What to improve:** Could have tested responsive design earlier (Day 1-2) instead of Day 3. Planning the dynamic date feature on Day 1 would have reduced complexity. Better communication of acceptance criteria upfront would help clarify testing scope.

**DevOps pillar observed:** Transparency — Daily standup comments in Jira provided clear visibility into progress status. Each team member knew exact deployment status, completion percentage, and any blockers at all times.

**Scrum value demonstrated:** Commitment — Delivered all five daily sub-tasks on schedule and shipped the complete footer increment despite design refinements and testing across multiple viewports.
```

---

#### Screenshot 17 — Final EC2 browser view showing the complete footer requirement

![Screenshot 17 — Final EC2 footer view](./images/assignment-03-screenshot-17.png)

---

#### Demo Video URL

Paste your unlisted YouTube or accessible Google Drive demo-video link here:

`https://youtu.be/mYfxX93Kx10`

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about your five-day mini-Sprint, including your GitHub repository URL, your public EC2 live URL, three to five lines on what you shipped and learned, and one proof image (Burndown Chart, active Sprint board, or the EC2 footer).

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/silas-nyarko_devops-agile-jira-share-7494127317221376001-em9P/?utm_source=share&utm_medium=member_desktop&rcm=ACoAAC77mYABXwQj5VAsAS-zzzdbpmvsIZLeP7U`

---

#### LinkedIn Screenshot 1 — Published LinkedIn post showing the post content and at least one required link or proof image

![LinkedIn Screenshot 1 — Published post](./images/assignment-03-linkedin-screenshot-01.png)

---

# Submission Instructions

- Add all 17 assignment screenshots in the specified order
- Add LinkedIn Screenshot 1
- Full name must be visible in required screenshots
- Include your two-to-three-minute demo-video URL
- Include Daily Scrum comments for Days 1–5 and the retrospective comment
- Include your GitHub repository URL and public EC2 live URL
- Do not expose sensitive information (private keys, passwords, tokens, account IDs)

---

# Completion Checklist

- [ ] Task 1: Sprint 1 started with the required Sprint Goal (Screenshots 1 & 2)
- [ ] Task 2: Day 1 footer implemented, committed, and deployed (Screenshots 3–6)
- [ ] Task 3: Day 2 deploy date made dynamic and documented (Screenshots 7–10)
- [ ] Task 4: Day 3 footer polished and validated on desktop and mobile (Screenshots 11–13)
- [ ] Task 5: Day 4 DMI Website call-to-action deployed and clickable (Screenshot 14)
- [ ] Task 6: Day 5 demo, retrospective, and Burndown evidence completed (Screenshots 15–17, video URL)
- [ ] Daily Scrum comments posted for Days 1–5
- [ ] LinkedIn post published with the GitHub URL, EC2 URL, required delivery details, and proof image
- [ ] LinkedIn Post URL and LinkedIn Screenshot 1 included
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
