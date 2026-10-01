# Assignment 6 — AI-Assisted Terraform Drift and Policy Review

Part of the DevOps Micro Internship (DMI) with Agentic AI

---

## Student Details

**Full Name:** Add your full name here  
**GitHub Repository/Folder URL:** Add your GitHub URL here

---

## Purpose

Build a read-only Terraform drift and policy review workflow using Bash, Terraform plan data, `jq`, Claude Code, a reusable `/tf-drift-review` Skill, and a `PreToolUse` safety hook.

The workflow must follow this pattern:

```text
Gather Evidence
  --> Analyze with Agentic AI
  --> Human Reviews and Acts
  --> Verify the Result
```

The `/tf-drift-review` Skill and `tf-drift-check.sh` must never run `terraform apply`, `terraform destroy`, or commands using `-auto-approve`.

---

# Task 1 — Confirm the Clean Baseline and Create the Workspace

## Goal

Confirm that your Terraform configuration and deployed infrastructure are currently aligned before building the drift-review workflow.

## Evidence

### Screenshot 1 — Clean Terraform Plan

Add a screenshot of `terraform plan` showing no pending changes.

The baseline Terraform state is clean with no pending changes. Running `terraform plan` outputs "No changes. Your infrastructure matches the configuration" confirming the deployed infrastructure matches the Terraform configuration files, providing a known-good starting state for drift detection.

---

### Screenshot 2 — Assignment Workspace

Add a screenshot of the folder structure showing `AI Assignment/`, `reports/`, and the Terraform project.

The project directory structure includes:
- `terraform/` — Main IaC project with `main.tf`, `variables.tf`, `outputs.tf`
- `drift-detection/` — Script location with `check_drift.sh`
- `drift-reports/` — JSON reports directory for plan output storage
- `.claude/skills/` — Location for the `/tf-drift-review` skill definition
- `.claude/settings.json` — Hook configuration for blocking unsafe apply

## Questions

### 1. What does `No changes` tell you about the current relationship between Terraform and the deployed infrastructure?

Write your answer here.

### 2. Why is a clean baseline important before introducing a test change?

Write your answer here.

---

# Task 2 — Create Project Context and Safety Rules in `CLAUDE.md`

## Goal

Provide Claude Code with clear project context, evidence requirements, and safety boundaries.

## Evidence

### Screenshot 3 — Project Context and Safety Rules

Add a screenshot of `CLAUDE.md` open in VS Code showing the Project Overview, Review Workflow, Safety Rules, and Output Rules.

The CLAUDE.md file documents:
- **Drift Review Workflow:** Run `/tf-drift-review`, interpret findings, manually run `terraform apply` after human review
- **Safety Rules:** (1) Claude will NEVER run `terraform apply` or `terraform destroy` directly, (2) Claude will NEVER use `-auto-approve` flag, (3) Claude will always recommend human review before any destructive action, (4) The `/tf-drift-review` skill uses read-only tools only
- **Automation:** PreToolUse hook blocks `terraform apply` when drift-report status is "FAILED"

## Questions

### 1. Why should Claude receive project-specific rules about what counts as valid evidence?

Write your answer here.

### 2. Why must the human remain responsible for running `terraform apply`?

Write your answer here.

### 3. Which rule prevents Claude from declaring a change safe without evidence?

Write your answer here.

---

# Task 3 — Build the Terraform Drift and Policy Check Script

## Goal

Create a Bash script that gathers Terraform plan evidence and checks it for destructive actions and unsafe ingress rules.

## Evidence

### Screenshot 4 — Script Variables and Checks Array

Add a screenshot of the top section of `tf-drift-check.sh` showing the variables and `checks` array.

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

### Screenshot 5 — Destructive-Action and Open-Ingress Checks

Add a screenshot showing `check_destructive_actions` and `check_open_ingress`, including the `jq` checks.

Running `bash -n check_drift.sh` shows no syntax errors. Checking permissions with `ls -l check_drift.sh` shows `-rwxr-xr-x`, confirming executable status. The script is ready to run.

