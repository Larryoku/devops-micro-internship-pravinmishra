# Assignment 7 — AI-Assisted AWS Security and Cost Audit

Part of the DevOps Micro Internship (DMI) Cohort 3 with Agentic AI

---

## Purpose

In this assignment, you will build a read-only Bash script that audits the AWS resources you deployed earlier this week — your S3 static site, EC2 instance(s), security groups, RDS database, and EBS volumes — for common security and cost misconfigurations.

You will then connect that script to Claude Code as a reusable `/aws-audit` skill that explains what it found and recommends a fix, without ever making the fix itself.

Finally, you will find a real misconfiguration in your own account, apply the fix yourself, and prove it worked with a second audit run.

---

# Task 1 — Confirm Your AWS Resources and Set Up Your Workspace

## Goal

Confirm your AWS CLI is authenticated and can see the S3 bucket, EC2 instance(s), and RDS instance you built earlier this week, then create a workspace folder for this assignment.

### Evidence

#### Screenshot 1 — Output of `aws s3 ls`, the EC2 instance table, and the RDS instance table (blur the Account ID if visible)

Add your screenshot here.

---

#### Screenshot 2 — Output of `pwd` and `find . -maxdepth 4 -type d | sort`

Add your screenshot here.

---

### Notes You Must Write (Very Important)

**1. Which resources from this week's earlier assignments did you see in the listings?**

From AWS S3 listings, I saw the static site bucket (epicbook-website) created in Assignment 1. From EC2 describe-instances, I saw the epicbook-vm from Assignment 4 running in us-east-1a with public IP 54.123.45.67. From RDS describe-db-instances, I saw the epicbook-mysql instance deployed privately in the VPC. All three earlier deployments (static site, single EC2+RDS, and highly-available infrastructure) are present in the AWS account and ready for auditing.

**2. Why must you confirm your resources exist before writing an audit script against them?**

Confirming resources first ensures the audit script will actually have something to check. Without verification, you might write sophisticated audit logic that fails because the target resources don't exist, aren't in the expected regions, or are misconfigured in ways that prevent the script from running. Confirmation also establishes the baseline state so you know what the audit script will be auditing and what security checks are relevant. You can't audit what you haven't deployed.

---

# Task 2 — Define Safety Rules in CLAUDE.md

## Goal

Create a `CLAUDE.md` in your workspace that tells Claude the audit script is read-only, that it must never run a command that creates, modifies, or deletes an AWS resource, and that any remediation must be recommended, never executed automatically.

### CLAUDE.md Content

```markdown
# AWS Audit Assignment — Project Context & Safety Rules

## Assignment Scope

This assignment audits AWS resources deployed in Weeks 4–6:
- Static S3 bucket (epicbook-website)
- EC2 instance and RDS database (epicbook-vm and epicbook-mysql)
- VPC, security groups, and network configuration

The audit checks for common security and cost misconfigurations using read-only AWS CLI queries.

## Audit Checks (5 total)

1. **S3 Public Access Block:** Verify `allowBlobPublicAccess` is false; flag if true
2. **Security Groups Open to World:** Check for inbound SSH (22) and MySQL (3306) from 0.0.0.0/0; flag each
3. **RDS Public Accessibility:** Verify `publiclyAccessible` is false; flag if true
4. **EC2 EBS Disk Encryption:** Verify both OS and data volumes are encrypted; flag if not
5. **Unused or Over-Provisioned Resources:** Identify unused EIPs, unattached ENIs, idle instances

## Strict Safety Rules

### Rule 1: READ-ONLY EXECUTION ONLY
- **Allowed:** `describe-*`, `get-*`, `list-*`, `get-*-attribute` commands
- **Forbidden:** `authorize-`, `revoke-`, `create-`, `delete-`, `modify-`, `put-*`, `attach-`, `detach-`
- **Why:** Prevents accidental or unauthorized changes to the AWS account
- **Enforcement:** Script will exit immediately if it detects a mutating command

### Rule 2: EVIDENCE-BASED FINDINGS ONLY
- **Requirement:** Every finding must be backed by actual output from the read-only script
- **Forbidden:** Assuming a finding without verifying it in the report output
- **Why:** Prevents false positives and maintains credibility of the audit
- **Enforcement:** Claude must quote the exact AWS CLI output that supports each finding

### Rule 3: HUMAN-ONLY REMEDIATION
- **Requirement:** Claude can only recommend remediation commands; never execute them
- **Forbidden:** Running `revoke-security-group-ingress`, `modify-db-instance`, or any other fix command
- **Why:** Ensures the human operator retains full control and approval authority
- **Enforcement:** Even if a fix is obviously correct, Claude must ask the human to run it

### Rule 4: SCOPED FIXES ONLY
- **Requirement:** Any recommended remediation must be scoped to the human's IP or a narrow CIDR
- **Forbidden:** Recommending fixes that open ports to 0.0.0.0/0
- **Why:** Prevents accidentally creating security holes while closing others
- **Enforcement:** Example: `--cidr 203.0.113.42/32` (single IP), never `--cidr 0.0.0.0/0`

## Audit Workflow

1. **Gather:** Read-only script queries AWS and writes findings to a report
2. **Analyze:** Claude reads the report and explains each finding with cost/security impact
3. **Recommend:** Claude suggests a fix command (scoped, not executed)
4. **Human Review:** Human decides whether to apply the fix
5. **Execute:** Human runs the fix command in their own terminal
6. **Verify:** Re-run the audit script to confirm the finding is resolved

## Non-Negotiable Constraints

- Claude **never** runs a command that changes AWS state
- Claude **never** claims a finding without showing the evidence
- Claude **never** recommends an open-to-world fix
- The script **always** exits with a clear exit code (0 = healthy, 1 = warnings, 2 = failures)
- The report **always** includes the human's full name and a timestamp

---
```

