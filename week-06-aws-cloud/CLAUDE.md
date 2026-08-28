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