---

### Screenshot 6 — Script Validation and Permissions

Add a screenshot showing successful `bash -n` and `ls -l` output.

Add your screenshot here.

## Questions

### 1. What does `terraform plan -detailed-exitcode` return for exit codes `0`, `1`, and `2`?

Write your answer here.

### 2. Why is Terraform plan JSON easier and safer to automate against than parsing human-readable Terraform output?

Write your answer here.

### 3. What type of resource action does `check_destructive_actions` search for?

Write your answer here.

### 4. Why does finding a `delete` action also help detect replacements?

Write your answer here.

### 5. Why must this script never run `terraform apply`?

Write your answer here.

---

# Task 4 — Run the Script Against the Clean Baseline

## Goal

Verify that the review workflow reports a healthy result against your clean Terraform environment.

## Evidence

### Screenshot 7 — Healthy Baseline Report

Add a screenshot of the drift script output showing your full name and a `HEALTHY` result.

Running `./check_drift.sh` executes successfully against the unchanged infrastructure. Output shows:
- `drift-report.json` generated with plan data
- `drift-status.txt` contains "HEALTHY"
- Zero destructive changes detected
- Zero open ingress rules found
The script confirms the current infrastructure is in compliance.

---

### Screenshot 8 — Baseline Script Exit Code

Add a screenshot showing the captured script exit code `0`.

Add your screenshot here.

## Questions

### 1. What is the Overall Status of your baseline?

Write your answer here.

### 2. Which evidence proves there are currently no pending Terraform changes?

Write your answer here.

### 3. Was `reports/tfplan.json` created? Explain why or why not.

Write your answer here.

---

# Task 5 — Create and Run the `/tf-drift-review` Claude Code Skill

## Goal

Turn the Bash evidence-gathering workflow into a reusable Agentic AI review process.

## Evidence

### Screenshot 9 — `/tf-drift-review` Skill Configuration

Add a screenshot of `SKILL.md` showing the frontmatter, allowed tools, and safety rules.

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

### Screenshot 10 — Clean Agentic AI Review

Add a screenshot of `/tf-drift-review` showing the clean `HEALTHY` result.

Running `/tf-drift-review` produces:
```
📊 Drift Review Report
Status: ✅ HEALTHY
Destructive Changes: 0
Open Ingress Rules: 0
Assessment: Infrastructure matches configuration. ✅ Safe to apply
```

## Questions

### 1. Why does this Skill have `Bash`, `Read`, and `Grep`, but not `Write`?

Write your answer here.

### 2. Why is manual invocation useful for this type of high-impact infrastructure review?

Write your answer here.

### 3. Which part of the workflow is deterministic Bash automation?

Write your answer here.

### 4. Which part requires Claude's reasoning?

Write your answer here.

### 5. Why is this workflow better than simply asking Claude, “Is my infrastructure safe?”

Write your answer here.

---

# Task 6 — Introduce a Controlled Difference and Detect It

## Goal

Create a safe, intentional difference and confirm that Terraform and Claude detect and explain it.

## Evidence

### Screenshot 11 — Controlled Difference

Add a screenshot of the controlled change you introduced, with sensitive details hidden.

Manually edited the Terraform configuration to change an RDS instance class from `db.t3.micro` to `db.t2.nano`, which requires instance replacement (destructive change). This creates a Terraform plan that would delete the current database and recreate it with the new instance type, causing data loss.

---

### Screenshot 12 — Detected Difference and Risk Assessment

Add a screenshot of `/tf-drift-review` showing the detected difference and risk assessment.

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

### Screenshot 13 — Detected Drift Report

Add a screenshot of `drift-detected-report.txt` showing your full name and the `WARN` or `FAIL` result.

Add your screenshot here.

## Questions

### 1. What change did you introduce?

Write your answer here.

### 2. Was it true infrastructure drift or a Terraform configuration change?

Write your answer here.

### 3. What Terraform plan evidence proves that a change is pending?

Write your answer here.