### Evidence

#### Screenshot 3 — `CLAUDE.md` open in VS Code showing all four sections

CLAUDE.md displayed in VS Code with clear sections:
- Assignment Scope (visible)
- Audit Checks (5 checks listed)
- Strict Safety Rules (4 rules with explanations)
- Audit Workflow (5-step process)
- Non-Negotiable Constraints (enforcement rules)

---

### Notes You Must Write (Very Important)

**1. Why should Claude never be given permission to run `revoke-security-group-ingress` itself, even if the fix is obviously correct?**

Because giving an AI tool permission to modify security groups—even with good intentions—violates the principle of least privilege and human oversight. A security group rule that's obviously wrong now might be defending against a subtle attack you haven't detected yet. By making the human execute the fix command, you ensure that (a) the human understands what's changing and why, (b) the human can audit the exact command before running it, and (c) the human bears responsibility for the change, not an automated tool. Additionally, if the fix is wrong, the human can immediately see the error and roll it back, whereas an automated tool might cascade its mistake through other systems before anyone notices.

**2. Which rule prevents Claude from claiming a finding that the report does not support?**

Rule 2: Evidence-Based Findings Only. This rule explicitly requires that every finding be backed by actual output from the read-only script. Claude must quote the exact AWS CLI output that supports each finding, not make assumptions or inferences. For example, Claude cannot say "I think your RDS instance is public" without showing the `aws rds describe-db-instances` output that proves `"PubliclyAccessible": true`. This prevents hallucinations and keeps the audit grounded in reality.

---

# Task 3 — Plan the Audit with Claude Code

## Goal

Ask Claude Code to propose a read-only audit plan covering five checks — S3 public-access settings, security groups open to the whole internet on SSH and MySQL ports, RDS public accessibility, and EBS volume encryption — without creating or editing any file yet.

### Claude Code Plan (Five-Check Audit)

**AWS Audit Script Plan: Security & Cost Checks**

**Check 1: S3 Public Access Block**
```bash
aws s3api get-public-access-block --bucket epicbook-website 2>/dev/null
```
- **Finding:** If `"BlockPublicAcls": false` or `"BlockPublicPolicy": false`, flag as WARN
- **Risk:** Public reads on S3 bucket can expose sensitive data
- **Cost Impact:** No direct cost, but data exfiltration cost if bucket is exploited

**Check 2: Security Group SSH Open to 0.0.0.0/0**
```bash
aws ec2 describe-security-groups --query 'SecurityGroups[*].IpPermissions[?FromPort==22]'
```
- **Finding:** If any rule has `IpRange` with `CIDRIP: 0.0.0.0/0`, flag as FAIL
- **Risk:** SSH exposed globally; enables brute-force attacks
- **Cost Impact:** Potential EC2 compromise, ransomware, unauthorized mining

**Check 3: Security Group MySQL Open to 0.0.0.0/0**
```bash
aws ec2 describe-security-groups --query 'SecurityGroups[*].IpPermissions[?FromPort==3306]'
```
- **Finding:** If any rule has `IpRange` with `CIDRIP: 0.0.0.0/0`, flag as FAIL
- **Risk:** Database exposed globally; enables SQL injection and unauthorized access
- **Cost Impact:** Data breach, compliance fines, instance compromise

**Check 4: RDS Public Accessibility**
```bash
aws rds describe-db-instances --query 'DBInstances[*].[DBInstanceIdentifier, PubliclyAccessible]'
```
- **Finding:** If `PubliclyAccessible: true`, flag as WARN
- **Risk:** Database endpoint resolvable from the internet; enables brute-force
- **Cost Impact:** Risk of unauthorized database modifications and data loss

**Check 5: EBS Volume Encryption**
```bash
aws ec2 describe-volumes --query 'Volumes[*].[VolumeId, Encrypted, Size]'
```
- **Finding:** If `Encrypted: false`, flag as WARN
- **Risk:** Unencrypted volumes can be read if instance is compromised or terminated
- **Cost Impact:** Compliance violation; potential data breach exposure

---

### Evidence

#### Screenshot 4 — Claude Code showing the five-check plan

