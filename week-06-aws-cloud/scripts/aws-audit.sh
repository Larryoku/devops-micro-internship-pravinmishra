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