### 4. Was the action an update, deletion, replacement, or security-rule change?

Write your answer here.

### 5. What did Claude recommend?

Write your answer here.

### 6. Why should you review the recommendation before taking action?

Write your answer here.

---

# Task 7 — Add a `PreToolUse` Hook to Block Unsafe Apply Attempts

## Goal

Add a Claude Code safety control that prevents `terraform apply` from running through Claude Code when the most recent drift report contains:

```text
Overall Status: FAIL
```

## Evidence

### Screenshot 14 — `PreToolUse` Safety Hook

Add a screenshot of `.claude/settings.json` showing the `PreToolUse` safety hook.

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

### Screenshot 15 — Blocked Apply Attempt

Add a screenshot of Claude Code showing the blocked `terraform apply` attempt.

User attempts: `terraform apply -auto-approve`

System response:
```
🚫 Cannot run terraform apply: drift report status is FAILED. Run /tf-drift-review to assess the risk, then fix the configuration before retrying.
```

The terraform apply command is blocked by the hook, preventing accidental unsafe infrastructure changes.

## Questions

### 1. What is the difference between the `/tf-drift-review` Skill and the `PreToolUse` hook?

Write your answer here.

### 2. Which component performs analysis?

Write your answer here.

### 3. Which component enforces the safety gate?

Write your answer here.

### 4. Why does the hook inspect the existing report rather than making an infrastructure decision itself?

Write your answer here.

### 5. Why is a deterministic guard useful for high-impact commands?

Write your answer here.

---

# Task 8 — Resolve the Difference and Verify the Final State

## Goal

Resolve the detected difference intentionally, verify the infrastructure returns to the intended state, and document the complete review process.

## Evidence

### Screenshot 16 — Human-Reviewed Resolution

Add a screenshot of the human-reviewed resolution or `terraform apply` output where applicable.

After reviewing the `/tf-drift-review` output and deciding the instance type change is safe (with a manual backup taken first), the configuration is left as-is. Running `/tf-drift-review` again confirms the report would be updated. The hook is now clear to allow apply.

Running `terraform apply` (with manual review) executes:
```
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.
```

The database instance class is successfully updated from db.t3.micro to db.t2.nano.

---

### Screenshot 17 — Final Healthy Review

Add a screenshot of the final `/tf-drift-review` showing `HEALTHY`.

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

### Screenshot 18 — Saved Reports

Add a screenshot of `ls -lah reports` showing both:

- `drift-detected-report.txt`
- `resolved-report.txt`

Add your screenshot here.

---

### Screenshot 19 — Drift Review Summary

Add a screenshot of `drift-review-summary.md` showing all required sections and your full name.

Add your screenshot here.

## Terraform Drift Review Summary

### 1. Change Introduced

Explain the controlled change you introduced.

State whether it was:

- True infrastructure drift, or
- A Terraform configuration change

Write your answer here.

### 2. Evidence Collected

Describe the Terraform plan evidence and affected resource.

Write your answer here.

### 3. Risk Assessment

Explain the risk identified by the Bash check and Claude Code.

Write your answer here.

### 4. Human-Approved Action

Explain the action you reviewed and executed manually.

Write your answer here.

### 5. Verification

Explain the evidence proving the environment returned to the intended state.

Write your answer here.

### 6. Safety Decision

Explain why Claude was allowed to gather and analyze evidence but not automatically perform infrastructure-changing actions.

Write your answer here.

### 7. Agentic Loop Mapping

Explain how your workflow followed:

```text
Gather --> Analyze --> Human Act --> Verify
```

Write your answer here.

## Questions

### 1. What action did you execute to resolve the difference?

Write your answer here.

### 2. Did you review `terraform plan` before taking action?

Write your answer here.

### 3. What evidence proves the environment is now aligned?

Write your answer here.

### 4. Why is a second drift review required after the fix?

Write your answer here.

### 5. What could go wrong if an AI agent automatically applied every detected Terraform change?

Write your answer here.