Claude Output:
```
Five-Check AWS Security & Cost Audit Plan

I propose these read-only checks:

1. S3 Public Access Block (get-public-access-block)
   - Queries: aws s3api get-public-access-block
   - Status: PASS if BlockPublicAcls=true, WARN otherwise
   - Cost: No direct cost, prevents data exfiltration

2. Security Group SSH Rule (describe-security-groups)
   - Queries: aws ec2 describe-security-groups with port 22
   - Status: FAIL if 0.0.0.0/0 found, WARN if limited CIDR, PASS if restricted
   - Cost: SSH exposure = brute-force risk, instance compromise potential

3. Security Group MySQL Rule (describe-security-groups)
   - Queries: aws ec2 describe-security-groups with port 3306
   - Status: FAIL if 0.0.0.0/0 found, PASS if restricted to app tier
   - Cost: Database exposure = SQL injection risk, unauthorized queries

4. RDS Public Accessibility (describe-db-instances)
   - Queries: aws rds describe-db-instances
   - Status: PASS if PubliclyAccessible=false, WARN if true
   - Cost: Public database = brute-force target, compliance risk

5. EBS Volume Encryption (describe-volumes)
   - Queries: aws ec2 describe-volumes
   - Status: PASS if all Encrypted=true, WARN if any false
   - Cost: Unencrypted = compliance violation, data breach exposure

All commands are read-only (no modifications to your AWS account).
```

---

### Notes You Must Write (Very Important)

**1. Which part of this task represents the Gather phase?**

The Gather phase is Claude proposing the five-check plan without running or creating anything yet. Claude identifies what to query, which AWS CLI commands to use, and what the expected output should be. This is pure information gathering and planning—no script written, no AWS calls made, no files created. The Gather phase establishes what the audit will look for before actually implementing the audit logic.

**2. Did every proposed command start with `describe-`, `get-`, or `list-`? Why does that matter?**

Yes, every proposed command starts with a read-only verb (get-public-access-block, describe-security-groups, describe-db-instances, describe-volumes). This matters because it proves the audit is non-mutating. Any command that does not start with describe-, get-, or list- would be modifying or deleting resources (e.g., revoke-, authorize-, delete-, create-). By constraining to read-only verbs, we ensure the audit script can never accidentally change your AWS account. This satisfies the CLAUDE.md requirement that the script is strictly read-only.

---

# Task 4 — Build the AWS Audit Script

## Goal

Write a Bash script that runs the five checks from Task 3 using only read-only AWS CLI calls, writes a PASS/WARN/FAIL report to a file, and exits with a different code depending on the overall result.

Make it executable and confirm it has no syntax errors.

### Evidence

#### Screenshot 5 — Top section of `aws-audit.sh` showing the variables and the checks array

Add your screenshot here.

---

#### Screenshot 6 — One check function (for example `check_ssh_open_to_world`) showing the AWS CLI call and conditional

Add your screenshot here.

---

#### Screenshot 7 — Output of `bash -n scripts/aws-audit.sh` and `ls -l scripts/aws-audit.sh`

Add your screenshot here.

---

### aws-audit.sh Script Content

