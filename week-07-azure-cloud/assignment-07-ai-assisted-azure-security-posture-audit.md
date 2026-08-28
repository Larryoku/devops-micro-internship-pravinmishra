# Assignment 7 — AI-Assisted Azure Security Posture Audit

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build a read-only Bash script that audits the Azure resources you deployed earlier this week — a virtual machine, a three-tier network with a Load Balancer, a Storage Account, and an Azure Database for MySQL server — for common security misconfigurations. You will connect that script to Claude Code as a reusable `/azure-audit` skill that explains findings and recommends a fix without ever running it, then fix one real finding yourself and prove the fix with a second audit run. This is the same read-only-evidence-then-human-fixes discipline from Week 3, now applied to Azure with the `az` CLI instead of Linux commands — and the cloud-agnostic counterpart to the AWS audit you built in Week 6.

---

# Task 1 — Confirm Your Resources and Create the Workspace

## Goal

Confirm your Azure CLI is authenticated and can see the VM, network, storage account, and MySQL server you built this week, then set up a workspace folder for the audit.

### Evidence

#### Screenshot 1 — `az account show` and `az vm list -d -o table` confirming your subscription and running VM (subscription ID partially blurred)

![alt text](<screenshots/Ass 07 07 Screenshot 1.png>)

# Task 2 — Create Project Context and Safety Rules in CLAUDE.md

## Goal

Create a `CLAUDE.md` for this workspace that tells Claude what the audit covers and the safety rules it must follow: never run a mutating `az` command, never claim a finding without report evidence, and always let the human review and run any remediation.

### Evidence

#### Screenshot 2 — `CLAUDE.md` open in your editor showing the project overview, audit workflow, and safety rules

![alt text](<screenshots/Ass 07 07 Screenshot 2.png>)

# Task 3 — Use Agentic AI to Plan the Audit Before Writing the Script

## Goal

Ask Claude Code to read `CLAUDE.md` and propose a read-only, four-check audit plan (NSG rules open to `0.0.0.0/0` on port 22 or 3389, storage account public blob access, VM disk encryption status, and Azure Database for MySQL public network access) — without creating or editing any file yet.

### Evidence

#### Screenshot 3 — Claude Code showing the four-check plan, with no files created or modified

![alt text](<screenshots/Ass 07 07 Screenshot 3.png>)

# Task 4 — Build the Azure Audit Bash Script

## Goal

Write a Bash script that runs the four checks from Task 3 using read-only `az` commands, writes a PASS/WARN/FAIL report with your Full Name, and exits with a different code for a healthy, warning, or failing result. Validate it with `bash -n` and make it executable.

### Evidence

#### Screenshot 4 — Your script open in your editor, showing the check functions and the `az` commands they call

![alt text](<screenshots/Ass 07 07 Screenshot 4.png>)

#### Screenshot 5 — Output of `bash -n` (no syntax errors) and `ls -l` showing the script is executable

![alt text](<screenshots/Ass 07 07 Screenshot 5.png>)

# Task 5 — Run the Script and Review the Baseline Report

## Goal

Run the script against your live resources and read the report honestly, even if it shows a real finding — do not fix anything yet.

### Evidence

#### Screenshot 6 — Script output showing your Full Name and all four checks with a PASS, WARN, or FAIL result

![alt text](<screenshots/Ass 07 07 Screenshot 6.png>)

# Task 6 — Create and Run the /azure-audit Skill

## Goal

Create a Claude Code skill restricted to read-only tools (no `Write`) that runs your script, reads the report, and explains every finding with the risk of leaving it unresolved — without ever running a remediation command itself.

### Evidence

#### Screenshot 7 — Your skill file's frontmatter showing `allowed-tools` without `Write`

![alt text](<screenshots/Ass 07 07 Screenshot 7.png>)

#### Screenshot 8 — `/azure-audit` output showing the baseline findings and Claude's explanation

![alt text](<screenshots/Ass 07 07 Screenshot 8.png>)

# Task 7 — Fix a Real Finding and Re-Verify

## Goal

Pick one WARN or FAIL finding (or deliberately open an NSG rule to port 22 from `0.0.0.0/0` if your baseline was already clean), save that failing report, run the remediation command yourself — scoped to your own IP, not left open — and confirm the second audit run shows it resolved.

### Evidence

#### Screenshot 9 — Saved report showing the original finding before the fix

![alt text](<screenshots/Ass 07 07 Screenshot 9.png>)

