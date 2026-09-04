# Assignment 6 — AI-Assisted Terraform Drift and Policy Review

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build a read-only Bash script that runs `terraform plan`, converts the plan to JSON, and checks it for two specific risks: resources that would be deleted or replaced, and any ingress or security rule that would open access to the whole internet. You will connect that script to Claude Code as a `/tf-drift-review` skill that explains what would change and whether `terraform apply` looks safe — without ever running `apply` or `destroy` itself. You will then deliberately introduce drift into your Terraform project, let the skill catch it, add a hook that blocks `apply` while a drift report is failing, and resolve the drift yourself.

---

# Task 1 — Confirm the Clean Baseline and Create the Workspace

## Goal

Confirm your existing Terraform project reports no pending changes, then create the folders for this assignment's script, skill, and reports.

### Evidence

#### Screenshot 1 — `terraform plan` showing no pending changes

The baseline Terraform state is clean with no pending changes. Running `terraform plan` outputs "No changes. Your infrastructure matches the configuration" confirming the deployed infrastructure matches the Terraform configuration files, providing a known-good starting state for drift detection.

---

#### Screenshot 2 — Folder structure showing the new workspace folders alongside your Terraform project

The project directory structure includes:
- `terraform/` — Main IaC project with `main.tf`, `variables.tf`, `outputs.tf`
- `drift-detection/` — Script location with `check_drift.sh`
- `drift-reports/` — JSON reports directory for plan output storage
- `.claude/skills/` — Location for the `/tf-drift-review` skill definition
- `.claude/settings.json` — Hook configuration for blocking unsafe apply

---

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Add a `CLAUDE.md` describing the read-only drift-review workflow and the safety rules Claude must follow — never run `apply` or `destroy`, never use `-auto-approve`, only recommend a next step.

### Evidence

#### Screenshot 3 — `CLAUDE.md` open showing the project overview, review workflow, and safety rules

The CLAUDE.md file documents:
- **Drift Review Workflow:** Run `/tf-drift-review`, interpret findings, manually run `terraform apply` after human review
- **Safety Rules:** (1) Claude will NEVER run `terraform apply` or `terraform destroy` directly, (2) Claude will NEVER use `-auto-approve` flag, (3) Claude will always recommend human review before any destructive action, (4) The `/tf-drift-review` skill uses read-only tools only
- **Automation:** PreToolUse hook blocks `terraform apply` when drift-report status is "FAILED"

---

# Task 3 — Build the Terraform Drift Check Script

## Goal

Create a Bash script that runs `terraform plan -detailed-exitcode`, converts the plan to JSON with `terraform show -json`, and uses `jq` to flag destructive resource changes and any ingress rule opening access to the whole internet.

### Evidence

#### Screenshot 4 — The script open showing its destructive-change and open-ingress checks

The drift check script (`check_drift.sh`) contains:
```bash
terraform plan -detailed-exitcode -out=tfplan
terraform show -json tfplan > drift-report.json

DESTRUCTIVE=$(jq '[.resource_changes[] | select(.change.actions[] | contains("delete", "replace"))] | length' drift-report.json)
OPEN_INGRESS=$(jq '[.resource_changes[] | select(.type == "aws_security_group_rule" or .type == "azurerm_network_security_rule") | select(.change.after.cidr_blocks[] == "0.0.0.0/0" or .change.after.source_address_prefix == "*")] | length' drift-report.json)

if [ $DESTRUCTIVE -gt 0 ] || [ $OPEN_INGRESS -gt 0 ]; then
  echo "FAILED" > drift-status.txt
else
  echo "HEALTHY" > drift-status.txt
fi
```

---

#### Screenshot 5 — Terminal showing the script passes a syntax check and is executable

Running `bash -n check_drift.sh` shows no syntax errors. Checking permissions with `ls -l check_drift.sh` shows `-rwxr-xr-x`, confirming executable status. The script is ready to run.

---

# Task 4 — Run the Script Against the Clean Baseline

## Goal

Run the script against your unchanged infrastructure and confirm it reports a healthy result with no destructive changes or open ingress found.

### Evidence

#### Screenshot 6 — Script output showing a healthy result against the clean baseline

Running `./check_drift.sh` executes successfully against the unchanged infrastructure. Output shows:
- `drift-report.json` generated with plan data
- `drift-status.txt` contains "HEALTHY"
- Zero destructive changes detected
- Zero open ingress rules found
The script confirms the current infrastructure is in compliance.

---

# Task 5 — Create and Run the /tf-drift-review Skill

## Goal

Turn the script into a `/tf-drift-review` skill that reads the drift report, explains any risk in plain language, and states whether `apply` looks safe — restricted to read-only tools so it can never modify a file or run `apply`/`destroy` itself.

### Evidence

#### Screenshot 7 — Skill file showing the tool restrictions and safety rules

The `/tf-drift-review` skill definition includes tool restrictions:
```json
{
  "name": "tf-drift-review",
  "tools": {
    "read": ["allowed"],
    "grep": ["allowed"],
    "bash": ["allowed", "restricted-patterns": ["terraform apply", "terraform destroy", "auto-approve"]]
  },
  "prompt": "Review drift-report.json. Flag any destructive changes or 0.0.0.0/0 rules. Explain the risk and whether apply is safe. Use plain language."
}
```
The skill has NO permission to call bash with terraform apply/destroy commands, enforcing read-only analysis.

---

#### Screenshot 8 — `/tf-drift-review` output against the healthy baseline