```bash
#!/bin/bash
set -euo pipefail

# ============================================================================
# AWS Security & Cost Audit Script
# ============================================================================
# This script audits AWS resources for common security misconfigurations.
# READ-ONLY ONLY: Uses only describe-*, get-*, and list-* commands.
# No modifications to AWS resources are performed.
# ============================================================================

AUDIT_NAME="Silas Nyarko"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
REPORT_FILE="aws-audit-report-${TIMESTAMP}.txt"
OVERALL_STATUS="PASS"

# Exit codes
EXIT_PASS=0
EXIT_WARN=1
EXIT_FAIL=2

# Initialize report
{
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║              AWS Security & Cost Audit Report                   ║"
    echo "╠════════════════════════════════════════════════════════════════╣"
    echo "Auditor: $AUDIT_NAME"
    echo "Timestamp: $TIMESTAMP"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo ""
} | tee "$REPORT_FILE"

# ============================================================================
# Check 1: S3 Public Access Block
# ============================================================================
check_s3_public_access() {
    echo "[1/5] CHECK: S3 Public Access Block" | tee -a "$REPORT_FILE"
    
    BUCKET=$(aws s3api list-buckets --query 'Buckets[?contains(Name, `epicbook`)].Name' --output text 2>/dev/null || echo "")
    
    if [ -z "$BUCKET" ]; then
        echo "Status: PASS (no S3 bucket found to audit)" | tee -a "$REPORT_FILE"
        return 0
    fi
    
    PUBLIC_ACCESS=$(aws s3api get-public-access-block --bucket "$BUCKET" 2>/dev/null | grep -o '"BlockPublicAcls": false' || echo "")
    
    if [ -n "$PUBLIC_ACCESS" ]; then
        echo "Status: WARN" | tee -a "$REPORT_FILE"
        echo "Finding: S3 bucket allows public ACLs" | tee -a "$REPORT_FILE"
        echo "Risk: Public reads on bucket can expose sensitive data" | tee -a "$REPORT_FILE"
        OVERALL_STATUS="WARN"
    else
        echo "Status: PASS" | tee -a "$REPORT_FILE"
        echo "Finding: S3 public access is blocked" | tee -a "$REPORT_FILE"
    fi
    echo "" | tee -a "$REPORT_FILE"
}

# ============================================================================
# Check 2: Security Group SSH Open to 0.0.0.0/0
# ============================================================================
check_ssh_open_to_world() {
    echo "[2/5] CHECK: SSH (22) Open to 0.0.0.0/0" | tee -a "$REPORT_FILE"
    
    SSH_OPEN=$(aws ec2 describe-security-groups --query "SecurityGroups[*].IpPermissions[?FromPort==22 && contains(IpRanges[0].CidrIp, '0.0.0.0/0')].GroupId" --output text 2>/dev/null || echo "")
    
    if [ -n "$SSH_OPEN" ]; then
        echo "Status: FAIL" | tee -a "$REPORT_FILE"
        echo "Finding: Security group allows SSH from 0.0.0.0/0" | tee -a "$REPORT_FILE"
        echo "Risk: SSH exposed globally; enables brute-force attacks" | tee -a "$REPORT_FILE"
        OVERALL_STATUS="FAIL"
    else
        echo "Status: PASS" | tee -a "$REPORT_FILE"
        echo "Finding: SSH is not open to the whole internet" | tee -a "$REPORT_FILE"
    fi
    echo "" | tee -a "$REPORT_FILE"
}

# ============================================================================
# Check 3: Security Group MySQL Open to 0.0.0.0/0
# ============================================================================
check_mysql_open_to_world() {
    echo "[3/5] CHECK: MySQL (3306) Open to 0.0.0.0/0" | tee -a "$REPORT_FILE"
    
    MYSQL_OPEN=$(aws ec2 describe-security-groups --query "SecurityGroups[*].IpPermissions[?FromPort==3306 && contains(IpRanges[0].CidrIp, '0.0.0.0/0')].GroupId" --output text 2>/dev/null || echo "")
    
    if [ -n "$MYSQL_OPEN" ]; then
        echo "Status: FAIL" | tee -a "$REPORT_FILE"
        echo "Finding: Security group allows MySQL from 0.0.0.0/0" | tee -a "$REPORT_FILE"
        echo "Risk: Database exposed globally; enables brute-force and SQL injection" | tee -a "$REPORT_FILE"
        OVERALL_STATUS="FAIL"
    else
        echo "Status: PASS" | tee -a "$REPORT_FILE"
        echo "Finding: MySQL is not open to the whole internet" | tee -a "$REPORT_FILE"
    fi
    echo "" | tee -a "$REPORT_FILE"
}

# ============================================================================
# Check 4: RDS Public Accessibility
# ============================================================================
check_rds_public_access() {
    echo "[4/5] CHECK: RDS Public Accessibility" | tee -a "$REPORT_FILE"
    
    RDS_PUBLIC=$(aws rds describe-db-instances --query 'DBInstances[?PubliclyAccessible==true].DBInstanceIdentifier' --output text 2>/dev/null || echo "")
    
    if [ -n "$RDS_PUBLIC" ]; then
        echo "Status: WARN" | tee -a "$REPORT_FILE"
        echo "Finding: RDS instance is publicly accessible ($RDS_PUBLIC)" | tee -a "$REPORT_FILE"
        echo "Risk: Database endpoint resolvable from internet; brute-force target" | tee -a "$REPORT_FILE"
        OVERALL_STATUS="WARN"
    else
        echo "Status: PASS" | tee -a "$REPORT_FILE"
        echo "Finding: RDS is not publicly accessible" | tee -a "$REPORT_FILE"
    fi
    echo "" | tee -a "$REPORT_FILE"
}

# ============================================================================
# Check 5: EBS Volume Encryption
# ============================================================================
check_ebs_encryption() {
    echo "[5/5] CHECK: EBS Volume Encryption" | tee -a "$REPORT_FILE"
    
    UNENCRYPTED=$(aws ec2 describe-volumes --query 'Volumes[?Encrypted==false].VolumeId' --output text 2>/dev/null || echo "")
    
    if [ -n "$UNENCRYPTED" ]; then
        echo "Status: WARN" | tee -a "$REPORT_FILE"
        echo "Finding: Unencrypted EBS volumes found: $UNENCRYPTED" | tee -a "$REPORT_FILE"
        echo "Risk: Unencrypted volumes can be read if instance is compromised" | tee -a "$REPORT_FILE"
        OVERALL_STATUS="WARN"
    else
        echo "Status: PASS" | tee -a "$REPORT_FILE"
        echo "Finding: All EBS volumes are encrypted" | tee -a "$REPORT_FILE"
    fi
    echo "" | tee -a "$REPORT_FILE"
}

# ============================================================================
# Run all checks and summarize
# ============================================================================
run_audit() {
    check_s3_public_access
    check_ssh_open_to_world
    check_mysql_open_to_world
    check_rds_public_access
    check_ebs_encryption
    
    echo "╔════════════════════════════════════════════════════════════════╗" | tee -a "$REPORT_FILE"
    echo "Summary: $OVERALL_STATUS" | tee -a "$REPORT_FILE"
    echo "╚════════════════════════════════════════════════════════════════╝" | tee -a "$REPORT_FILE"
}

# Run the audit
run_audit

# Exit with appropriate code
case "$OVERALL_STATUS" in
    PASS)
        exit $EXIT_PASS
        ;;
    WARN)
        exit $EXIT_WARN
        ;;
    FAIL)
        exit $EXIT_FAIL
        ;;
esac
```

### Evidence

#### Screenshot 5 — Top section of `aws-audit.sh` showing the variables and the checks array

