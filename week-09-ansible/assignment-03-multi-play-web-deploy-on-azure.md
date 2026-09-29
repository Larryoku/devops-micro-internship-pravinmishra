# Assignment 3 — Multi-Play Web Deploy on Azure

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will create one Ansible playbook (`site.yml`) with three plays — install Nginx, deploy a static website with the `copy` module, and verify the deployment from the controller — against the `[web]` group from your existing inventory.

---

# Task 1 — Set Up Folder Layout

## Goal

Create the `static-web` project directory with `inventory.ini`, `site.yml`, a `files/` subdirectory, and `README.md`.

### Evidence

#### Screenshot 1 — Terminal or editor showing the complete `static-web` folder layout

Add your screenshot here.

---

# Task 2 — Get the Content

## Goal

Stage `index.html` from `https://github.com/pravinmishraaws/Azure-Static-Website` locally under `static-web/files/`.

### Evidence

#### Screenshot 2 — Editor or terminal showing `files/index.html` staged inside the `static-web` project

Add your screenshot here.

---

# Task 3 — Create the Multi-Play Playbook: site.yml

## Goal

Write `site.yml` with three plays: Play 1 (install/start Nginx on `web`), Play 2 (`copy` `files/index.html` to `/var/www/html/index.html` with owner `www-data`/mode `0644`, notifying an Nginx reload handler), and Play 3 (verify every web host with the `uri` module from `localhost`, asserting HTTP 200).

### Evidence

#### Screenshot 3 — Editor showing the three plays in `site.yml`

Add your screenshot here.

---

#### Screenshot 4 — Editor showing the copy task, file ownership/mode, handler, uri task, and HTTP 200 assertion

Add your screenshot here.

---

# Task 4 — Run the Playbook

## Goal

Run `ansible-playbook -i inventory.ini site.yml` and confirm all plays complete with no failures.

### Evidence

#### Screenshot 5 — Terminal showing the `ansible-playbook` run and final recap with OK/changed results and no failures

Add your screenshot here.

---

#### Screenshot 6 — Terminal showing the successful localhost URI verification results

Add your screenshot here.

---

# Task 5 — Manual Verification

## Goal

Confirm the deployed static website is reachable directly from a web-server public IP via `curl` and a browser.

### Evidence

#### Screenshot 7 — Browser showing the static website loaded from a web-server public IP

Add your screenshot here.

---

### Notes

**Issue Faced & Resolution:**

The initial playbook failed because the `copy` module couldn't find `files/index.html` due to missing local file. The file needed to be staged locally before the playbook run. Fixed by downloading the file from the GitHub repository using `curl` and placing it in the `files/` directory structure.

**Key Learning:**

The handler-based reload approach taught me the importance of idempotency. If the file hasn't changed, Nginx doesn't reload unnecessarily, reducing service interruptions and connection resets. This is critical in production environments where every second of downtime impacts users.

**Why Installation & Deployment Were Split:**

Splitting the tasks into separate plays provides several advantages:
1. **Separation of Concerns**: Play 1 handles infrastructure setup (Nginx installation), while Play 2 handles content deployment. This makes the playbook easier to maintain and modify independently.
2. **Retry & Rollback**: If content deployment fails (e.g., corrupted file), we can re-run Play 2 without reinstalling Nginx.
3. **Readability**: Three distinct plays are easier to understand than 10+ sequential tasks in one play.
4. **Flexibility**: Allows running only Play 1 for fresh server prep, or only Play 2 for content updates.

**Benefit of `copy` Over `git clone`:**

Using the `copy` module provides several advantages:
- **No Git Dependency**: The web servers don't need Git installed, reducing attack surface and dependencies.
- **Atomic Updates**: The file is copied atomically (no partial reads/writes).
- **Ownership Control**: Easily set correct file ownership and permissions (www-data:www-data, mode 0644) without post-clone cleanup.
- **Version Control**: By managing content in `files/`, you can use Git to version-control the exact content deployed.
- **Simple Content**: For static HTML, copying is simpler and faster than cloning an entire repository.

In contrast, `git clone` would require installing Git, managing SSH keys, and handling repository cleanup—unnecessary overhead for a static file.

---

# Submission Instructions

- Add all required screenshots in your submission
- IP addresses in `inventory.ini` may be redacted
- Do not expose SSH private keys

---

# Completion Checklist

- [ ] Task 1: `static-web` project structure created (Screenshot 1)
- [ ] Task 2: `index.html` staged under `files/` (Screenshot 2)
- [ ] Task 3: Three-play `site.yml` written (Screenshots 3–4)
- [ ] Task 4: Playbook run successfully with no failures (Screenshots 5–6)
- [ ] Task 5: Site verified manually via browser (Screenshot 7)
- [ ] Reflection notes written (Notes)
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
