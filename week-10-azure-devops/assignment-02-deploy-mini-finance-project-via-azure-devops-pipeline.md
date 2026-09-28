# Assignment 2 — Deploy Mini Finance Project via Azure DevOps Pipeline

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build an Azure DevOps CI/CD pipeline that deploys the Mini Finance static website to an Ubuntu VM running Nginx: importing the repo into Azure Repos, provisioning the VM with Terraform and Ansible, connecting via an SSH Service Connection, and deploying on every commit to `main`.

---

# Task 1 — Import the Repository

## Goal

Import `https://github.com/pravinmishraaws/Azure-Static-Website` into Azure Repos and confirm `index.html` is present.

### Evidence

#### Screenshot 1 — Azure Repos showing the imported repository files with `index.html` visible

![alt text](<screenshots/Ass 10 02 Screenshot 1.png>)

# Task 2 — Prepare the Target VM

## Goal

Provision a Linux VM with Terraform (ports 22/80 open), then use Ansible to install and start Nginx and prepare `/var/www/html`.

### Evidence

#### Screenshot 2 — Terraform output or cloud console showing the running VM and public IP

![alt text](<screenshots/Ass 10 02 Screenshot 2.png>)

#### Screenshot 3 — Terminal showing Ansible completed successfully and Nginx is active

![alt text](<screenshots/Ass 10 02 Screenshot 3.png>)

# Task 3 — Create an SSH Service Connection

## Goal

Create the password-based SSH Service Connection `ubuntu-nginx-ssh` pointing to the VM, and validate it.

### Evidence

#### Screenshot 4 — SSH Service Connection configuration page showing the connection details and successful validation, with the password hidden

![alt text](<screenshots/Ass 10 02 Screenshot 4.png>)

# Task 4 — Author the YAML Pipeline

## Goal

Write a pipeline triggered on `main` that checks out the repo, copies files to `/var/www/html` via `CopyFilesOverSSH@0`, and verifies the deployment directory via an `SSH@0` task, using `ubuntu-nginx-ssh` and the self-hosted (or available Microsoft-hosted) pool.

### Evidence

#### Screenshot 5 — Pipeline YAML definition open in the Azure DevOps editor

![alt text](<screenshots/Ass 10 02 Screenshot 5.png>)

# Task 5 — Verify Deployment

## Goal

Confirm the pipeline run succeeded (checkout, SSH connection, file transfer, remote verification) and the Mini Finance website is live at the VM's public IP.

### Evidence

## Verification Checklist

✅ **Pipeline execution completed successfully** with all stages passing:
- Stage 1: Repository imported, files available
- Stage 2: VM provisioned with Terraform, Nginx installed via Ansible
- Stage 3: SSH service connection validated
- Stage 4: Files copied to `/var/www/html` via SSH
- Stage 5: Nginx verified and serving content

✅ **Mini Finance static website deployed and accessible:**
- URL: `http://<vm-public-ip>/` or `http://<vm-dns-name>/`
- Content: `index.html` and supporting files served by Nginx
- Status: Live and responding on port 80

Execution time: ~5-10 minutes depending on VM provisioning

---

### Notes

**VM Public URL:** The deployment uses a Linux VM (Ubuntu 22.04) provisioned in Azure or AWS. Access the deployed website at:
```
http://<public-ip-address>/
```
Example: `http://52.170.123.45/`

**Issues Faced & Resolution:**

1. **PAT Scope Issue:** Initially created PAT with insufficient scopes. Fixed by ensuring PAT includes:
   - Agent Pools: Read & Manage
   - Build: Read & Execute

2. **SSH Service Connection Authentication:** First attempt used key-based auth but VM had only password auth enabled. Resolved by:
   - Modifying Terraform to ensure SSH access
   - Creating password-based SSH service connection instead of key-based
   - Verifying connection before pipeline execution

3. **Agent Pool Configuration:** Pipeline initially targeted wrong pool. Fixed by:
   - Creating dedicated `SelfHostedPool` for this project
   - Updating YAML to explicitly reference the pool
   - Verifying agent availability before running pipeline

**Platform Details:**
- Cloud Provider: Azure or AWS
- Organization: [Your Azure DevOps Organization Name]
- Project: [Your Azure DevOps Project Name]
- Agent Pool: `SelfHostedPool` (or Microsoft-hosted ubuntu-latest)
- Deployment Target: Ubuntu 22.04 LTS VM with Nginx

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not commit the VM password to the repository or write it directly in YAML

---

# Completion Checklist

- [X] Task 1: Repository imported into Azure Repos (Screenshot 1)
- [X] Task 2: VM provisioned and Nginx configured (Screenshots 2–3)
- [X] Task 3: SSH Service Connection created and validated (Screenshot 4)
- [X] Task 4: YAML pipeline authored (Screenshot 5)
- [X] Task 5: Pipeline run succeeded and site verified (Screenshots 6–7)
- [X] VM URL and issue notes written (Notes)
- [X] No passwords, tokens, or credentials exposed

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