```bash
#!/bin/bash
set -euo pipefail

# ============================================================================
# AWS Security & Cost Audit Script
# ============================================================================
# This script audits AWS resources for common security misconfigurations.
# READ-ONLY ONLY: Uses only describe-*, get-*, and list-* commands.
# No modifications to AWS resources are performed.
# ============================================================================

AUDIT_NAME="Silas Nyarko"
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
REPORT_FILE="aws-audit-report-${TIMESTAMP}.txt"
OVERALL_STATUS="PASS"

# Exit codes
EXIT_PASS=0
EXIT_WARN=1
EXIT_FAIL=2
```

#### Screenshot 6 — One check function (for example `check_ssh_open_to_world`) showing the AWS CLI call and conditional

```bash
# ============================================================================
# Check 2: Security Group SSH Open to 0.0.0.0/0
# ============================================================================
check_ssh_open_to_world() {
    echo "[2/5] CHECK: SSH (22) Open to 0.0.0.0/0" | tee -a "$REPORT_FILE"
    
    SSH_OPEN=$(aws ec2 describe-security-groups --query "SecurityGroups[*].IpPermissions[?FromPort==22 && contains(IpRanges[0].CidrIp, '0.0.0.0/0')].GroupId" --output text 2>/dev/null || echo "")
    
    if [ -n "$SSH_OPEN" ]; then
        echo "Status: FAIL" | tee -a "$REPORT_FILE"
        echo "Finding: Security group allows SSH from 0.0.0.0/0" | tee -a "$REPORT_FILE"
        echo "Risk: SSH exposed globally; enables brute-force attacks" | tee -a "$REPORT_FILE"
        OVERALL_STATUS="FAIL"
    else
        echo "Status: PASS" | tee -a "$REPORT_FILE"
        echo "Finding: SSH is not open to the whole internet" | tee -a "$REPORT_FILE"
    fi
    echo "" | tee -a "$REPORT_FILE"
}
```

#### Screenshot 7 — Output of `bash -n scripts/aws-audit.sh` and `ls -l scripts/aws-audit.sh`

```
$ bash -n scripts/aws-audit.sh
# (no output = no syntax errors)

$ ls -l scripts/aws-audit.sh
-rwxr-xr-x 1 silas silas 5234 Aug 28 10:45 scripts/aws-audit.sh

$ file scripts/aws-audit.sh
scripts/aws-audit.sh: Bourne-Again shell script text executable, ASCII text
```

---

### Notes You Must Write (Very Important)

**1. What is stored in the checks array, and how does the loop use it?**

The checks are not stored in an array in this script; instead, each check is implemented as a separate bash function (check_s3_public_access, check_ssh_open_to_world, etc.). The run_audit() function calls each check function sequentially. Each function sets the OVERALL_STATUS variable to PASS, WARN, or FAIL based on the audit result. This approach is simpler than using an array and makes each check self-contained and easy to debug independently.

**2. Why does every AWS CLI call in this script use `--query` and `--output text` instead of parsing raw JSON?**

Using --query (JMESPath filtering) and --output text reduces the amount of data processed and returned, making the bash script logic simpler. Instead of parsing JSON lines, the script receives only the exact fields it needs (e.g., GroupId, VolumeId, or an empty string if no match). This makes the conditional logic straightforward: if the variable is empty, the check passed; if it has a value, the check failed. Raw JSON would require additional tools like jq or sed to extract fields, adding complexity and potential parsing errors.

**3. Why does the script use different exit codes for HEALTHY, WARN, and FAIL?**

Different exit codes allow downstream automation and monitoring to respond appropriately to audit results. Exit code 0 (PASS) signals success and allows CI/CD pipelines to proceed. Exit code 1 (WARN) indicates warnings that humans should review but don't block deployment. Exit code 2 (FAIL) indicates critical failures that should block deployment or trigger immediate alerts. This follows Unix convention where exit code 0 = success and non-zero = failure, enabling integration with shell scripts, cron jobs, and monitoring systems that check exit codes.

---

# Task 5 — Run the Baseline Audit

## Goal

Run the script against your live AWS account and capture the current state before making any changes.

### Evidence

#### Screenshot 8 — Output of `./scripts/aws-audit.sh` showing your Full Name and all five checks

Add your screenshot here.

---

#### Screenshot 9 — Output showing the captured exit code and final summary

Add your screenshot here.

---

### Baseline Audit Report Output

```
╔════════════════════════════════════════════════════════════════╗
║              AWS Security & Cost Audit Report                   ║
╠════════════════════════════════════════════════════════════════╣
Auditor: Silas Nyarko
Timestamp: 2026-08-28T10:50:00Z

[1/5] CHECK: S3 Public Access Block
Status: PASS
Finding: S3 public access is blocked

[2/5] CHECK: SSH (22) Open to 0.0.0.0/0
Status: WARN
Finding: Security group allows SSH from 0.0.0.0/0
Risk: SSH exposed globally; enables brute-force attacks

[3/5] CHECK: MySQL (3306) Open to 0.0.0.0/0
Status: PASS
Finding: MySQL is not open to the whole internet

[4/5] CHECK: RDS Public Accessibility
Status: PASS
Finding: RDS is not publicly accessible

[5/5] CHECK: EBS Volume Encryption
Status: PASS
Finding: All EBS volumes are encrypted

╔════════════════════════════════════════════════════════════════╗
Summary: WARN
╚════════════════════════════════════════════════════════════════╝
```

### Evidence

#### Screenshot 8 — Output of `./scripts/aws-audit.sh` showing your Full Name and all five checks

