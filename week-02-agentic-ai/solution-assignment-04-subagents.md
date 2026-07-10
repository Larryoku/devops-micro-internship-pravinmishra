# Assignment 4 — Building Your AI Team

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build and configure a set of specialized AI subagents inside your project. You will learn how different models and tool permissions define agent behavior, and you will trigger two real agent delegations to analyze security and cost aspects of your Terraform infrastructure.

---

# Task 1 — Create the Agents Folder and Add Files

## Goal

Create the `.claude/agents/` directory and add all required agent files.

### Evidence

#### Screenshot 1 — VS Code sidebar showing `.claude/agents/` with all 3 files

Add your screenshot here.

--- ![alt text](<Tasks 1-1.png>)

# Task 2 — Compare the Agent Configurations

## Goal

Analyze the configuration differences between the three agents and demonstrate understanding of model and tool selection.

### Written Answers

#### 1. Why does the cost optimizer use Haiku instead of Sonnet?

Add your answer here...

--- Cost optimization tasks typically involve parsing large volumes of text, metrics, and cloud pricing data to find anomalies or matching patterns. Claude 3.5 Haiku is highly efficient, incredibly fast, and significantly more cost-effective than Sonnet. Since analyzing infrastructure costs doesn't require deep architectural reasoning or complex code generation, using Haiku minimizes the operational token spend of the AI team without sacrificing accuracy.

#### 2. Why does the security auditor NOT have Write in its tools list?

Add your answer here...

--- The principle of least privilege and blast-radius containment. A security auditor's job is purely observational—it needs to read your Terraform configuration files (Read permissions) to flag vulnerabilities, open ports, or unencrypted resources. Giving it Write permissions would allow it to modify your infrastructure code autonomously, which risks introducing accidental misconfigurations or unauthorized changes without a human-in-the-loop review.

#### 3. Why does the tf-writer use `inherit` instead of a specific model?

Add your answer here...

--- Using inherit allows the subagent to dynamically leverage whatever parent model the user is currently running in their main Claude Code session (typically Claude 3.5 Sonnet). Writing Terraform code requires high-level reasoning, complex logic handling, and syntax precision. Inheriting the parent model ensures that if the main session upgrades or shifts context, the tf-writer automatically utilizes that same premium reasoning capacity without needing a hardcoded configuration update.

### Evidence

#### Screenshot 2 — `security-auditor.md` frontmatter showing model and tools configuration

Add your screenshot here.

--- ![alt text](<tasks 2-1.png>)

#### Screenshot 3 — `cost-optimizer.md` frontmatter showing the model and tools configuration

Add your screenshot here.

--- ![alt text](<Tasks 3-2.png>)

# Task 3 — Run the Security Auditor

## Goal

Trigger the security auditor agent and analyze the generated security report for your Terraform infrastructure.

### Evidence

#### Screenshot 4 — The delegation message showing Claude launched the security-auditor

Add your screenshot here.

--- ![alt text](<Tasks 4-2.png>)

#### Screenshot 5 — Security audit report output

Add your screenshot here.

--- ![alt text](<tasks 5-3.png>)

# Task 4 — Run the Cost Optimizer

## Goal

Trigger the cost optimizer agent and review the generated cost optimization report.

### Evidence

#### Screenshot 6 — The full cost optimization report

Add your screenshot here.

--- ![alt text](<Tasks 6-2.png>)

# Submission Instructions

- Ensure all agent files are committed in `.claude/agents/`
- Complete all written answers in your GitHub Repo
- Push final changes to your forked GitHub repository

---

## GitHub Repository URL

Paste your forked repository URL here:

`_____________https://github.com/Larryoku/devops-micro-internship-pravinmishra_____________`

---

# Completion Checklist

- [X] `.claude/agents/` folder contains all 3 agent files
- [X] Screenshot 2 shows correct `security-auditor.md` configuration
- [X] Screenshot 3 shows correct `cost-optimizer.md` configuration
- [X] All 3 written answers completed 
- [X] Security auditor executed successfully
- [X] Cost optimizer executed successfully
- [X] Security report is visible with findings
- [X] Cost report is visible with recommendations
- [X] All required screenshots added
- [X] GitHub repo updated with agents

---

## 📌 About DMI & CloudAdvisory

DevOps Micro Internship (DMI) is a project-based DevOps program run by Pravin Mishra (The CloudAdvisory) focused on real-world execution, systems thinking, and career readiness.

It helps learners build strong DevOps foundations with hands-on experience.

---

## 📌 Resources

- 🌐 DMI Official Website: https://pravinmishra.com/dmi  
- 🎓 DevOps for Beginners (Udemy): https://www.udemy.com/course/devops-for-beginners-docker-k8s-cloud-cicd-4-projects/  
- 🎓 Agentic AI DevOps with Claude Code: https://www.udemy.com/course/ultimate-agentic-ai-devops-with-claude-code/  
- 🎓 DevOps with Claude Code: Terraform, EKS, ArgoCD & Helm: https://www.udemy.com/course/devops-with-claude-code-terraform-eks-argocd-helm/  
- ▶️ YouTube Playlist: https://www.youtube.com/playlist?list=PLFeSNDtI4Cho  
- 🔗 Pravin Mishra (LinkedIn): https://www.linkedin.com/in/pravin-mishra-aws-trainer/  
- 🏢 CloudAdvisory (LinkedIn): https://www.linkedin.com/company/thecloudadvisory/

---

*This submission is part of DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*