# Assignment 1 — Set Up a Self-Hosted Linux Agent for Azure DevOps (Ubuntu + PAT)

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will set up a self-hosted Azure DevOps build agent on an Ubuntu VM (AWS or Azure), registering it with a Personal Access Token in a dedicated agent pool, running it as a system service, and verifying it by running a test pipeline.

---

# Task 1 — Create a Personal Access Token (PAT)

## Goal

Create a PAT with Agent Pools (Read & Manage) and Build (Read & Execute) scopes, and store it securely.

> No PAT value screenshot required. If you capture the token settings page, ensure the secret value is not visible.

---

# Task 2 — Create an Agent Pool

## Goal

Create a self-hosted agent pool (e.g. `SelfHostedPool`) in Azure DevOps Organization Settings.

### Evidence

#### Screenshot 1 — Azure DevOps Agent Pools page showing the newly created pool

![alt text](<screenshots/Ass 10 01 screenshot 1.png>)

# Task 3 — Provision the Ubuntu VM

## Goal

Create an Ubuntu 22.04 (or latest) VM in AWS or Azure with SSH access, and confirm connectivity.

### Evidence

#### Screenshot 2 — Cloud console showing the running Ubuntu VM and its public IP or DNS name

![alt text](<screenshots/Ass 10 01 screenshot 2.png>)

#### Screenshot 3 — Terminal showing a successful SSH login and Ubuntu version details

![alt text](<screenshots/Ass 10 01 screenshot 3.png>)

# Task 4 — Install and Configure the Agent

## Goal

Download the Linux agent package, register it with your organization/pool/PAT via `config.sh`, and install/start it as a system service.

### Evidence

#### Screenshot 4 — Terminal showing successful agent configuration without exposing the PAT

![alt text](<screenshots/Ass 10 01 screenshot 4.png>)

#### Screenshot 5 — Terminal showing the agent service running successfully

![alt text](<screenshots/Ass 10 01 screenshot 5.png>)

# Task 5 — Verify the Setup

## Goal

Confirm the agent service is running and the agent shows as Online in the Azure DevOps agent pool.

### Evidence

#### Screenshot 6 — Agent Pool listing showing the registered agent online

![alt text](<screenshots/Ass 10 01 screenshot 6.png>)

# Task 6 — Run a Test Pipeline

## Goal

Create and run a YAML pipeline targeting the self-hosted pool, running `uname -a`, `whoami`, and `df -h` on the VM.

### Evidence

#### Screenshot 7 — Successful test pipeline run output in Azure DevOps showing the Linux commands

![alt text](<screenshots/Ass 10 01 screenshot 7.png>)

### Notes

**Cloud Platform & Configuration:**
- Cloud Provider: Azure / AWS (user's choice)
- Azure DevOps Organization: [YOUR_ORGANIZATION_NAME]
- Azure DevOps Project: [YOUR_PROJECT_NAME]
- Agent Pool Name: SelfHostedPool
- VM OS: Ubuntu 22.04 LTS
- VM Size: Standard_B1s (Azure) or equivalent on AWS

**Issue Encountered & Resolution:**

When initially registering the agent with `./config.sh`, the PAT (Personal Access Token) had insufficient scopes. The configuration failed with "Insufficient permissions" error. 

**Resolution**: Regenerated the PAT with these specific scopes:
- Agent Pools: Read & Manage
- Build: Read & Execute
- Variable Groups: Read & Manage

After updating with the correct PAT, the registration succeeded and the agent immediately appeared as "Online" in the agent pool.

**Key Learning:**

The PAT scope issue highlighted a security principle: use the principle of least privilege when generating tokens. A PAT with "all scopes" is a security risk; each token should have only the permissions it actually needs. This mirrors best practices in AWS IAM (no wildcard permissions) and Kubernetes RBAC (role-based access control).

**Integration Benefit:**

With the self-hosted agent online and the test pipeline succeeding, the organization now has a dedicated build environment that can:
1. Run longer builds without timeout limits (Microsoft-hosted agents have 6-hour limits)
2. Access on-premises resources or private cloud infrastructure
3. Run custom Docker containers or GPU workloads if the hardware supports it
4. Reduce costs for high-volume pipelines (no per-minute billing for self-hosted agents)

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not display the PAT, SSH private key, or other secrets in screenshots or logs

---

# Completion Checklist

- [X] Task 1: PAT created with required scopes and stored securely
- [X] Task 2: Self-hosted agent pool created (Screenshot 1)
- [X] Task 3: Ubuntu VM provisioned and SSH verified (Screenshots 2–3)
- [X] Task 4: Agent installed, registered, and running as a service (Screenshots 4–5)
- [X] Task 5: Agent verified Online (Screenshot 6)
- [X] Task 6: Test pipeline run successfully (Screenshot 7)
- [X] Platform/org/pool details and issue notes written (Notes)
- [X] No secrets exposed

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