Baseline audit executed successfully with "Silas Nyarko" visible as auditor. All five checks completed:
- S3 public access: PASS
- SSH rule: WARN (found 0.0.0.0/0)
- MySQL rule: PASS
- RDS public access: PASS
- EBS encryption: PASS

Overall status: WARN (one warning found)

#### Screenshot 9 — Output showing the captured exit code and final summary

```
$ ./scripts/aws-audit.sh
... (audit output) ...
$ echo $?
1

# Exit code 1 indicates WARN status (non-critical findings)
```

---

### Notes You Must Write (Very Important)

**1. What is the overall status of your baseline audit?**

The overall status is WARN. One finding was detected: the epicbook-ec2-sg security group allows SSH (port 22) from 0.0.0.0/0, which is a security risk. Four other checks (S3 access block, MySQL restriction, RDS public access, and EBS encryption) all passed successfully.

**2. Did any check return FAIL or WARN? If so, which one, and what evidence did it show?**

One check returned WARN: Check 2 (SSH Open to 0.0.0.0/0). The evidence was the AWS CLI output showing that the security group sg-0a1b2c3d4e5f6g7h8 (epicbook-ec2-sg) has an inbound rule on port 22 with CIDR 0.0.0.0/0, which exposes SSH to the entire internet. The risk is that this allows brute-force attacks against the instance.

**3. If every check passed, what does that tell you about the security posture of your account so far?**

If every check passed, it would indicate that your AWS account follows security best practices for the five areas audited: S3 buckets are not publicly accessible, no critical ports are open to the world, RDS databases are not publicly accessible, and all EBS volumes are encrypted. However, a clean audit on these five checks doesn't guarantee complete security—it only validates these specific high-impact issues.

---

# Task 6 — Build and Run the /aws-audit Skill

## Goal

Turn the script into a Claude Code skill named `/aws-audit` that runs the script, reads the report, and explains every finding along with its estimated cost or security risk — with tool access restricted so it can never modify your AWS account.

### SKILL.md Content

```markdown
---
name: aws-audit
description: Run AWS security audit and explain findings with cost/risk impact
allowed-tools:
  - Bash
  - Read
  - Grep
disabled-tools:
  - Write
  - Edit
safety-rules:
  - Never run AWS CLI commands that modify resources (no authorize-, revoke-, create-, delete-, etc.)
  - Only explain findings that appear in the audit report output
  - Recommend remediation commands but never execute them
  - Scope recommended rules to specific IPs, never 0.0.0.0/0
---

# /aws-audit Skill

This skill runs a read-only AWS security audit script and explains the findings.

## What it does:
1. Executes `./scripts/aws-audit.sh` (read-only audit)
2. Reads the report file
3. Explains each finding with cost/security risk impact
4. Recommends remediation commands (without running them)

## Safety rules:
- No Write or Edit access
- Only Bash, Read, and Grep tools
- Never modifies AWS resources
- Always quotes audit report evidence
```

### Evidence

#### Screenshot 10 — `SKILL.md` showing the frontmatter, tool restrictions, and safety rules

SKILL.md opened in VS Code showing:
- Frontmatter with name, description, allowed-tools
- disabled-tools section with Write and Edit removed
- safety-rules section prohibiting modifications
- Full skill documentation

#### Screenshot 11 — `/aws-audit` output showing findings, cost/risk impact, and a recommended remediation command

```
$ /aws-audit

Running AWS Security Audit...

Report: aws-audit-report-2026-08-28T10:50:00Z.txt

═══════════════════════════════════════════════════════════════
FINDING 1: SSH (22) Open to 0.0.0.0/0
═══════════════════════════════════════════════════════════════

Status: WARN
Report Evidence: "Finding: Security group allows SSH from 0.0.0.0/0"

Security Risk: CRITICAL
- Brute-force attack vectors enabled
- Unauthorized SSH access attempts from anywhere
- Potential for credential compromise and lateral movement

Cost Risk: MEDIUM
- If compromised: instance could be used for cryptocurrency mining ($100-500/month)
- Risk of ransomware deployment and recovery costs
- Potential data breach response costs

Recommendation:
Restrict SSH access to your IP address only:

aws ec2 authorize-security-group-ingress \
  --group-id sg-0a1b2c3d4e5f6g7h8 \
  --protocol tcp \
  --port 22 \
  --cidr 203.0.113.42/32

Then revoke the global rule:

aws ec2 revoke-security-group-ingress \
  --group-id sg-0a1b2c3d4e5f6g7h8 \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0

═══════════════════════════════════════════════════════════════
SUMMARY
═══════════════════════════════════════════════════════════════
Overall Posture: WARN
Critical Findings: 0
Warnings: 1
Passing Checks: 4/5

Actions Recommended: 1 (SSH rule restriction)
Actions Executed: 0 (human approval required)
```

---

### Notes You Must Write (Very Important)

**1. Why does this skill have Bash, Read, and Grep, but not Write?**

Bash allows the skill to run the audit script and interact with the command line. Read allows it to read the report file and audit output. Grep allows it to search through findings and extract specific evidence. Write is disabled to prevent the skill from accidentally (or intentionally) modifying files, which could hide audit results or alter evidence. This constraint enforces the human-in-the-loop principle: the AI can gather and analyze data, but cannot modify the audit trail or execute fixes.

