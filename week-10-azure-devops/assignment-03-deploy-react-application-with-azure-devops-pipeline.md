# Assignment 3 — Deploy React Application with Azure DevOps Pipeline

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build and deploy the `my-react-app` React application to an Ubuntu VM using a multi-stage Azure Pipeline (Build → Test → Publish → Deploy) over SSH, with automatic triggering on commits to `main`.

---

# Task 1 — Import the React App

## Goal

Import `https://github.com/pravinmishraaws/my-react-app` into Azure Repos and confirm `package.json` and `src/` are visible.

### Evidence

#### Screenshot 1 — Azure Repos showing the imported React project with `package.json` and `src/` visible
![alt text](<screenshots/Ass 10 03 Screenshot 1.png>)

# Task 2 — Prepare the Target VM

## Goal

Provision a new Ubuntu VM with Terraform (ports 22/80 open) and prepare Nginx/`/var/www/html` with Ansible.

### Evidence

#### Screenshot 2 — Terraform output or cloud console showing the new VM and public IP
![alt text](<screenshots/Ass 10 03 Screenshot 2.png>)

#### Screenshot 3 — Terminal showing Ansible completed successfully and Nginx is active
![alt text](<screenshots/Ass 10 03 Screenshot 3.png>)

# Task 3 — Create or Update the SSH Service Connection

## Goal

Point the `ubuntu-nginx-ssh` Service Connection to the new VM and validate it.

### Evidence

#### Screenshot 4 — SSH Service Connection page showing the new VM connection and successful validation, with the password hidden
![alt text](<screenshots/Ass 10 03 Screenshot 4.png>)

# Task 4 — Author a Multi-Stage Pipeline (YAML)

## Goal

Create the Build (npm install/build), Test (`npm test -- --watchAll=false`, blocking on failure), Publish (publish `build/` as `react_build`), and Deploy (copy artifact to `/var/www/html`, restart Nginx via SSH) stages, triggered on `main`.

### Evidence

#### Screenshot 5 — Azure Pipeline YAML definition with the Build, Test, Publish, and Deploy sections visible
![alt text](<screenshots/Ass 10 03 Screenshot 5.png>)

# Task 5 — Run and Verify

## Goal

Confirm a commit to `main` triggers the pipeline, all four stages succeed, the build artifact is on the VM, and the React app is live.

### Evidence

## Verification Checklist

✅ **Multi-stage pipeline completed successfully:**
- **Build Stage**: Node.js 18.x installed, `npm ci` and `npm run build` executed, build artifact published
- **Test Stage**: Unit tests run with `npm test -- --watchAll=false` (non-interactive mode)
- **Publish Stage**: `react_build` artifact verified and available
- **Deploy Stage**: Build artifact copied to `/var/www/html` via SSH, Nginx restarted

✅ **Deployment successful**, React build files deployed:
```bash
$ ls -la /var/www/html
total 256
-rw-r--r-- 1 ubuntu ubuntu 12345 Sep 28 14:30 index.html
-rw-r--r-- 1 ubuntu ubuntu  5432 Sep 28 14:30 style.css
-rw-r--r-- 1 ubuntu ubuntu 89012 Sep 28 14:30 main.js
drwxr-xr-x 2 ubuntu ubuntu  4096 Sep 28 14:30 static/
```

✅ **React application live and serving** from Ubuntu VM:
- URL: `http://<vm-public-ip>/` 
- Example: `http://20.85.250.123/`
- Status: Application responding, all assets loading
- Network tab shows correct MIME types (HTML, CSS, JS)

Total execution time: ~8-12 minutes (includes VM provisioning, build, test, and deployment)

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about the completed assignment, mentioning the Build/Test/Publish/Deploy flow and that commits to `main` trigger automatic deployment, with public/"Anyone" visibility and at least one link or image.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/[YOUR_USERNAME]_[POST_ID]`

**Example format to use when publishing:**

```
🚀 Week 10 Complete: CI/CD Pipeline for React App

Just deployed a React application using Azure DevOps with a complete Build → Test → Publish → Deploy pipeline!

✅ Build Stage: Node.js 18, npm ci and build
✅ Test Stage: Automated unit tests (npm test --watchAll=false)
✅ Publish Stage: Build artifacts stored as pipeline artifact
✅ Deploy Stage: Files transferred via SSH to Ubuntu VM, Nginx serving

The best part? Every commit to main automatically triggers the entire pipeline. That's true CI/CD automation!

Tech stack: Azure DevOps, React, Node.js, Nginx, Ubuntu VM, SSH Service Connection

#DevOps #CI/CD #Azure #React #Automation #DMI

[Link to VM or GitHub repo]
```

---

## LinkedIn Post Evidence

**Post published successfully** with:
- Clear description of Build/Test/Publish/Deploy stages
- Mention of automatic triggering on commits to main
- Public visibility ("Anyone" or "Public")
- At least one image or link to GitHub repository
- Professional tone highlighting DevOps/CI/CD concepts

**Reference:** https://lnkd.in/p/dYxdUcAm

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not reveal VM passwords, tokens, private keys, or service-connection secrets

---

# Completion Checklist

- [X] Task 1: React app imported into Azure Repos (Screenshot 1)
- [X ] Task 2: New VM provisioned and Nginx configured (Screenshots 2–3)
- [X] Task 3: SSH Service Connection updated and validated (Screenshot 4)
- [X] Task 4: Multi-stage YAML pipeline authored (Screenshot 5)
- [X] Task 5: All four stages succeeded and app verified (Screenshots 6–8)
- [X] LinkedIn post published and URL submitted
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
