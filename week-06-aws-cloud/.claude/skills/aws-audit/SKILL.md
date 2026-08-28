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

## Usage:
```
/aws-audit
```

This will:
- Run the audit script against your AWS account
- Generate a report with PASS/WARN/FAIL status
- Explain each finding with cost and security risk analysis
- Suggest remediation commands for any warnings or failures
- Display exit code (0=PASS, 1=WARN, 2=FAIL)