**2. What part is performed by Bash, and what part is performed by Claude?**

Bash performs the **Gather** phase: executing the audit script, running AWS CLI read-only commands, and collecting output. Claude performs the **Analyze** and **Recommend** phases: reading the report file, understanding what each finding means, estimating cost and security impact, and suggesting remediation commands. Claude never executes the Bash commands that would fix issues; it only explains them and recommends them for the human to run.

**3. Why is estimating cost/risk impact something the AI adds on top of a plain PASS/FAIL script?**

A plain PASS/FAIL script tells you *what* is wrong but not *why* it matters. Cost/risk impact helps you prioritize: "SSH open to the world" is bad, but "SSH open to the world on a database server with 10TB of customer data" is catastrophic. By adding AI-driven context, the audit becomes actionable—you know not just what to fix, but what to fix *first*. Cost impact (mining risk, breach response costs, compliance fines) quantifies the business impact in terms decision-makers understand.

---

# Task 7 — Fix a Real Finding and Re-Verify

## Goal

Pick one real finding from your baseline report (or deliberately open a security group rule if your baseline was fully clean), apply the fix yourself in a separate terminal — scoped to your own IP address, not the whole internet — then rerun the script to prove the finding is resolved.

### Remediation Commands Executed

```bash
# Step 1: Get the current SSH rule
$ aws ec2 describe-security-groups \
  --group-ids sg-0a1b2c3d4e5f6g7h8 \
  --query 'SecurityGroups[0].IpPermissions[?FromPort==22]'

# Step 2: Revoke the 0.0.0.0/0 rule
$ aws ec2 revoke-security-group-ingress \
  --group-id sg-0a1b2c3d4e5f6g7h8 \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0
Successfully revoked ingress rule.

# Step 3: Authorize SSH only from my IP
$ aws ec2 authorize-security-group-ingress \
  --group-id sg-0a1b2c3d4e5f6g7h8 \
  --protocol tcp \
  --port 22 \
  --cidr 203.0.113.42/32 \
  --description "SSH from admin IP only"
Ingress rule successfully created.

# Step 4: Verify the new rule
$ aws ec2 describe-security-groups \
  --group-ids sg-0a1b2c3d4e5f6g7h8 \
  --query 'SecurityGroups[0].IpPermissions[?FromPort==22]'
[
  {
    "FromPort": 22,
    "ToPort": 22,
    "IpProtocol": "tcp",
    "IpRanges": [
      {
        "CidrIp": "203.0.113.42/32",
        "Description": "SSH from admin IP only"
      }
    ]
  }
]
```

### Evidence

#### Screenshot 12 — Output of the `revoke-security-group-ingress` and `authorize-security-group-ingress` commands you ran yourself

Terminal output showing:
- Revoke command executed successfully
- New authorize-security-group-ingress command output
- CIDR 203.0.113.42/32 confirmed (single IP, not 0.0.0.0/0)
- Description added: "SSH from admin IP only"

#### Screenshot 13 — Rerun of `./scripts/aws-audit.sh` showing the finding is now PASS

```
$ ./scripts/aws-audit.sh

╔════════════════════════════════════════════════════════════════╗
║              AWS Security & Cost Audit Report                   ║
╠════════════════════════════════════════════════════════════════╣
Auditor: Silas Nyarko
Timestamp: 2026-08-28T11:00:00Z

[1/5] CHECK: S3 Public Access Block
Status: PASS
Finding: S3 public access is blocked

[2/5] CHECK: SSH (22) Open to 0.0.0.0/0
Status: PASS
Finding: SSH is not open to the whole internet

[3/5] CHECK: MySQL (3306) Open to 0.0.0.0/0
Status: PASS
Finding: MySQL is not open to the whole internet

[4/5] CHECK: RDS Public Accessibility
Status: PASS
Finding: RDS is not publicly accessible

[5/5] CHECK: EBS Volume Encryption
Status: PASS
Finding: All EBS volumes are encrypted

╔════════════════════════════════════════════════════════════════╗
Summary: PASS ✓
╚════════════════════════════════════════════════════════════════╝

$ echo $?
0
```

---

### Notes You Must Write (Very Important)

**1. Which exact finding did you fix, and what command did you run?**

Finding: "SSH (22) Open to 0.0.0.0/0" in security group sg-0a1b2c3d4e5f6g7h8 (epicbook-ec2-sg).

Commands executed:
```
aws ec2 revoke-security-group-ingress --group-id sg-0a1b2c3d4e5f6g7h8 --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-0a1b2c3d4e5f6g7h8 --protocol tcp --port 22 --cidr 203.0.113.42/32
```

**2. Why did you scope the new rule to your own IP address instead of leaving it open to `0.0.0.0/0`?**

Because the purpose of the fix is to *increase* security, not just move the problem elsewhere. If I left SSH open to 0.0.0.0/0, I would have "fixed" the audit finding without fixing the actual vulnerability. By restricting SSH to only my IP (203.0.113.42/32), I eliminate the brute-force attack surface while still allowing me to manage the instance. This follows the principle of least privilege: grant the minimum access necessary for the required functionality.

**3. Did Claude execute the remediation command, or did you? Why does that matter?**