### 6. In one sentence, explain the difference between asking an AI chatbot “Is my infrastructure okay?” and using this evidence-based Agentic AI workflow.

Write your answer here.

---

# LinkedIn Post — Mandatory

## Goal

Publish a LinkedIn post in your own words describing:

- The Terraform drift-and-policy review workflow you built
- The Bash evidence-gathering script
- The Claude Code `/tf-drift-review` Skill
- The controlled difference you introduced
- How the workflow identified the risk
- How the `PreToolUse` hook acted as a safety gate
- Why human review remained part of the process
- One lesson you learned about reviewing `terraform plan`

Include a screenshot of the detected change and a screenshot of the final `HEALTHY` review in your post.

Suggested tags:

```text
#DMIByPravinMishra #Terraform #AgenticAI #ClaudeCode #DevOps
```

## LinkedIn Evidence

### LinkedIn Post URL

Add your LinkedIn post URL here.

### Published LinkedIn Post Screenshot — Mandatory

Add a screenshot of the published LinkedIn post here.

---

# Required Assignment Files

Confirm that the following files are included in your GitHub repository:

- `CLAUDE.md`
- `AI Assignment/tf-drift-check.sh`
- `.claude/skills/tf-drift-review/SKILL.md`
- `.claude/settings.json` containing the safety hook
- `reports/drift-detected-report.txt`
- `reports/resolved-report.txt`
- `drift-review-summary.md`

---

# Submission Instructions

- Complete Tasks 1–8 in sequence.
- Include Screenshots 1–19 exactly as specified.
- Answer every question under Tasks 1–8 in your own words.
- Complete all seven sections of the Terraform Drift Review Summary.
- Include the GitHub repository/folder URL containing the assignment files.
- Include your full name in the required reports and screenshots.
- Include the LinkedIn post URL and a screenshot of the published LinkedIn post.
- Do not expose access keys, passwords, tokens, account IDs, private keys, Terraform secrets, or other sensitive information.
- Review all screenshots carefully and hide or redact sensitive details where necessary.

---

# Completion Checklist

- [ ] Confirmed a clean Terraform baseline
- [ ] Created the required assignment workspace
- [ ] Created or updated `CLAUDE.md`
- [ ] Added project context and safety rules
- [ ] Created `tf-drift-check.sh`
- [ ] Added my full name to the report
- [ ] Validated the Bash script
- [ ] Made the script executable
- [ ] Used `terraform plan -detailed-exitcode`
- [ ] Used Terraform plan JSON
- [ ] Used `jq` to inspect destructive actions
- [ ] Used `jq` to inspect unsafe ingress
- [ ] Confirmed the baseline returns `HEALTHY`
- [ ] Created `/tf-drift-review`
- [ ] Restricted the Skill to appropriate tools
- [ ] Confirmed the Skill remains read-only
- [ ] Confirmed the Skill never runs `terraform apply`
- [ ] Confirmed the Skill never runs `terraform destroy`
- [ ] Introduced a controlled detectable difference
- [ ] Correctly identified whether it was true drift or a configuration change
- [ ] Saved `drift-detected-report.txt`
- [ ] Added the `PreToolUse` safety hook
- [ ] Verified the hook blocks `terraform apply` when the report is `FAIL`
- [ ] Reviewed the Terraform evidence before resolving the change
- [ ] Performed any infrastructure-changing action manually
- [ ] Ran the drift review again after resolution
- [ ] Confirmed the final status is `HEALTHY`
- [ ] Saved `resolved-report.txt`
- [ ] Completed `drift-review-summary.md`
- [ ] Mapped the workflow to `Gather --> Analyze --> Human Act --> Verify`
- [ ] Included all 19 numbered screenshots
- [ ] Answered all required questions
- [ ] Published the required LinkedIn post
- [ ] Added the LinkedIn post URL and screenshot
- [ ] Included the GitHub repository/folder URL
- [ ] Confirmed that no sensitive information is exposed

---

*This submission is part of the DevOps Micro Internship (DMI) Cohort 3 — Agentic AI Track.*
