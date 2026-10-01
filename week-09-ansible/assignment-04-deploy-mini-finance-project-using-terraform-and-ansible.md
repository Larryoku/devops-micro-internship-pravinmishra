# Assignment 4 — Deploy Mini Finance Project Using Terraform and Ansible

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will provision an Azure VM with Terraform and use Ansible to automate the install, deploy, and verify workflow for the Mini Finance static website — a clean separation between infrastructure and configuration management.

---

# Task 1 — Set Up Folder Layout

## Goal

Create the `mini-finance` project with separate `terraform/` and `ansible/` subdirectories.

### Evidence

#### Screenshot 1 — Terminal or editor showing the complete `mini-finance` project tree

![Screenshot 1](./screenshots/Ass%2009%2004%20screenshot%201.png)

---

# Task 2 — Terraform — Azure VM + NSG (Ports 22/80)

## Goal

Provision an Ubuntu 22.04 Standard_B1s VM with a public IP, SSH key authentication, and an NSG allowing SSH (22) and HTTP (80), and output the public IP.

### Evidence

#### Screenshot 2 — Terminal showing the end of a successful `terraform apply`

![Screenshot 2](./screenshots/Ass%2009%2004%20screenshot%202.png)

---

#### Screenshot 3 — Terminal showing `terraform output public_ip`

![Screenshot 3](./screenshots/Ass%2009%2004%20screenshot%203.png)

---

#### Screenshot 4 — Terraform code or Azure Portal showing NSG inbound rules for ports 22 and 80

![Screenshot 4](./screenshots/Ass%2009%2004%20screenshot%204.png)

---

# Task 3 — Configure Passwordless SSH

## Goal

Connect to the VM with SSH using the injected key and run `hostname` remotely without a password prompt.

### Evidence

#### Screenshot 5 — Terminal showing the successful passwordless SSH hostname check

![Screenshot 5](./screenshots/Ass%2009%2004%20screenshot%205.png)

---

# Task 4 — Ansible — Multi-Play: Install → Deploy → Verify

## Goal

Create `ansible/inventory.ini` and a three-play `site.yml` that installs Nginx and Git, clones and deploys the Mini Finance repository to `/var/www/html/` with a reload handler, and verifies HTTP 200 from `localhost`.

### Evidence

#### Screenshot 6 — Editor showing `inventory.ini` and the three plays in `site.yml`

![Screenshot 6](./screenshots/Ass%2009%2004%20screenshot%206.png)

---

#### Screenshot 7 — Terminal showing `ansible-playbook -i inventory.ini site.yml` with HTTP 200, assertion OK, and no failures

![Screenshot 7](./screenshots/Ass%2009%2004%20screenshot%207.png)

---

# Task 5 — Test End-to-End Functionality

## Goal

Confirm the Mini Finance site is publicly accessible and correctly served by Nginx.

### Evidence

#### Screenshot 8 — Browser showing the Mini Finance site loaded from `http://<public_ip>` with the URL visible

Add your screenshot here.

---

### Notes

**Issues Faced & Resolution:**

1. **Terraform Output Integration**: Initially, I manually copied IPs from Terraform output to inventory.ini. The proper approach is using `terraform output` commands or storing IPs in a JSON file that Ansible can parse. Fixed by documenting the process clearly: run `terraform apply`, then update inventory.ini with the public IP from the `terraform output` command.

2. **Git Clone Permissions**: The git clone task ran as root (due to `become: true`), which created files owned by root. Fixed by using `remote_src: yes` with the copy module and explicitly setting `owner: www-data` and `group: www-data` to ensure Nginx can serve the files correctly.

3. **Relative Path Issues**: The SSH key path in inventory referenced `../terraform/id_ed25519`, which failed from different working directories. Resolved by documenting that the playbook should be run from the `ansible/` directory with the correct relative path.

**Key Learnings:**

- **Terraform Outputs as Source of Truth**: Infrastructure outputs (IPs, DNS names, database endpoints) should flow directly from Terraform into configuration management tools. This minimizes manual errors and enables true Infrastructure as Code workflows.

- **Separation of Concerns**: Keeping Terraform and Ansible in separate directories (`terraform/` and `ansible/`) makes it clear which tool manages what. Terraform provisions infrastructure; Ansible configures it. This pattern scales well for enterprise deployments.

- **Idempotency Importance**: Running the playbook twice should result in the second run being mostly unchanged (only the git clone would trigger if the repository changed). This is critical for production—you should be able to re-run deployments without breaking existing services.

**Real-World Application:**

This Terraform + Ansible workflow is used in production by companies like Shopify and Etsy. Terraform handles "what exists" (VMs, networks, databases), while Ansible handles "what's installed and configured on those resources." Together, they enable repeatable, auditable infrastructure deployments across hundreds of servers.

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about the Terraform + Ansible deployment, mentioning the Azure VM, secure networking, passwordless SSH, Nginx deployment, and HTTP verification, with one challenge you faced and how you fixed it, and one real-world example of this workflow.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/[YOUR_USERNAME]_[POST_ID]`

**🔗 MANUAL: Add your published LinkedIn post URL here before submission**

---

#### Screenshot — Published LinkedIn post showing the text and at least one image or proof

Add your screenshot here.

---

# Submission Instructions

- Add all required screenshots in your submission
- The `mini-finance` project tree and `inventory.ini` may have the final IP octet masked
- Do not expose private keys or other secrets

---

# Completion Checklist

- [ ] Task 1: `mini-finance` project structure created (Screenshot 1)
- [ ] Task 2: Azure VM and NSG provisioned with Terraform (Screenshots 2–4)
- [ ] Task 3: Passwordless SSH verified (Screenshot 5)
- [ ] Task 4: Ansible install/deploy/verify plays run successfully (Screenshots 6–7)
- [ ] Task 5: Site verified in the browser (Screenshot 8)
- [ ] Reflection notes written (Notes)
- [ ] LinkedIn post published and URL submitted
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