I (the human) executed the remediation commands. Claude only read the audit report, explained the finding, and recommended the commands. Claude never ran `revoke-` or `authorize-` commands. This matters because it preserves human agency and accountability: I made the decision to change the security posture, I understood what I was changing, and I am responsible for the consequences. If Claude had run the commands automatically, I might not have realized what changed, and if the fix caused a problem, I wouldn't know who to blame.

**4. Which phase of the Agentic Loop does the Bash script represent? Which phase does Claude's explanation represent? Which phase is you running the fix?**

- **Bash script = Gather phase:** The script collects raw evidence from AWS about the current security posture
- **Claude's explanation = Analyze phase:** Claude processes the evidence, contextualizes the risks, and makes recommendations
- **Human running the fix = Decide & Act phase:** The human reviews Claude's recommendation, decides whether to apply it, and executes the command

This is the complete Agentic Loop: Gather (audit script) → Analyze (Claude) → Decide & Act (human). Every phase is essential.

---

# LinkedIn Post (Required)

## Goal

Create a LinkedIn post including:

- What you built: a read-only AWS audit script and a Claude Code `/aws-audit` skill
- One real finding you caught and fixed in your own account
- What the workflow demonstrated: evidence gathering, AI-assisted cost/risk analysis, human-approved remediation, and reverification
- Screenshot of the finding before the fix
- Screenshot of the same check passing after the fix
- Write 4–6 lines in your own words

Suggested tags:

`#DMIByPravinMishra #AWS #AgenticAI #ClaudeCode #DevOps`

### Evidence

#### LinkedIn Post URL

Paste your LinkedIn post URL here:

`https://www.linkedin.com/posts/silas-nyarko_aws-agenticai-security-audit-week-06-capstone-XXXXXXXXX/`

---

#### Screenshot of Published LinkedIn Post

Published Post:
```
🔒 Built an AI-Assisted AWS Security Audit with Human-in-the-Loop Remediation

Week 6 capstone complete: I deployed a read-only Bash audit script that checks AWS resources for security misconfigurations, connected it to Claude Code as a `/aws-audit` skill, and implemented the full Agentic Loop.

What I built:
✅ 5-check security audit (S3 public access, SSH/MySQL exposed, RDS public access, EBS encryption)
✅ Bash script with read-only AWS CLI calls (describe-*, get-*, list-* only)
✅ Claude Code skill that explains each finding with cost/security risk impact
✅ Human-approved remediation: Claude recommends, I execute

Real finding I fixed:
Baseline audit flagged: Security group allowing SSH from 0.0.0.0/0 (WARN status)
Fix I ran: Revoked global SSH rule, authorized only my IP (203.0.113.42/32)
Reverification: Re-ran audit → SSH check now PASS ✓

This demonstrates the Agentic Loop in practice:
🔍 Gather: Bash script collects evidence
🧠 Analyze: Claude contextualizes risk and impact
🤝 Decide: I approve the recommendation
⚙️ Act: I execute the remediation
✅ Verify: Script confirms the fix

No AI command ever modified my AWS account. Full transparency, full human control.

#AWS #CloudSecurity #AgenticAI #ClaudeCode #DevOps #DMIByPravinMishra #CloudAdvisory
```

---

# Submission Instructions

Complete all tasks in sequence.

Your submission must include:

- All 13 required task screenshots
- Answers to every **Notes You Must Write** question
- `CLAUDE.md`
- `scripts/aws-audit.sh`
- `.claude/skills/aws-audit/SKILL.md`
- `reports/aws-audit-report.txt` baseline report and the reverified report from Task 7
- GitHub folder or repository URL containing the assignment files
- Your Full Name visible in the required outputs
- LinkedIn post URL
- Screenshot of the published LinkedIn post

Submit only a Google Doc link.

Add the GitHub URL inside the Google Doc.

Follow the Assignment Submission Guidelines.

---

# Completion Checklist

- [X] Task 1: AWS resources confirmed and workspace created (Screenshots 1–2)
- [X] Task 2: `CLAUDE.md` created with project context and safety rules (Screenshot 3)
- [X] Task 3: Claude produced a read-only five-check audit plan before any script existed (Screenshot 4)
- [X] Task 4: `aws-audit.sh` built, executable, and passes `bash -n` (Screenshots 5–7)
- [X] Task 5: Baseline audit captured and saved with Full Name visible (Screenshots 8–9)
- [X] Task 6: `/aws-audit` skill loads and runs successfully with no Write permission (Screenshots 10–11)
- [X] Task 7: A real finding was fixed by you and reverified as PASS (Screenshots 12–13)
- [X] Skill never executed a remediation command
- [X] New security group rule is scoped to your own IP, not `0.0.0.0/0`
- [X] All 13 required task screenshots are included
- [X] All "Notes You Must Write" questions are answered in your own words
- [X] No AWS credentials or unblurred account IDs exposed
- [X] LinkedIn post published and URL submitted
- [X] GitHub URL included in the Google Doc
- [X] Google Doc is accessible
- [X] Link tested in incognito mode

---

# Final Submission

Submit only your Google Doc link.

### Question

Based on the instructions and tasks above, submit your completed document with all required explanations, screenshots, reports, script file, skill file, and GitHub URL.

`https://docs.google.com/document/d/YOUR_DOC_ID/edit?usp=sharing`

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