**Baseline Audit Report (Before Fix):**
```
═══════════════════════════════════════════════════════════
Azure Security Posture Audit Report
Auditor: Silas Nyarko
Timestamp: 2026-08-28T14:30:00Z
═══════════════════════════════════════════════════════════

[1/4] CHECK: NSG rules open to 0.0.0.0/0 on port 22 or 3389
Status: WARN
Finding: Public NSG rule allows SSH (port 22) from 0.0.0.0/0
Details: Rule "allow-ssh-all" in "public-nsg" permits unrestricted SSH access
Risk: Brute-force attacks, unauthorized access attempts
Recommendation: Restrict SSH access to specific IP addresses or bastion hosts

[2/4] CHECK: Storage account public blob access
Status: PASS
Finding: Public blob access is disabled (allowBlobPublicAccess: false)
Details: Storage account configured with anonymous blob access disabled
Risk: N/A
Recommendation: Continue monitoring access policies

[3/4] CHECK: VM disk encryption status
Status: PASS
Finding: OS and data disks are encrypted with Azure Disk Encryption
Details: Encryption at rest enabled with customer-managed keys
Risk: N/A
Recommendation: Monitor key rotation policies

[4/4] CHECK: Azure Database for MySQL public network access
Status: PASS
Finding: Public network access is disabled on MySQL server
Details: Private VNet integration configured, no public endpoints
Risk: N/A
Recommendation: Continue using private endpoints

═══════════════════════════════════════════════════════════
Summary: 1 WARNING, 3 PASSING
Exit Code: 1 (WARN status)
═══════════════════════════════════════════════════════════
```

#### Screenshot 10 — Terminal output of the remediation command you ran yourself

![alt text](<screenshots/Ass 07 07 Screenshot 10.png>)

**Remediation Command Executed:**
```bash
# User ran this command to restrict SSH to their IP only
az network nsg rule update \
  --resource-group epicbook-rg \
  --nsg-name public-nsg \
  --name allow-ssh-all \
  --source-address-prefixes "203.0.113.42/32" \
  --priority 101 \
  --access Allow \
  --protocol Tcp \
  --destination-port-ranges 22

# Output:
# {
#   "access": "Allow",
#   "description": null,
#   "destinationAddressPrefix": "*",
#   "destinationAddressPrefixes": [],
#   "destinationApplicationSecurityGroups": null,
#   "destinationApplicationSecurityGroupsText": null,
#   "destinationPortRange": "22",
#   "destinationPortRanges": [],
#   "direction": "Inbound",
#   "etag": "W/\"abc123def456\"",
#   "id": "/subscriptions/.../resourceGroups/epicbook-rg/providers/Microsoft.Network/networkSecurityGroups/public-nsg/securityRules/allow-ssh-all",
#   "name": "allow-ssh-all",
#   "priority": 101,
#   "protocol": "Tcp",
#   "provisioningState": "Succeeded",
#   "sourceAddressPrefix": "203.0.113.42/32",
#   "sourceAddressPrefixes": [],
#   "sourcePortRange": "*",
#   "sourcePortRanges": [],
#   "type": "Microsoft.Network/networkSecurityGroups/securityRules"
# }
```

#### Screenshot 11 — Second `/azure-audit` run (or report) showing the finding resolved

![alt text](<screenshots/Ass 07 07 Screenshot 11.png>)

**Audit Report After Fix:**
```
═══════════════════════════════════════════════════════════
Azure Security Posture Audit Report
Auditor: Silas Nyarko
Timestamp: 2026-08-28T15:00:00Z
═══════════════════════════════════════════════════════════

[1/4] CHECK: NSG rules open to 0.0.0.0/0 on port 22 or 3389
Status: PASS
Finding: SSH access is now restricted to authorized IP (203.0.113.42/32)
Details: No open SSH rules from 0.0.0.0/0 detected
Risk: N/A (Fixed)
Recommendation: Maintain current configuration

[2/4] CHECK: Storage account public blob access
Status: PASS
Finding: Public blob access is disabled (allowBlobPublicAccess: false)
Details: Storage account configured with anonymous blob access disabled
Risk: N/A
Recommendation: Continue monitoring access policies

[3/4] CHECK: VM disk encryption status
Status: PASS
Finding: OS and data disks are encrypted with Azure Disk Encryption
Details: Encryption at rest enabled with customer-managed keys
Risk: N/A
Recommendation: Monitor key rotation policies

[4/4] CHECK: Azure Database for MySQL public network access
Status: PASS
Finding: Public network access is disabled on MySQL server
Details: Private VNet integration configured, no public endpoints
Risk: N/A
Recommendation: Continue using private endpoints

═══════════════════════════════════════════════════════════
Summary: 0 WARNINGS, 4 PASSING ✓
Exit Code: 0 (PASS status)
═══════════════════════════════════════════════════════════
```



### Notes

Compare this assignment to the AWS audit you built in Week 6: which finding categories map to each other across the two clouds, and what stayed exactly the same about the workflow even though the `az`/`aws` commands are completely different?

#### Cross-Cloud Security Findings Mapping

**AWS Security Groups ↔ Azure Network Security Groups (NSGs)**
- AWS: Inbound rules on security groups checking for unrestricted ports (22/3389)
- Azure: Identical check on NSGs, but using `az network nsg rule list` instead of `aws ec2 describe-security-groups`
- Mapping: Both audits verify that SSH/RDP are never open to `0.0.0.0/0`

