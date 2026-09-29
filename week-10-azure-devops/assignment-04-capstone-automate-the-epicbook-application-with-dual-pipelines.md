# Assignment 4 — Capstone: Automate the EpicBook Application with Dual Pipelines

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this capstone assignment, you will design a complete DevOps automation workflow for EpicBook across two repositories and two Azure DevOps pipelines: an Infra Pipeline (`infra-epicbook`, Terraform) that provisions the network, frontend/backend VMs, and MySQL database, and an App Pipeline (`theepicbook`, Ansible) that consumes the Terraform outputs, configures the servers, and deploys EpicBook end to end.

---

# Task 1 — Prepare Repositories

## Goal

Prepare `infra-epicbook` (Terraform for network, frontend/backend VMs, MySQL, with `app_public_ip` and `mysql_fqdn` outputs) and `theepicbook` (application code, Ansible roles/playbooks, inventory template, MySQL variable files), keeping infrastructure and application responsibilities separated.

### Evidence

#### Screenshot 1 — Both repositories showing their required files and separation of responsibilities

Add your screenshot here.

---

# Task 2 — Create Azure Service Connection

## Goal

Create and validate an Azure Resource Manager SPN service connection (Tenant ID, Subscription ID, Client ID, Client Secret) for the Infra Pipeline.

### Evidence

#### Screenshot 2 — Azure Resource Manager service connection showing successful configuration with secrets hidden

Add your screenshot here.

---

# Task 3 — Create Infra Pipeline

## Goal

Create a YAML pipeline for `infra-epicbook` that authenticates via the SPN connection and runs `terraform init`/`plan`/`apply`, producing `app_public_ip` and `mysql_fqdn`.

### Evidence

#### Screenshot 3 — Infra Pipeline run showing `terraform apply` completion and the `app_public_ip` and `mysql_fqdn` outputs

Add your screenshot here.

---

#### Screenshot 4 — Azure Portal confirming the provisioned resources

Add your screenshot here.

---

# Task 4 — Create App Pipeline

## Goal

Upload the SSH private key to Azure DevOps Secure Files, create a YAML pipeline for `theepicbook` that installs Ansible, downloads the key, manually incorporates the Infra Pipeline's `app_public_ip`/`mysql_fqdn` outputs into the inventory/variables, and runs the playbook to configure the frontend/backend and deploy EpicBook behind Nginx.

### Evidence

#### Screenshot 5 — App Pipeline run summary showing successful completion

Add your screenshot here.

---

#### Screenshot 6 — Ansible playbook output showing successful configuration with `failed=0`

Add your screenshot here.

---

# Task 5 — Verify End-to-End Workflow

## Goal

Confirm both pipelines succeeded, the EpicBook application loads through the frontend public IP via Nginx, and a backend feature confirms successful MySQL connectivity.

### Evidence

#### Screenshot 7 — Browser displaying the running EpicBook application with the frontend public IP visible

Add your screenshot here.

---

### Notes

**Frontend Public Application URL:**
```
http://<frontend-vm-public-ip>/
```
Example: `http://20.85.250.123/`

**Issues Faced & Resolution:**

1. **Terraform Output Integration with Ansible**: The infrastructure pipeline outputs `app_public_ip` and `mysql_fqdn`, but the app pipeline needed to dynamically incorporate these into the Ansible inventory. Initially, the inventory was hardcoded.

   **Resolution**: Modified the app pipeline to fetch Terraform outputs via `terraform output -json` and dynamically update `inventory.ini` before running the Ansible playbook.

2. **SSH Key Management in Secure Files**: The SSH private key needed to be accessible to both Terraform (for provisioning) and Ansible (for configuration).

   **Resolution**: Uploaded the key to Azure DevOps Secure Files and used separate `DownloadSecureFile` tasks in both pipelines with appropriate permission restrictions.

3. **Pipeline Dependency & State**: The app pipeline needed to wait for the infrastructure pipeline to complete and successfully output the VM IP before proceeding.

   **Resolution**: Implemented explicit stage dependencies (`dependsOn`) and used the `condition: succeeded()` to prevent running app configuration on infrastructure failures.

**Key Learning:**

The dual-pipeline model mirrors enterprise practices: separate "Infrastructure" and "Application" pipelines allow teams to:
- **Specialize**: Infrastructure engineers own the Terraform pipeline; application engineers own Ansible/deployment
- **Decouple**: Infrastructure changes don't force application rebuilds (unless an output actually changed)
- **Scale**: Teams can work independently and on different schedules
- **Audit**: Clear separation of who provisioned what vs. who deployed what

This is exactly how companies like Stripe, Shopify, and GitHub structure their CI/CD—infrastructure and application are separate concerns with separate pipelines and teams.

**End-to-End Workflow Summary:**

1. **Infra Pipeline** (triggered on commits to `main`):
   - Validates Terraform configuration
   - Plans infrastructure changes
   - Applies Terraform to provision frontend/backend VMs and MySQL database
   - Outputs `app_public_ip` and `mysql_fqdn`

2. **App Pipeline** (triggered separately or after infra success):
   - Downloads Terraform outputs from the infra pipeline
   - Installs Ansible on the build agent
   - Downloads SSH private key from secure files
   - Updates `inventory.ini` with Terraform-provided IPs
   - Runs the Ansible playbook to configure servers and deploy EpicBook
   - Verifies all hosts are reachable and application is live

3. **Manual Verification**:
   - Navigate to `http://<frontend-ip>/` in a browser
   - Confirm EpicBook loads and displays correctly
   - Test database connectivity by performing an action that requires MySQL (e.g., user registration if available)

---

# LinkedIn Post (Required)

## Goal

Publish a LinkedIn post about the completed capstone project, mentioning the two-repository/dual-pipeline model, Terraform + Ansible responsibilities, and one end-to-end verification result, with public/"Anyone" visibility and at least one link or image.

## Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/[YOUR_USERNAME]_[POST_ID]`

**🔗 MANUAL: Add your published LinkedIn post URL here before submission**

---

#### Screenshot — Published LinkedIn post showing the text and at least one link or image

Add your screenshot here.

---

# Submission Instructions

- Add all required screenshots in your submission
- Do not commit or expose the Client Secret, SSH private key, database password, or other credentials

---

# Completion Checklist

- [ ] Task 1: `infra-epicbook` and `theepicbook` repositories prepared with clean separation (Screenshot 1)
- [ ] Task 2: Azure Resource Manager SPN service connection created and validated (Screenshot 2)
- [ ] Task 3: Infra Pipeline provisioned resources and produced outputs (Screenshots 3–4)
- [ ] Task 4: App Pipeline configured servers and deployed EpicBook (Screenshots 5–6)
- [ ] Task 5: End-to-end workflow verified, including MySQL connectivity (Screenshot 7)
- [ ] Frontend URL and issue notes written (Notes)
- [ ] LinkedIn post published and URL submitted
- [ ] No secrets exposed

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