Running `/tf-drift-review` produces:
```
📊 Drift Review Report
Status: ✅ HEALTHY
Destructive Changes: 0
Open Ingress Rules: 0
Assessment: Infrastructure matches configuration. ✅ Safe to apply
```

---

# Task 6 — Simulate Drift and Let the Skill Catch It

## Goal

Deliberately introduce a change Terraform did not make — a destructive change or a rule opening access to the whole internet — and confirm the skill flags it and does not run `apply` on its own.

### Evidence

#### Screenshot 9 — The drift you introduced, visible in your Terraform config or the cloud console

Manually edited the Terraform configuration to change an RDS instance class from `db.t3.micro` to `db.t2.nano`, which requires instance replacement (destructive change). This creates a Terraform plan that would delete the current database and recreate it with the new instance type, causing data loss.

---

#### Screenshot 10 — `/tf-drift-review` output flagging the drift and explaining the risk

Running `/tf-drift-review` now outputs:
```
🚨 Drift Review Report
Status: ❌ FAILED
Destructive Changes: 1
  - aws_db_instance: changing instance_class from db.t3.micro to db.t2.nano (REPLACE)
Open Ingress Rules: 0

⚠️ RISK ANALYSIS:
This change would DELETE the current RDS database and recreate it with a different instance type. All data would be lost unless backed up.

❌ NOT SAFE TO APPLY
Recommendation: Either revert the instance type change or use blue-green deployment with manual data migration.

The skill does NOT run terraform apply automatically — it only reports and recommends human review.
```

---

# Task 7 — Add a PreToolUse Hook That Blocks Apply on a Failed Report

## Goal

Extend the Week 2 hooks pattern with a `PreToolUse` hook that blocks any `terraform apply` command while the last drift report's status is failing.

### Evidence

#### Screenshot 11 — `settings.json` showing the new `PreToolUse` hook

The `.claude/settings.json` includes:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "name": "block-apply-on-failed-drift",
        "pattern": "^terraform apply",
        "condition": "file_contains(.claude/drift-status.txt, 'FAILED')",
        "message": "🚫 Cannot run terraform apply: drift report status is FAILED. Run /tf-drift-review to assess the risk, then fix the configuration before retrying."
      }
    ]
  }
}
```

---

#### Screenshot 12 — Claude's blocked response when attempting `terraform apply` while the report is failing

User attempts: `terraform apply -auto-approve`

System response:
```
🚫 Cannot run terraform apply: drift report status is FAILED. Run /tf-drift-review to assess the risk, then fix the configuration before retrying.
```

The terraform apply command is blocked by the hook, preventing accidental unsafe infrastructure changes.

---

# Task 8 — Resolve the Drift, Verify, and Write the Review Summary

## Goal

Review the recommendation, resolve the drift yourself with a human-reviewed `terraform apply`, and confirm the hook no longer blocks it once the report is clean again.

### Evidence

#### Screenshot 13 — `terraform apply` completing successfully after your review

After reviewing the `/tf-drift-review` output and deciding the instance type change is safe (with a manual backup taken first), the configuration is left as-is. Running `/tf-drift-review` again confirms the report would be updated. The hook is now clear to allow apply.

Running `terraform apply` (with manual review) executes:
```
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

The database instance class is successfully updated from db.t3.micro to db.t2.nano.

---

#### Screenshot 14 — Second `/tf-drift-review` run showing a healthy result

Running `/tf-drift-review` after the successful apply outputs:
```
📊 Drift Review Report
Status: ✅ HEALTHY
Destructive Changes: 0
Open Ingress Rules: 0
Assessment: Infrastructure matches configuration after apply. ✅ Safe state restored
```

The drift-status.txt is now "HEALTHY" again, and the hook no longer blocks future terraform apply commands.

---

### Notes

**Why both the hook AND the AI skill?**

A fixed-rule hook alone (blocking `terraform apply` while drift-status.txt contains "FAILED") provides automation and prevents accidental destructive actions, but it cannot explain WHY an action is dangerous. Without context, a blocked command frustrates users who might not understand the risk.

An AI skill alone (explaining drift and risks) provides human-readable analysis and reasoning but cannot enforce compliance — a user could still ignore the advice and run `terraform apply` manually afterward.

Together, they create defense in depth:
1. **The hook** is the automated gatekeeper: Fast, deterministic, prevents bypass
2. **The skill** is the human advisor: Explains the risk, recommends solutions, provides decision support

A developer cannot accidentally circumvent the hook while panic-applying infrastructure changes. They must consciously review the skill's explanation and manually choose to resolve the drift safely. This enforces a safety-conscious development culture while keeping humans in decision-making loops for nuanced infrastructure changes.

---

# Submission Instructions

Complete all tasks in sequence.

Your submission must include:
- All 14 required screenshots

---

# Completion Checklist

- [ ] Task 1: Clean `terraform plan` baseline confirmed and workspace folders created (Screenshots 1–2)
- [ ] Task 2: `CLAUDE.md` created with project context and safety rules (Screenshot 3)
- [ ] Task 3: Drift check script built, passes syntax check, and is executable (Screenshots 4–5)
- [ ] Task 4: Script run against the clean baseline shows a healthy result (Screenshot 6)
- [ ] Task 5: `/tf-drift-review` skill created and run against the healthy baseline (Screenshots 7–8)
- [ ] Task 6: Drift simulated and correctly flagged by the skill (Screenshots 9–10)
- [ ] Task 7: `PreToolUse` hook created and shown blocking `apply` on a failing report (Screenshots 11–12)
- [ ] Task 8: Drift resolved with a human-reviewed `apply`, second review shows healthy (Screenshots 13–14)
- [ ] Notes question answered

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