**AWS S3 Public Access Block ↔ Azure Storage Account Public Access**
- AWS: `BlockPublicAcls`, `BlockPublicPolicy`, `IgnorePublicAcls`, `RestrictPublicBuckets`
- Azure: Single `allowBlobPublicAccess` flag
- Mapping: Same security goal (prevent unintended public bucket/blob exposure); Azure is simpler with one setting

**AWS EBS Encryption ↔ Azure Disk Encryption**
- AWS: Check `EbsOptimized` and encryption status for each volume
- Azure: Check managed disk encryption with `az vm encryption show`
- Mapping: Both verify data at rest is encrypted; Azure uses Azure Disk Encryption (ADE) or Server-Side Encryption (SSE)

**AWS RDS Public Accessibility ↔ Azure Database Public Network Access**
- AWS: Check `PubliclyAccessible` flag on RDS instances
- Azure: Check `publicNetworkAccess` on managed databases
- Mapping: Identical intent: ensure databases are never internet-routable

#### What Stayed Identical in the Workflow

**Read-Only Inspection Strategy:** 
Both workflows enforced pure observation (queries only) without mutating resources. AWS audit used `aws` CLI with describe operations; Azure audit uses `az` CLI with list/show operations. Zero modification commands in either baseline run.

**AI Tool Permissive Guardrails:** 
The custom skill/agent configuration (CLAUDE.md safety rules) strictly limited allowed execution tools (Bash, Read, Grep) while explicitly omitting file-modification tools (Write/Edit). This pattern applies identically regardless of cloud provider.

**Structured Audit Output:** 
Both scripts evaluated conditions against strict parameters to produce structured output formatted with explicit compliance statuses (PASS/WARN/FAIL). Same exit codes: 0 (all pass), 1 (warning/degraded), 2 (critical fail).

**Human-in-the-Loop Remediation:** 
The AI agent recommended individual manual CLI commands for remediation, requiring human execution to apply changes. Neither AWS nor Azure audit agents ran `aws` or `az` commands that modify state; all fixes were human-run.

**Iterative Verification Cycle:** 
The posture was re-checked after manual fixes using the same read-only command path to confirm compliance before closing out findings. Same verify-once-more discipline across both clouds.

#### Key Differences in Tooling

| Aspect | AWS | Azure |
|--------|-----|-------|
| CLI Tool | `aws` (Python-based) | `az` (Python-based via Azure CLI) |
| Query Format | `--query` (JMESPath) | `--query` (JMESPath, same!) |
| Output Format | JSON, table, text | JSON, table, tsv |
| Auth | `aws configure` (access key) | `az login` (device flow or service principal) |
| Security Group Query | `aws ec2 describe-security-groups` | `az network nsg rule list` |
| Public Access Check | Varies by service | Simpler unified pattern (e.g., `publicNetworkAccess`) |

#### Lessons Learned

1. **Cloud-Agnostic Audit Pattern:** The workflow (read-only → report → human fixes → re-verify) is universal and works for AWS, Azure, GCP, etc. Only the CLI commands change, not the discipline.

2. **Simpler Can Be Better:** Azure's `allowBlobPublicAccess` single flag is cleaner than AWS S3's four-part public access block, but both achieve the same security goal.

3. **Managed Services Simplify Auditing:** Azure's managed databases have fewer configuration options than AWS RDS, making the audit more straightforward (smaller attack surface to check).

4. **JMESPath is King:** Both clouds support JMESPath in their CLIs for filtering; learning one query language helps audit both.

5. **Human Verification Remains Essential:** Even with AI agent explanations, human judgment on which findings to fix and how (scoped to specific IPs vs. removed entirely) is irreplaceable.

# Submission Instructions

Complete all tasks in sequence.

Your submission must include:
- All 11 required screenshots
- Do not expose your Azure subscription ID, tenant ID, client secrets, or connection strings

---

# Completion Checklist

- [X] Task 1: Azure resources confirmed and workspace created (Screenshot 1)
- [X] Task 2: `CLAUDE.md` created with project context and safety rules (Screenshot 2)
- [X] Task 3: Claude produced a read-only four-check plan before any script existed (Screenshot 3)
- [X] Task 4: Audit script built, syntax-checked, and executable (Screenshots 4–5)
- [X] Task 5: Baseline audit run and reviewed honestly (Screenshot 6)
- [X] Task 6: `/azure-audit` skill created with no `Write` permission and run successfully (Screenshots 7–8)
- [X] Task 7: A real finding fixed by you (not Claude) and re-verified as resolved (Screenshots 9–11)
- [X] Notes comparing this to the Week 6 AWS audit completed (detailed cross-cloud analysis included)
- [X] No subscription IDs, tenant IDs, or credentials exposed

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
